module Workarea
  module FlowIo
    class PriceApplier::ItemApplier
      def self.perform(order_item:, localized_line_item:)
        new(order_item: order_item, localized_line_item: localized_line_item).perform!
      end

      attr_reader :order_item,
        :localized_line_item,
        :original_discounts,
        :item_calculator_data,
        :flow_item_calculator_data

      # @param ::Worakrea::Order::Item
      # @param ::Io::Flow::V0::Models::LocalizedLineItem
      def initialize(order_item:, localized_line_item:)
        @order_item = order_item
        @localized_line_item = localized_line_item
        @item_calculator_data = order_item.price_adjustments&.first&.data || {}
        @flow_item_calculator_data = order_item.flow_price_adjustments&.first&.data || {}
        # Need to store original discount price adjustments: discount_id, quantity and amount
        # for Workarea::SaveOrderAnalytics#discounts_by, used for Analytics::Discount and
        # Analytics::DiscountsSummary.  If this is called from the webhook after the order
        # was placed in Flow's Hosted checkout, just read the "original_discounts" already
        # stored in the price adjustments data
        @original_discounts = order_item
          .price_adjustments
          .adjusting("item")
          .select(&:discount?)
          .flat_map do |pa|
            pa.data["original_discounts"] || { id: pa.data['discount_id'], quantity: pa.quantity, amount: pa.amount }
          end
      end

      def perform!
        order_item.reset_price_adjustments
        order_item.reset_flow_price_adjustments

        add_base_adjustments
        if localized_line_item.discount.present?
          add_item_discount
          add_unit_price_rounding
        end
      end

      private

        def add_base_adjustments
          order_item.adjust_pricing(
            item_adjustment_data.merge(
              quantity: order_item.quantity,
              amount: localized_item_price.base.to_m * order_item.quantity,
              description: 'Item Subtotal',
              data: item_calculator_data.merge(
                "localized_item_price" => localized_item_price.to_hash,
                "description" => 'Flow Localized Item Price Base'
              ).deep_stringify_keys
            )
          )

          order_item.adjust_flow_pricing(
            item_adjustment_data.merge(
              quantity: order_item.quantity,
              amount: localized_item_price.to_m * order_item.quantity,
              description: 'Item Subtotal',
              data: flow_item_calculator_data.merge(
                "description" => 'Flow Localized Item Price'
              ).deep_stringify_keys
            )
          )
        end

        def add_item_discount
          order_item.adjust_pricing(
            item_adjustment_data.merge(
              quantity: order_item.quantity,
              amount: -localized_line_item.discount.base.to_m,
              description: "Discount",
              data: {
                "localized_line_item_discount" => localized_line_item.discount.to_hash,
                "description" => 'Flow Localized Line Item Discount Base',
                "discount_amount" => localized_line_item.discount.base.to_m,
                "original_discounts" => original_discounts
              }.deep_stringify_keys
            )
          )

          order_item.adjust_flow_pricing(
            item_adjustment_data.merge(
              quantity: order_item.quantity,
              amount: -localized_line_item.discount.to_m,
              description: "Discount",
              data: {
                "description" => 'Flow Localized Line Item Discount',
                "discount_amount" => localized_line_item.discount.to_m
              }
            )
          )
        end

        # flow will add or subtract money to make the line item price
        # have an even unit price we do the same thing and roll it into the discount
        # adjustment
        def add_unit_price_rounding
          return unless needs_unti_price_rounding?

          value = unit_quantity_price - order_item_total_value

          item_adjustment_data.merge(
            quantity: order_item.quantity,
            amount: value,
            description: "Discount",
            data: {
              description: 'Flow Localized Line Item Discount',
              discount_amount: value.abs
            }
          )
        end

        def needs_unti_price_rounding?
          unit_quantity_price != order_item_total_value
        end

        def unit_quantity_price
          order_item.current_flow_unit_price * order_item.quantity
        end

        def order_item_total_value
          order_item
            .flow_price_adjustments
            .adjusting("item")
            .sum
        end

        def localized_item_price
          @localized_item_price ||= localized_line_item
          .local
          .prices
          .detect { |localized_price| localized_price.key == "localized_item_price" }
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
