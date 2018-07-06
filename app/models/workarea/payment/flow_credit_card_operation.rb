module Workarea
  class Payment
    module FlowCreditCardOperation
      def handle_active_merchant_errors
        begin
          yield
        rescue ActiveMerchant::ResponseError => error
          error.response
        rescue ActiveMerchant::ActiveMerchantError,
                ActiveMerchant::ConnectionError => error
          ActiveMerchant::Billing::Response.new(false, nil)
        end
      end

      def gateway
        Workarea::FlowIo.gateway
      end
    end
  end
end
