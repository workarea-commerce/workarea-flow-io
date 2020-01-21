module Workarea
  module FlowIo
    class CheckoutTokenForm
      def self.from(order:, session_id:)
        new(order: order, session_id: session_id).to_flow_model
      end

      attr_reader :order, :session_id

      def initialize(order:, session_id:)
        @order = order
        @session_id = session_id
      end

      def to_flow_model
        ::Io::Flow::V0::Models::CheckoutTokenReferenceForm.new(attributes)
      end

      def attributes
        {
          order_number: order.id,
          session_id: session_id,
          urls: {
            continue_shopping: continue_shopping_url
          }
        }
      end

      private

        def continue_shopping_url
         "https://#{Workarea.config.host}"
        end
    end
  end
end
