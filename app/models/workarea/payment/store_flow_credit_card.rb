module Workarea
  class Payment
    class StoreFlowCreditCard
      include FlowPaymentOperation

      def initialize(credit_card, options = {})
        @credit_card = credit_card
        @options = options
      end

      def perform!
        return true if @credit_card.token.present?

        response = handle_active_merchant_errors do
          gateway.store(@credit_card.to_active_merchant)
        end

        # gateway will return a string if successful and an
        # active merchant error if it fails
        if response.is_a? String
          @credit_card.token = response
          true
        else
          false
        end
      end

      def save!
        perform!
        @credit_card.save
      end
    end
  end
end
