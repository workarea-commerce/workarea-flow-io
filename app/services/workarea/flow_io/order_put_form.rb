module Workarea
  module FlowIo
    class OrderPutForm
      def self.from(order:, shippings: nil)
        new(order: order, shippings: shippings).to_flow_model
      end

      attr_reader :order, :shippings

      def initialize(order:, shippings: nil)
        @order = order
        @shippings = shippings || []
      end

      def to_flow_model
        ::Io::Flow::V0::Models::OrderPutForm.new(
          {
            attributes: { number: order.id },
            customer: customer,
            items: items
          }.merge(discount)
        )
      end

      private

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
          order.items.map { |item| FlowIo::LineItemForm.from(order_item: item) }
        end

        def discount
          discount_amount = order
            .price_adjustments
            .adjusting("order")
            .select { |pa| pa.discount? }
            .sum
            .abs

          return {} if discount_amount.amount.zero?

          { discount: { amount: discount_amount.to_f, currency: discount_amount.currency.iso_code } }
        end
    end
  end
end
