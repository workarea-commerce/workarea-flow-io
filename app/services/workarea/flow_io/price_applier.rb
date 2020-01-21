module Workarea
  module FlowIo
    class PriceApplier
      def self.perform(order:, flow_order:, shipping: nil)
        new(order: order, flow_order: flow_order, shipping: shipping).perform!
      end

      attr_reader :order, :flow_order, :shipping

      # @param order [Workarea::Order]
      # @param flow_order [::Io::Flow::V0::Models::Order]
      # @param shipping [Array<Workarea::Shipping>]
      #
      def initialize(order:, flow_order:, shipping: nil)
        @order = order
        @flow_order = flow_order
        @shipping = shipping
      end

      def perform!
        adjust_items
        adjust_shipping
      end

      private

        # @return [Array<Workarea::Pricing::Discount>]
        #
        def discounts
          @discounts ||= Workarea::Pricing::Discount
            .where(:_id.in => order.discount_ids)
            .to_a
        end

        def adjust_shipping
          return unless shipping.present? && order.requires_shipping?

          # Prices are of types: adjustment, subtotal, vat, duty, shipping,
          # insurance, discount.  Filter out subtotal and discount prices
          flow_prices = flow_order.prices.reject do |order_price_detail|
            ["subtotal", "discount"].include? order_price_detail.key.value
          end

          flow_prices.each do |price|
            price_slug = price.name == "Shipping" ? "shipping" : "tax"
            shipping.adjust_pricing(
              price: price_slug,
              description: price.name,
              calculator: self.class.name,
              amount: price.base.to_m,
              data: { "order_price_detail" => price.to_hash }
            )

            # build price adjustments in the currency the user checked out in.
            shipping.adjust_flow_pricing(
              price: price_slug,
              description: price.name,
              calculator: self.class.name,
              amount: price.to_m
            )
          end
        end

        # update each Order::Item pricing with new prices from Flow.io
        #
        def adjust_items
          order.items.each do |order_item|
            flow_item = flow_order.items.detect do |localized_line_item|
              localized_line_item.number == order_item.sku
            end

            ItemApplier.perform(
              order_item: order_item,
              localized_line_item: flow_item,
              discounts: discounts
            )
          end
        end
    end
  end
end
