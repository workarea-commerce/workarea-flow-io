module Workarea
  class Payment
    module CreditCardData
      def order
        @order ||= Workarea::Order.find(tender.payment.id)
      end

      def order_id
        @order_id ||= order.id
      end

      def currency_code
        @currency_code = order.total_price.currency.iso_code
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
