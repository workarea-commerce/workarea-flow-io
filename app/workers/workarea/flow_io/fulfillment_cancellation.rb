module Workarea
  module FlowIo
    class FulfillmentCancellation
      include Sidekiq::Worker

      def perform(id, canceled_items)
        fulfillment_cancelation_form = FlowIo::FulfillmentCancellationForm.from(id: id, quantities: canceled_items)
        order = Workarea::Order.find(id)

        FlowIo.client.fulfillments.put_cancellations(FlowIo.organization_id, order.flow_order_id, fulfillment_cancelation_form)
      end
    end
  end
end
