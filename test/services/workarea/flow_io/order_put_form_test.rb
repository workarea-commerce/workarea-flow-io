require 'test_helper'

module Workarea
  module FlowIo
    class OrderFormTest < Workarea::TestCase
      def test_to_flow_model
        order_put_form = OrderPutForm.from(order: order)

        assert_equal(order_put_form.customer.name.first, user.first_name)
        assert_equal(order_put_form.customer.name.last, user.last_name)
      end

      private

        def user
          @user ||= create_user
        end

        def order
          @order ||= create_order(
            id: "1234",
            user_id: user.id,
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
