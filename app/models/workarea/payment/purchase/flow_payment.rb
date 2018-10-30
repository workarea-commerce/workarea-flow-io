module Workarea
  class Payment
    module Purchase
      class FlowPayment
        include OperationImplementation
        include FlowPaymentOperation
        include FlowPaymentData

        delegate :address, to: :tender

        def complete!
          # Some gateways will tokenize in the same request as the auth/capture.
          # If that is the case for the gateway you are implementing, omit the
          # following line, and save the token on the tender after doing the
          # gateway authorization.
          return unless StoreFlowCreditCard.new(tender, options).save!

          transaction.response = handle_active_merchant_errors do
            gateway.purchase(
              tender.to_token_or_active_merchant,
              order_id,
              transaction_options
            )
          end
        end

        def cancel!
          # can't void a capture
        end

        private

        def transaction_options
          {
            amount: transaction.amount.cents,
            currency: currency_code,
            customer: customer_data,
            discriminator: :direct_authorization_form
          }
        end
      end
    end
  end
end
