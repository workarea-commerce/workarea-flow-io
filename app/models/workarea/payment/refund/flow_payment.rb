module Workarea
  class Payment
    class Refund
      class FlowPayment
        include OperationImplementation
        include FlowPaymentOperation
        include FlowPaymentData

        def complete!
          validate_reference!

          transaction.response = handle_active_merchant_errors do
            gateway.refund(
              transaction.amount.to_f,
              nil,
              transaction_options
            )
          end
        end

        def cancel!
          # noop
        end

        private

        def transaction_options
          {
            currency: currency_code,
            authorization_id: authorization
          }
        end

        def authorization
          response = transaction.reference.response.params["response"]

          response["authorization"].present? ? response["authorization"]["id"] : response["reference"]
        end
      end
    end
  end
end
