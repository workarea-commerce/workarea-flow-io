module Workarea
  module FlowIo
    class LineItemForm
      def self.from(order_item:, pricing_discounts:)
        new(order_item: order_item, pricing_discounts: pricing_discounts).to_flow_model
      end

      attr_reader :order_item, :pricing_discounts

      def initialize(order_item:, pricing_discounts:)
        @order_item = order_item
        @pricing_discounts = pricing_discounts
      end

      def to_h
        {
          number: order_item.sku,
          quantity: order_item.quantity,
          discounts: discounts_form
        }
      end

      def to_flow_model
        ::Io::Flow::V0::Models::LineItemForm.new(to_h)
      end

      private

        def discounts_form
          ::Io::Flow::V0::Models::DiscountsForm.new(
            discounts: discount_price_adjustments.map do |price_adjustment|
              discount = pricing_discounts
                .detect { |pd| pd.id.to_s == price_adjustment.data["discount_id"] }

              offer =
                case discount&.amount_type
                when :percent
                  {
                    percent: discount.amount.abs.to_f,
                    discriminator: ::Io::Flow::V0::Models::DiscountOffer::Types::DISCOUNT_OFFER_PERCENT
                  }
                else
                  {
                    money: {
                      amount: price_adjustment.amount.abs.to_f,
                      currency: price_adjustment.amount.currency.iso_code
                    },
                    discriminator: ::Io::Flow::V0::Models::DiscountOffer::Types::DISCOUNT_OFFER_FIXED
                  }
                end
              {
                offer: offer,
                target: "item",
                label: price_adjustment.description
              }
            end
          )
        end

        def discount_price_adjustments
          order_item
            .price_adjustments
            .discounts
            .adjusting("item")
            .group_discounts_by_id
        end
    end
  end
end
