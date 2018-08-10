require 'test_helper'

module Workarea
  module FlowIo
    class CheckoutTest < Workarea::TestCase
      include Workarea::FlowIo::FlowFixtures

      def test_build
        order = workarea_order
        Workarea::FlowIo::Checkout.new(flow_order, order).build

        shipping = Workarea::Shipping.find_by_order(order.id)
        payment = Workarea::Payment.find(order.id)

        assert(payment.valid?)
        assert_equal(1, payment.tenders.size)
        assert(payment.address.valid?)

        assert(shipping.valid?)
        assert(shipping.address.valid?)
        assert(shipping.shipping_service.valid?)
      end

      private

        def workarea_order
          product = create_product(variants: [{ sku: '386555310-9', regular: 5.00 }])
          product_2 = create_product(variants: [{ sku: '332477498-5', regular: 5.00 }])

          order = create_order

          order.add_item(product_id: product.id, sku: '386555310-9', quantity: 1)
          order.add_item(product_id: product_2.id, sku: '332477498-5', quantity: 1)

          order
        end

        def flow_order
          ::Io::Flow::V0::Models::OrderUpsertedV2.new(canadian_webhook_payload).order
        end
    end
  end
end
