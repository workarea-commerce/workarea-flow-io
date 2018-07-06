module Workarea
  class Payment
    class Refund
      class Flow
        include OperationImplementation
        include FlowCreditCardOperation
        include CreditCardData

        def complete!
          validate_reference!

          transaction.response = handle_active_merchant_errors do
            gateway.refund(
              transaction.amount.cents,
              transaction.reference.response.authorization
            )
          end
        end

        def cancel!
          # noop
        end
      end
    end
  end
end
