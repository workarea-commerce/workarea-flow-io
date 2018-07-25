require 'test_helper'

module Workarea
  module FlowIo
    class OrderFormTest < Workarea::TestCase
      def test_to_h
        expected_hash = {
          attributes: { number: '1234' },
          items: {
            0 => { quantity: 1, number: "sku1", discount: { amount: 0.to_m, currency: 'USD' } },
            1 => { quantity: 2, number: "sku2", discount: { amount: 0.to_m, currency: 'USD' } }
          },
          discount: { amount: 0.to_m, currency: 'USD' }
        }
        assert_equal(expected_hash, OrderForm.new(order).to_h)
      end

      def test_to_h_with_discount
        create_product(
          id: "PRODUCT1",
          variants: [
            { sku: "sku1", regular: 5.00 },
            { sku: "sku2", regular: 5.00 }
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
            0 => { quantity: 1, number: "sku1", discount: { amount: 0.75.to_m, currency: 'USD' } },
            1 => { quantity: 2, number: "sku2", discount: { amount: 0.75.to_m, currency: 'USD' } }
          },
          discount: { amount: 1.to_m, currency: 'USD' }
        }

        assert_equal(expected_hash, OrderForm.new(order).to_h)
      end

      private

        def order
          @order ||= create_order(
            id: "1234",
            items: [
              { quantity: 1, sku: "sku1", product_id: "PRODUCT1" },
              { quantity: 2, sku: "sku2", product_id: "PRODUCT1" }
            ]
          )
        end
    end
  end
end
