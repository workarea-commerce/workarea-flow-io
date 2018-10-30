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
              tender.to_token_or_active_merchant,
              order_id,
              transaction_options
            )
          end
        end

        def cancel!
          return unless transaction.success?

          transaction.cancellation = handle_active_merchant_errors do
            gateway.void(nil, transaction.response.authorization)
          end
        end

        private

        def transaction_options
          {
            amount: transaction.amount.to_f,
            currency: currency_code,
            customer: customer_data,
            discriminator: :direct_authorization_form
          }
        end
      end
    end
  end
end
