module Workarea
  class Payment
    class Capture
      class Flow
        include OperationImplementation
        include FlowCreditCardOperation
        include CreditCardData

        def complete!
          validate_reference!

          transaction.response = handle_active_merchant_errors do
            gateway.capture(
              transaction.amount.cents,
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
