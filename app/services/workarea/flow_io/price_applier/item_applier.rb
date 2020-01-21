module Workarea
  module FlowIo
    # Updates a `Wokrarea::Order::Item` pricing with information from a
    # `::Io::Flow::V0::Models::LocalizedLineItem`.
    #
    class PriceApplier::ItemApplier
      def self.perform(order_item:, localized_line_item:, discounts:)
        new(
          order_item: order_item,
          localized_line_item: localized_line_item,
          discounts: discounts
        ).perform!
      end

      attr_reader :order_item,
        :localized_line_item,
        :discounts,
        :item_calculator_data,
        :flow_item_calculator_data

      # @param order_item [::Worakrea::Order::Item]
      # @param localized_line_item [::Io::Flow::V0::Models::LocalizedLineItem]
      #
      def initialize(order_item:, localized_line_item:, discounts:)
        @order_item = order_item
        @localized_line_item = localized_line_item
        @discounts = discounts
        @item_calculator_data = order_item.price_adjustments&.first&.data || {}
        @flow_item_calculator_data = order_item.flow_price_adjustments&.first&.data || {}
      end

      def perform!
        order_item.reset_price_adjustments
        order_item.reset_flow_price_adjustments

        add_base_adjustments
        add_line_item_discounts
        add_unit_price_rounding
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

        def add_line_item_discounts
          return unless localized_line_item.discounts.present?

          localized_line_item.discounts.each do |localized_line_item_discount|
            discount = discounts.detect do |pricing_discount|
              pricing_discount.name == localized_line_item_discount.discount_label
            end

            price_level = discount&.class&.price_level || "item"

            order_item.adjust_pricing(
              item_adjustment_data.merge(
                quantity: order_item.quantity,
                price: price_level,
                amount: localized_line_item_discount.base.to_m,
                description: localized_line_item_discount.discount_label,
                data: {
                  "localized_line_item_discount" => localized_line_item_discount.to_hash,
                  "discount_id" => discount&.id&.to_s,
                  "description" => localized_line_item_discount.discount_label,
                  "discount_amount" => localized_line_item_discount.base.to_m.abs
                }.deep_stringify_keys.compact
              )
            )

            order_item.adjust_flow_pricing(
              item_adjustment_data.merge(
                quantity: order_item.quantity,
                price: price_level,
                amount: localized_line_item_discount.to_m,
                description: localized_line_item_discount.discount_label,
                data: {
                  "description" => localized_line_item_discount.discount_label,
                  "discount_amount" => localized_line_item_discount.to_m.abs
                }
              )
            )
            end
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
