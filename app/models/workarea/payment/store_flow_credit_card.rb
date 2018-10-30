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

        # response.params['response] is a ::Io::Flow::V0::Models::Card
        @credit_card.token = response.params['response'].token

        response.success?
      end

      def save!
        perform!
        @credit_card.save
      end
    end
  end
end
