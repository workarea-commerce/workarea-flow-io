module Workarea
  module FlowIo
    class PriceApplier
      def self.perform(order:, flow_order:, shipping: nil)
        new(order: order, flow_order: flow_order, shipping: shipping).perform!
      end

      attr_reader :order, :flow_order, :order_discount_ids, :shipping

      def initialize(order:, flow_order:, shipping: nil)
        @order = order
        @flow_order = flow_order
        @shipping = shipping
        @order_discount_ids = order
          .price_adjustments
          .adjusting("order")
          .map { |pa| pa.data['discount_id'] }
          .compact
          .uniq
      end

      def perform!
        adjust_items
        add_order_discount if localized_order_discount.present?
        adjust_shipping
      end

      private

      def adjust_shipping
        return unless shipping.present? && order.requires_shipping?

        flow_prices = flow_order.prices.reject { |p| p.name == 'Item subtotal' } # everything but the item prices

        flow_prices.each do |price|
          price_slug = price.name == "Shipping" ? "shipping" : "tax"
          shipping.adjust_pricing(
            price: price_slug,
            description: price.name,
            calculator: self.class.name,
            amount: Money.from_amount(price.base.amount, price.base.currency),
            data: price.to_hash
          )

          # build price adjustments in the currency the user checked out in.
          shipping.adjust_flow_pricing(
            price: price_slug,
            description: price.name,
            calculator: self.class.name,
            amount: Money.from_amount(price.amount, price.currency),
            data: price.to_hash
          )
        end
      end

      def adjust_items
        order.items.each do |order_item|
          order_item_discount_ids = order_item
            .price_adjustments
            .adjusting("item")
            .map { |pa| pa.data['discount_id'] }
            .compact
            .uniq

          order_item.reset_price_adjustments
          order_item.reset_flow_price_adjustments

          flow_item = flow_order.items.detect do |localized_line_item|
            localized_line_item.number == order_item.sku
          end

          localized_item_price = flow_item
            .local
            .prices
            .detect { |localized_price| localized_price.key == "localized_item_price" }

          order_item.adjust_pricing(
            item_adjustment_data.merge(
              quantity: order_item.quantity,
              amount: localized_item_price.base.to_m * order_item.quantity,
              description: 'Flow Localized Item Price Base',
              data: localized_item_price.to_hash
            )
          )

          order_item.adjust_flow_pricing(
            item_adjustment_data.merge(
              quantity: order_item.quantity,
              amount: localized_item_price.to_m * order_item.quantity,
              description: 'Flow Localized Item Price'
            )
          )

          if flow_item.discount.present?
            order_item.adjust_pricing(
              item_adjustment_data.merge(
                quantity: order_item.quantity,
                amount: -flow_item.discount.base.to_m,
                description: 'Flow Localized Line Item Discount Base',
                data: flow_item.discount.to_hash.merge(
                  discount_amount: flow_item.discount.base.to_m,
                  discount_ids: order_item_discount_ids
                )
              )
            )

            order_item.adjust_flow_pricing(
              item_adjustment_data.merge(
                quantity: order_item.quantity,
                amount: -flow_item.discount.to_m,
                description: 'Flow Localized Line Item Discount',
                data: {
                  "discount_amount" => flow_item.discount.to_m
                }
              )
            )
          end
        end
      end

      def add_order_discount
        base_distribution = Pricing::PriceDistributor.for_items(localized_order_discount.base.to_m.abs, order.items)
        local_distribution = Pricing::PriceDistributor.for_flow_order(localized_order_discount.to_m.abs, order)

        order.items.each do |item|
          item_base_total = base_distribution[item.id]
          item.adjust_pricing(
            {
              price: 'order',
              calculator: self.class.name,
              quantity: item.quantity,
              amount: -item_base_total,
              description: 'Flow Localized Order Discount Base',
              data: {
                "discount_ids" => order_discount_ids,
                "discount_value" => item_base_total
              }
            }
          )

          item_local_total = local_distribution[item.id]
          item.adjust_flow_pricing(
            {
              price: 'order',
              calculator: self.class.name,
              quantity: item.quantity,
              amount: 0 - item_local_total,
              description: 'Flow Localized Order Discount',
              data: { "discount_value" => item_local_total }
            }
          )
        end
      end

      # @return [::Io::Flow::V0::Models::OrderPriceDetail, nil]
      def localized_order_discount
        @localized_order_discount ||= flow_order
          .prices
          .detect { |order_price_detail| order_price_detail.key.value == "discount" }
      end

      def item_adjustment_data
        {
          price: 'item',
          calculator: self.class.name
        }
      end
    end
  end
end
