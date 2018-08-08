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
          flow_item = flow_order.items.detect do |localized_line_item|
            localized_line_item.number == order_item.sku
          end

          ItemApplier.perform(order_item: order_item, localized_line_item: flow_item)
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
              description: 'Discount',
              data: {
                "description" => 'Flow Localized Order Discount Base',
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
              amount: -item_local_total,
              description: 'Discount',
              data: {
                "discount_value" => item_local_total,
                "description" => 'Flow Localized Order Discount'
              }
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
    end
  end
end
