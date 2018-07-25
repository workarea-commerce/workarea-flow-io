require 'test_helper'

module Workarea
  module FlowIo
    class CheckoutTest < Workarea::TestCase
      include Workarea::FlowIo::FlowFixtures

      def test_build
        checkout = Workarea::FlowIo::Checkout.new(flow_order, order).build

        assert(checkout.complete?)
        assert_equal(1, checkout.payment.tenders.size)
        assert(checkout.payment.address.valid?)
        assert(checkout.shipping.address.valid?)
      end

      private

        def order
          product = create_product(name: 'Intelligent Bronze Pants')
          order = create_order(id: '6F3A2186EB')
          order.add_item(product_id: product.id, sku: 'SKU', quantity: 2)

          order
        end

        def flow_order
          ::Io::Flow::V0::Models::OrderUpsertedV2.new(canadian_webhook_payload).order
        end
    end
  end
end
