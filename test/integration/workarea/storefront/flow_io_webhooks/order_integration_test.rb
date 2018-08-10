require 'test_helper'

module Workarea
  module Storefront
    module FlowIoWebHooks
      class OrderIntegrationTest < Workarea::IntegrationTest
        include Workarea::FlowIo::WebhookIntegrationTest
         include Workarea::FlowIo::FlowFixtures

        def test_order_update
          product = create_product(variants: [{ sku: '386555310-9', regular: 5.00 }])
          product_2 = create_product(variants: [{ sku: '332477498-5', regular: 5.00 }])

          shipping_service = create_shipping_service

          order = create_order(id: '6F3A2186EB', experience: canada_experience)

          order.add_item(product_id: product.id, sku: '386555310-9', quantity: 1)
          order.add_item(product_id: product_2.id, sku: '332477498-5', quantity: 1)

          shipping = Workarea::Shipping.find_or_create_by(order_id: order.id)

          Workarea::Pricing.perform(order, shipping)

          post storefront.flow_io_webhook_path, params: order_upserted, headers: headers

          assert(response.ok?)
          assert_equal({ "status" => 200 }, JSON.parse(response.body))
          assert_equal(200, response.status)

          order.reload
          assert_equal("flow-test@weblinc.com", order.email)
          assert_equal(171.55.to_m, order.total_price)

          assert_equal(Money.from_amount(180.00, "CAD"), order.flow_total_value)
          assert_equal(Money.from_amount(232.31, "CAD"), order.flow_total_price)
          assert_equal(Money.from_amount(9.29, "CAD"), order.flow_shipping_total)
          assert_equal(Money.from_amount(43.02, "CAD"), order.flow_tax_total)

          assert(order.imported_from_flow_at.present?)
          assert(order.flow_order_id.present?)
          assert(order.placed?)

          payment = Payment.find(order.id)

          assert(payment.address.valid?)
          assert_equal(1, payment.tenders.size)
          assert_equal(1, payment.tenders.first.transactions.size)

          tender = payment.tenders.first
          assert_equal(171.55.to_m, tender.amount)

          shipping.reload
          assert(shipping.address.valid?)

          assert_equal(3, shipping.price_adjustments.size)
          assert_equal(3, shipping.flow_price_adjustments.size)
          assert_equal(6.86.to_m, shipping.shipping_total)
          assert_equal("paid", shipping.delivery_duty)
        end

        def test_order_not_found
          invalid_order_params = { order: { attributes: { number: 'xxx' } } }.to_json
          post storefront.flow_io_webhook_path, params: invalid_order_params, headers: headers
          refute(response.ok?)
        end

        private

          def order_upserted
            canadian_webhook_payload.to_json
          end
      end
    end
  end
end
