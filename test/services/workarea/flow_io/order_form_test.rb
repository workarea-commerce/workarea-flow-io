require 'test_helper'

module Workarea
  module FlowIo
    class OrderFormTest < Workarea::TestCase
      def test_to_query_param_hash
        expected_hash = {
          attributes: { number: '1234' },
          items: {
            0 => { quantity: 1, number: "sku1" },
            1 => { quantity: 2, number: "sku2" },
            2 => { quantity: 2, number: "sku3" }
          }
        }
        assert_equal(expected_hash, OrderForm.new(order).to_query_param_hash)
      end

      def test_to_query_param_hash_with_discount
        create_product(
          id: "PRODUCT1",
          variants: [
            { sku: "sku1", regular: 5.00 },
            { sku: "sku2", regular: 5.00 }
          ])

        create_product(
          id: "PRODUCT2",
          variants: [
            { sku: "sku3", regular: 5.00 },
            { sku: "sku4", regular: 5.00 }
          ])

        product_discount = create_product_discount(amount: 5)

        order_total_discount = create_order_total_discount(
          name: 'Discount',
          amount_type: 'flat',
          amount: 1,
          compatible_discount_ids: [product_discount.id]
        )

        product_discount.compatible_discount_ids = [order_total_discount.id]
        product_discount.save!

        Pricing.perform(order)

        expected_hash = {
          attributes: { number: '1234' },
          items: {
            0 => { quantity: 1, number: "sku1", discount: { amount: 0.25, currency: 'USD' } },
            1 => { quantity: 2, number: "sku2", discount: { amount: 0.50, currency: 'USD' } },
            2 => { quantity: 2, number: "sku3" }
          },
          discount: { amount: 1, currency: 'USD' }
        }

        assert_equal(expected_hash, OrderForm.new(order).to_query_param_hash)
      end

      private

        def order
          @order ||= create_order(
            id: "1234",
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
