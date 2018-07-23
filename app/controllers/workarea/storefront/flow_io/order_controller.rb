module Workarea
  module Storefront
    class FlowIoOrderController < FlowIoWebhookController
      def upserted
        return unless params["order"]["submitted_at"].present?
        return order_not_found_response unless wa_order.present?

        wa_order.flow = true
        wa_order.save!

        # Service class to build a valid workarea checkout
        checkout = Workarea::FlowIo::Checkout.new(flow_order, wa_order).build

        # attempt to complete the order
        if checkout.place_order
          wa_order.complete_flow!(flow_order.order.id)

          successful_response
        else
          unsuccessful_response
        end
      end

      private

        def order_not_found_response
          render json: { status: 404 }
        end

        def flow_order
          @flow_order ||= ::Io::Flow::V0::Models::OrderUpsertedV2.new(params.to_unsafe_hash)
        end

        def wa_order
          @wa_order ||= Workarea::Order.find(flow_order.order.attributes["number" ])
        end
    end
  end
end
