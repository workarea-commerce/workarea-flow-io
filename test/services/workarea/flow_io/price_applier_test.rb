require 'test_helper'

module Workarea
  module FlowIo
    class PriceApplierTest < Workarea::TestCase
      include Workarea::FlowIo::FlowFixtures

      def test_perform_with_canada_order
        order = Order.new(
          id: "ORD123",
          experience: canada_experience_geo,
          items: [
            {
              sku: "004056270-0",
              product_id: "cool-shirt",
              price_adjustments: [
                {
                  price: "item",
                  quantity: 1,
                  description: "Item Subtotal",
                  calculator: "Workarea::Pricing::Calculators::ItemCalculator",
                  data: {
                    "on_sale" => false,
                    "original_price" => 5.0,
                    "tax_code" => nil
                  },
                  amount: { cents: 500.0, currency_iso: "USD" }
                },
                {
                  price: "item",
                  quantity: 1,
                  description: "Test Discount",
                  calculator: "Workarea::Pricing::Discount::Product",
                  data: {
                    "discount_id" => "5b60ba1f87c68b6b757cde58",
                    "discount_value" => 0.25
                  },
                  amount: { cents: -25.0, currency_iso: "USD" }
                },
                {
                  price: "order",
                  quantity: 1,
                  description: "Discount",
                  calculator: "Workarea::Pricing::Discount::OrderTotal",
                  data: {
                    "discount_id" => "5b60ba1f87c68b6b757cde59",
                    "discount_value" => 0.2
                  },
                  amount: { cents: -20.0, currency_iso: "USD" }
                }
              ]
            }
          ]
        )

        shippings = [Workarea::Shipping.new]
        order_put_form = FlowIo::OrderPutForm.from(order: order, shippings: shippings)

        flow_order = FlowIo::BogusClient.new.orders.put_by_number(
          "organziation_id",
          order.id,
          order_put_form,
          experience: "canada"
        )

        FlowIo::PriceApplier.perform(order: order, flow_order: flow_order)

        item = order.items.first

        assert_equal(3, item.price_adjustments.size)
        base_price_adjustment = item.price_adjustments.first
        assert_equal(Money.from_amount(88.66, "USD"), base_price_adjustment.amount)

        discount_price_adjustment = item.price_adjustments.second
        assert_equal(Money.from_amount(-0.25, "USD"), discount_price_adjustment.amount)

        assert_equal(3, item.flow_price_adjustments.size)
        base_price_adjustment = item.flow_price_adjustments.first
        assert_equal(Money.from_amount(120, "CAD"), base_price_adjustment.amount)

        discount_price_adjustment = item.flow_price_adjustments.second
        assert_equal(Money.from_amount(-0.36, "CAD"), discount_price_adjustment.amount)
      end

      def test_perform_with_europe_order
        order = Order.new(
          id: "ORD123",
          experience: europe_experience_geo,
          items: [
            {
              sku: "004056270-0",
              product_id: "cool-shirt",
              price_adjustments: [
                {
                  price: "item",
                  quantity: 1,
                  description: "Item Subtotal",
                  calculator: "Workarea::Pricing::Calculators::ItemCalculator",
                  data: {
                    "on_sale" => false,
                    "original_price" => 5.0,
                    "tax_code" => nil
                  },
                  amount: { cents: 500.0, currency_iso: "USD" }
                },
                {
                  price: "item",
                  quantity: 1,
                  description: "Test Discount",
                  calculator: "Workarea::Pricing::Discount::Product",
                  data: {
                    "discount_id" => "5b60ba1f87c68b6b757cde58",
                    "discount_value" => 0.25
                  },
                  amount: { cents: -25.0, currency_iso: "USD" }
                },
                {
                  price: "order",
                  quantity: 1,
                  description: "Discount",
                  calculator: "Workarea::Pricing::Discount::OrderTotal",
                  data: {
                    "discount_id" => "5b60ba1f87c68b6b757cde59",
                    "discount_value" => 0.2
                  },
                  amount: { cents: -20.0, currency_iso: "USD" }
                }
              ]
            }
          ]
        )

        shippings = [Workarea::Shipping.new]
        order_put_form = FlowIo::OrderPutForm.from(order: order, shippings: shippings)

        flow_order = FlowIo::BogusClient.new.orders.put_by_number(
          "organziation_id",
          order.id,
          order_put_form,
          experience: "europe"
        )

        FlowIo::PriceApplier.perform(order: order, flow_order: flow_order)

        item = order.items.first

        assert_equal(3, item.price_adjustments.size)
        base_price_adjustment = item.price_adjustments.first
        assert_equal(Money.from_amount(104.28, "USD"), base_price_adjustment.amount)

        discount_price_adjustment = item.price_adjustments.second
        assert_equal(Money.from_amount(-0.25, "USD"), discount_price_adjustment.amount)

        assert_equal(3, item.flow_price_adjustments.size)
        base_price_adjustment = item.flow_price_adjustments.first
        assert_equal(Money.from_amount(92.95, "EUR"), base_price_adjustment.amount)

        discount_price_adjustment = item.flow_price_adjustments.second
        assert_equal(Money.from_amount(-0.23, "EUR"), discount_price_adjustment.amount)
      end
    end
  end
end
