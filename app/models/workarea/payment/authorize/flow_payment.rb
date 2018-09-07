module Workarea
  class Payment
    module Authorize
      class FlowPayment
        include OperationImplementation
        include FlowPaymentOperation
        include FlowPaymentData

        delegate :address, to: :tender

        def complete!
          # Some gateways will tokenize in the same request as the authorize.
          # If that is the case for the gateway you are implementing, omit the
          # following line, and save the token on the tender after doing the
          # gateway authorization.
          return unless StoreFlowCreditCard.new(tender, options).save!

          transaction.response = handle_active_merchant_errors do
            gateway.authorize(
              transaction.amount.to_f,
              tender.to_token_or_active_merchant,
              transaction_options
            )
          end
        end

        def cancel!
          return unless transaction.success?

          transaction.cancellation = handle_active_merchant_errors do
            gateway.void(0, transaction.response.authorization[:key], {})
          end
        end

        private

        def transaction_options
          {
            currency: currency_code,
            customer: customer_data
          }
        end
      end
    end
  end
end
