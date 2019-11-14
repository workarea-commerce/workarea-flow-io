require 'test_helper'

module Workarea
  module FlowIo
    class DetailedShippingNotificationFormTest < Workarea::TestCase
      setup :order, :shipping, :fulfillment

      def test_to_flow_model
        shipping_notification_form = FlowIo::DetailedShippingNotificationForm.from(id: id, tracking_number: tracking_number)

        expected_hash = {
          key: nil,
          attributes: { number: "1234" },
          carrier_tracking_number: "1z",
          destination: {
            contact: {
              name: { first: "Ben", last: "Crouse" },
              company: nil,
              email: nil,
              phone: "5555555555"
            },
            location: {
              text: nil,
              streets: ["22 S. 3rd St"],
              street_number: nil,
              city: "Philadelphia",
              province: "PA",
              postal: "19106",
              country: "USA",
              latitude: nil,
              longitude: nil
            },
            center_key: nil,
            center_reference: nil,
            service: nil
          },
          order_number: "1234",
          package: {
            dimensions: {
              depth: nil,
              diameter: nil,
              length: nil,
              weight: nil,
              width: nil
            },
            items: [
              {
                number: "SKU1",
                quantity: 1,
                shipment_estimate: nil,
                price: nil,
                attributes: nil,
                center: nil,
                discount: nil,
                discounts: { discounts: [] },
              }
            ],
          reference_number: nil
          },
          service: "001",
          origin: nil,
          shipment_recipient: nil,
          discriminator: "detailed_shipping_notification_form"
        }

        assert_equal expected_hash, shipping_notification_form.to_hash
      end

      private

      def id
        "1234"
      end

      def tracking_number
        "1z"
      end

      def order
        @order ||= Workarea::Order.create!(
          id: id,
          items: [
            {
              id: "1",
              sku: "SKU1",
              quantity: 1,
              product_id: 1
            }
          ]
        )
      end

      def shipping
        @shipping ||= Workarea::Shipping.create!(
          order_id: id,
          address: {
            first_name: "Ben",
            last_name: "Crouse",
            street: "22 S. 3rd St",
            city: "Philadelphia",
            region: "PA",
            postal_code: 19106 ,
            country: Country["US"],
            phone_number: "5555555555"
          },
          shipping_service: {
            name: "UPS Ground",
            service_code: "001"
          }
        )
      end

      def fulfillment
        @fulfillment ||= Workarea::Fulfillment.create!(
          id: id,
          items: [
            {
              quantity: 0,
              order_item_id: 1,
              events: [
                {
                  quantity: 1,
                  data: { tracking_number: tracking_number },
                  status: "shipped"
                }
              ]
            }
          ]
        )
      end
    end
  end
end
