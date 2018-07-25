module Workarea
  module FlowIo
    class OrderForm
      attr_reader :order

      def initialize(order)
        @order = order
      end

      def to_h
        {
          attributes: { number: order.id },
          items: items,
          discount: { amount: order_discount_total, currency: order_discount_total.currency.iso_code }
        }
      end

      private

        def items
          order.items.map.with_index do |item, index|
            discount = item_discount_total(item)
            [index, { quantity: item.quantity, number: item.sku, discount: { amount: discount, currency: discount.currency.iso_code } }]
          end.to_h
        end

        def order_discount_total
          order.price_adjustments.adjusting("order").select { |pa| pa.discount? }.sum.abs
        end

        def item_discount_total(item)
          order.price_adjustments.adjusting("item").select { |pa| pa.discount? }.sum.abs
        end
    end
  end
end
