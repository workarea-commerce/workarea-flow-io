require 'test_helper'

module Workarea
  module FlowIo
    class LineItemFormTest < TestCase
      include FlowFixtures

      def test_currency_conversion
        product = create_product
        order = create_order

        create_product_discount(product_ids: [product.id])
        order.add_item(
          sku: product.skus.first,
          product_id: product.id,
          quantity: 1
        )
        order.update!(experience: build_flow_io_experience_geo)

        Pricing.perform(order)

        item = LineItemForm.new(
          order_item: order.items.first,
          discounts: []
        )
        discounts = item.to_h[:discounts]

        assert_equal(11000, item.price.amount)
        assert_equal(order.experience.currency, item.price.currency)
        refute_empty(discounts.discounts)
      end
    end
  end
end
