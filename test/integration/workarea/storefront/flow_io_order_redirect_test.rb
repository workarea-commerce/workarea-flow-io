require 'test_helper'

module Workarea
  module Storefront
    class FlowIoOrderRedirectTest < Workarea::IntegrationTest
      setup :set_organization_id
      teardown :reset_organization_id

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
        assert_redirected_to storefront.checkout_addresses_url
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

      private

        def set_organization_id
          Rails.application.secrets.flow_io ||= {}
          @_old_organization_id = Rails.application.secrets.flow_io[:organization_id]
          Rails.application.secrets.flow_io[:organization_id] = "workarea-sandbox"
        end

        def reset_organization_id
          Rails.application.secrets.flow_io[:organization_id] = @_old_organization_id
        end
    end
  end
end
