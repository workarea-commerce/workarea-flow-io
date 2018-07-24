require 'test_helper'

module Workarea
  module Storefront
    class FlowIoOrderRedirectTest < Workarea::IntegrationTest
      include Workarea::FlowIo::WebhookIntegrationTest

      def test_domestic_order_is_not_redirected
        cookies['_f60_session'] = 1

        product = create_product

        post storefront.cart_items_path,
          params: {
            product_id: product.id,
            sku: product.skus.first,
            quantity: 2
          }

        get storefront.checkout_path
        assert_equal("/checkout", path)
      end

      def test_foreign_order_is_redirected
        cookies['_f60_session'] = 2

        product = create_product

        post storefront.cart_items_path,
          params: {
            product_id: product.id,
            sku: product.skus.first,
            quantity: 2
          }

        get storefront.checkout_path

        assert_redirected_to %r(\Ahttps://checkout.flow.io)
      end
    end
  end
end
