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
              transaction.reference.response.authorization,
              transaction_options
            )
          end
        end

        def cancel!
          # noop, can't cancel a capture
        end

        private

          def transaction_options
            {
              currency: currency_code
            }
          end
      end
    end
  end
end
