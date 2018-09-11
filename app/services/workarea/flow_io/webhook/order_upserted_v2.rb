module Workarea
  module FlowIo
    class Webhook::OrderUpsertedV2 < Webhook
      def process
        return unless flow_order.submitted_at.present?

        workarea_order = Order.find(flow_order.attributes["number"])
        workarea_order.lock!

        workarea_order.flow = true
        workarea_order.save!

        # Service class to build a valid workarea checkout
        checkout = Workarea::FlowIo::Checkout.new(flow_order, workarea_order)

        # builds the orders shipping and payment details
        checkout.build

        unless checkout.place_order
          raise Webhook::Error
        end

       ensure
        workarea_order&.unlock!
      end

      private

        def flow_order
          event.order
        end
    end
  end
end
