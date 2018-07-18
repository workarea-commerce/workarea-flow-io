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
          items: items
        }
      end

      private

        def items
          order.items.map.with_index do |item, index|
            [index, { quantity: item.quantity, number: item.sku }]
          end.to_h
        end
    end
  end
end
