module Workarea
  module FlowIo
    class ShippingNotifications
      include Sidekiq::Worker

      def perform(id, tracking_number)
        shipping_notification_form = FlowIo::DetailedShippingNotificationForm.from(id: id, tracking_number: tracking_number)

        FlowIo.client.shipping_notifications.post(FlowIo.organization_id, shipping_notification_form)
      end
    end
  end
end
