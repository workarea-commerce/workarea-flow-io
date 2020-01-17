require 'test_helper'

module Workarea
  module FlowIo
    class OrderPutFormTest < Workarea::TestCase
      include FlowFixtures

      setup :setup_pricing_skus

      def setup_pricing_skus
        %w(sku1 sku2 sku3).each do |sku|
          create_pricing_sku(id: sku)
        end
      end

      def test_to_flow_model
        Pricing.perform(order)

        order_put_form = OrderPutForm.from(order: order)
        line_item_form = order_put_form.items.first

        assert_equal(order_put_form.customer.name.first, user.first_name)
        assert_equal(order_put_form.customer.name.last, user.last_name)
        assert_equal(11000, line_item_form.price.amount)
        assert_equal('CAD', line_item_form.price.currency)
      end

      private

        def user
          @user ||= create_user
        end

        def order
          @order ||= create_order(
            id: "1234",
            user_id: user.id,
            experience: build_flow_io_experience_geo,
            items: [
              { quantity: 1, sku: "sku1", product_id: "PRODUCT1" },
              { quantity: 2, sku: "sku2", product_id: "PRODUCT1" },
              { quantity: 2, sku: "sku3", product_id: "PRODUCT2" }
            ]
          )
        end
    end
  end
end
