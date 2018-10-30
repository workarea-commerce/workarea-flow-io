module Workarea
  class Payment
    module FlowPaymentData
      def order
        @order ||= Workarea::Order.find(tender.payment.id)
      end

      def order_id
        @order_id ||= order.id
      end

      def currency_code
        order.currency
      end

      def customer_data
        {
          customer:  {
            name: { first: address.first_name , last: address.last_name }
          }
        }
      end
    end
  end
end
