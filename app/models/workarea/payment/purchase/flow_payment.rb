module Workarea
  class Payment
    module Purchase
      class FlowPayment
        include OperationImplementation
        def complete!
          transaction.response = ActiveMerchant::Billing::Response.new(
            true,
            'Flow Payment Transaction',
            tender.details
          )
        end
      end

      def cancel!
        # noop, nothing to cancel
        transaction.response = ActiveMerchant::Billing::Response.new(
          true,
          'Flow payment cancel'
        )
      end
    end
  end
end
