require 'test_helper'

module Workarea
  module FlowIo
    class OrderFormTest < Workarea::TestCase
      def test_to_h
        expected_hash = {
          attributes: { number: '1234' },
          items: {
            0 => { quantity: 1, number: "sku1" },
            1 => { quantity: 2, number: "sku2" }
          }
        }
        assert_equal(expected_hash, OrderForm.new(order).to_h)
      end

      private

        def order
          @order ||= create_order(
            id: "1234",
            items: [
              { quantity: 1, sku: "sku1", product_id: "1234" },
              { quantity: 2, sku: "sku2", product_id: "1234" }
            ]
          )
        end
    end
  end
end
