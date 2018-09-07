module Workarea
  class Payment
    class Capture
      class FlowPayment
        include OperationImplementation
        include FlowPaymentOperation
        include FlowPaymentData

        def complete!
          validate_reference!

          transaction.response = handle_active_merchant_errors do
            gateway.capture(
              transaction.amount.to_f,
              transaction.reference.response.authorization
            )
          end
        end

        def cancel!
          # noop, can't cancel a capture
        end
      end
    end
  end
end
