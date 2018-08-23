module Workarea
  module FlowIo
    class DetailedShippingNotificationForm
      attr_reader :id, :fulfillment

      def self.from(id:, tracking_number:)
        order = Workarea::Order.find id
        shipping = Workarea::Shipping.find_by_order id
        fulfillment = Workarea::Fulfillment.find id

        new(order: order, shipping: shipping, fulfillment: fulfillment, tracking_number: tracking_number).to_flow_model
      end

      attr_reader :order, :shipping, :fulfillment, :tracking_number

      def initialize(order:, shipping:, fulfillment:, tracking_number:)
        @order = order
        @shipping = shipping
        @fulfillment = fulfillment
        @tracking_number = tracking_number
      end

      # @return ::Io::Flow::V0::Models::DetailedShippingNotificationForm
      def to_flow_model
        ::Io::Flow::V0::Models::DetailedShippingNotificationForm.new(
          attributes: { number: order.id },
          carrier_tracking_number: tracking_number,
          destination: {
            contact: {
              name: {
                first: shipping_address.first_name,
                last: shipping_address.last_name
              },
              phone: shipping_address.phone_number
            },
            location: {
              streets: [shipping_address.street, shipping_address.street_2].compact,
              city: shipping_address.city,
              province: shipping_address.region,
              postal: shipping_address.postal_code,
              country: shipping_address.country.alpha3
            }
          },
          order_number: order.id,
          package: package,
          service: shipping.shipping_service.service_code
        )
      end

      private

        def shipping_address
          shipping&.address
        end

        def workarea_package
          @workarea_package ||= Storefront::PackageViewModel.wrap(
            fulfillment.find_package(tracking_number),
            order: order
          )
        end

        # TODO - IMPROVEMENT if using workarea-oms send package information
        def package
          {
            dimensions: {},
            items: workarea_package.items.map do |fulfillment_item_view_model|
              FlowIo::LineItemForm.from(order_item: fulfillment_item_view_model)
            end
          }
        end
    end
  end
end
