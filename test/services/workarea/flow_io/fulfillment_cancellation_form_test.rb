require 'test_helper'

module Workarea
  module FlowIo
    class FulfillmentCancellationFormTest < Workarea::TestCase
      setup :order

      def test_to_flow_model
        quantities = {
          "1" => 1
        }
        fulfillment_cancellation_form = FlowIo::FulfillmentCancellationForm.from(id: id, quantities: quantities)

        expectec_hash = {
          change_source: "fulfillment",
          reason: "consumer_requested",
          lines: [
            { item_number: "SKU1", line_number: nil, quantity: 1 }
          ]
        }

        assert_equal expectec_hash, fulfillment_cancellation_form.to_hash
      end

      private

      def id
        "1234"
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
    end
  end
end
