module Workarea
  module FlowIo
    class OrderForm
      attr_reader :order

      def initialize(order)
        @order = order
      end

      def to_query_param_hash
        {
          attributes: { number: order.id },
          items: order.items.map.with_index do |item, index|
            [
              index,
              FlowIo::LineItemForm.new(order_item: item).to_h
            ]
          end.to_h
        }.merge(discount)
      end

      private

        def customer
          return nil unless user.present?

          {
            email: user.email,
            name: user.name,
            phone: user.default_shipping_address&.phone_number
          }
        end

        def user
          return unless order.user_id.present?

          @user ||= Workarea::User.find(order.user_id) rescue nil
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

        def items
          order.items.map { |item| FlowIo::LineItemForm.from(order_item: item) }
        end
    end
  end
end
