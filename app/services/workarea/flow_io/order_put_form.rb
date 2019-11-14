module Workarea
  module FlowIo
    class OrderPutForm
      def self.from(order:, shippings: nil)
        new(order: order, shippings: shippings).to_flow_model
      end

      attr_reader :order, :shippings

      # @param order [Workarea::Order]
      # @param shippings [Array<Workarea::Shipping>]
      #
      def initialize(order:, shippings: nil)
        @order = order
        @shippings = shippings || []
      end

      def to_flow_model
        ::Io::Flow::V0::Models::OrderPutForm.new(
          {
            attributes: { number: order.id },
            customer: customer,
            items: items,
            discounts: discounts_form
          }
        )
      end

      private

        def pricing_discounts
          @pricing_discounts ||= Workarea::Pricing::Discount.where(:_id.in => order.discount_ids).to_a
        end

        def customer
          return nil unless user.present?

          {
            email: user.email,
            name: {
              first: user.first_name,
              last: user.last_name
            },
            phone: user.default_shipping_address&.phone_number
          }
        end

        def user
          return unless order.user_id.present?

          @user ||= Workarea::User.find(order.user_id) rescue nil
        end

        def items
          order.items.map { |item| FlowIo::LineItemForm.from(order_item: item, pricing_discounts: pricing_discounts) }
        end

        def discount_price_adjustments
          order
            .price_adjustments
            .discounts
            .adjusting("order")
            .group_discounts_by_id
        end

        # @return [::Io::FlowIo::V0::Models::DiscountsForm]
        #
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
    end
  end
end
