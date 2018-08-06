module Workarea
  module FlowIo
    class Webhook::OrderUpsertedV2 < Webhook
      def process
        return unless flow_order.submitted_at.present?

        workarea_order = Order.find(flow_order.attributes["number"])
        workarea_order.flow = true
        workarea_order.save!

        # Service class to build a valid workarea checkout
        checkout = Workarea::FlowIo::Checkout.new(flow_order, workarea_order)

        # builds the orders shipping and payment details
        checkout.build

        # attempt to complete the order
        if checkout.place_order
          workarea_order.complete_flow!(flow_order.id)
        else
          raise Webhook::Error
        end
      end

      private

        def flow_order
          event.order
        end
    end
  end
end
