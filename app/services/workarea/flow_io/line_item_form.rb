module Workarea
  module FlowIo
    class LineItemForm
      def self.from(order_item:)
        new(order_item: order_item).to_flow_model
      end

      attr_reader :order_item

      def initialize(order_item:)
        @order_item = order_item
      end

      def to_h
        {
          number: order_item.sku,
          quantity: order_item.quantity
        }.merge(discount)
      end

      def to_flow_model
        ::Io::Flow::V0::Models::LineItemForm.new(to_h)
      end

      private

      def discount
        discount_amount = order_item
          .price_adjustments
          .adjusting("item")
          .select { |adjustment| adjustment.discount? }
          .sum
          .abs

        return {} if discount_amount.amount.zero?


        { discount: { amount: discount_amount.to_f, currency: discount_amount.currency.iso_code } }
      end
    end
  end
end
