require 'test_helper'

module Workarea
  module Storefront
    class FlowIoLOrderIntegrationTest < Workarea::IntegrationTest
      include Workarea::FlowIo::WebhookIntegrationTest
      include Workarea::FlowIo::FlowFixtures

      def test_order_update
        product = create_product(name: 'Intelligent Bronze Pants')
        order = create_order(id: '6F3A2186EB')
        order.add_item(product_id: product.id, sku: 'SKU', quantity: 2)

        post storefront.flow_io_order_path, params: order_upserted, headers: headers
        assert(response.ok?)
        assert_equal({ "status" => 200 }, JSON.parse(response.body))
        assert_equal(200, response.status)

        order.reload

        assert_equal("flow-test@weblinc.com", order.email)
        assert_equal(19.42.to_m, order.total_price)
        assert(order.imported_from_flow_at.present?)
        assert(order.flow_order_id.present?)
        assert(order.placed?)

        payment = Payment.find(order.id)

        assert(payment.address.valid?)
        assert_equal(1, payment.tenders.size)
        assert_equal(1, payment.tenders.first.transactions.size)

        shipping = Shipping.find_by_order(order.id)

        assert(shipping.address.valid?)
        assert_equal(9.42.to_m, shipping.shipping_total)
      end

      def test_order_not_found
        invalid_order_params = { order: { attributes: { number: 'xxx' }}}.to_json
        post storefront.flow_io_order_path, params: invalid_order_params, headers: headers
        refute(response.ok?)
      end

      private

        def order_upserted
          canadian_webhook_payload.to_json
        end
    end
  end
end
