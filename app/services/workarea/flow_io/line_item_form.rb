module Workarea
  module FlowIo
    class LineItemForm
      def self.from(order_item:, discounts:)
        new(order_item: order_item, discounts: discounts).to_flow_model
      end

      attr_reader :order_item, :discounts

      def initialize(order_item:, discounts:)
        @order_item = order_item
        @discounts = discounts
      end

      def price
        ::Io::Flow::V0::Models::Money.new(
          amount: base_item_price.to_f,
          currency: base_item_price.currency.to_s
        )
      end

      def to_h
        {
          number: order_item.sku,
          quantity: order_item.quantity,
          price: price,
          discounts: discounts_form
        }
      end

      def to_flow_model
        ::Io::Flow::V0::Models::LineItemForm.new(to_h)
      end

      private

        # Discount price adjustments for the order_item
        #
        # @return [Array<Workarea::PriceAdjustment>]
        #
        def discount_price_adjustments
          order_item.price_adjustments.discounts
        end

        def base_item_price
          order_item
            .flow_price_adjustments
            .adjusting('item')
            .reject(&:discount?)
            .sum
        end

        def discounts_form
          ::Io::Flow::V0::Models::DiscountsForm.new(
            discounts: discount_price_adjustments.map do |discount_price_adjustment|
              {
                offer: {
                  money: {
                    amount: discount_price_adjustment.amount.abs.to_f,
                    currency: discount_price_adjustment.amount.currency.iso_code
                  },
                  discriminator: ::Io::Flow::V0::Models::DiscountOffer::Types::DISCOUNT_OFFER_FIXED
                },
                target: "item",
                label: discount_price_adjustment.description
              }
            end
          )
        end
    end
  end
end
