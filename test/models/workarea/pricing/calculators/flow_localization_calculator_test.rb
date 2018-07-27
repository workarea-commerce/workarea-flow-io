require 'test_helper'

module Workarea
  module Pricing
    module Calculators
      class FlowLocalizationCalculatorTest < Workarea::TestCase
        include Workarea::FlowIo::FlowFixtures

        def test_adjust_in_canada
          order = Order.new(
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

          shipping = Shipping.new

          FlowLocalizationCalculator.test_adjust(order, shipping)

          item = order.items.first

          assert_equal(
            88.41.to_m("USD"),
            item.price_adjustments.adjusting("item").sum
          )

          assert_equal(
            119.64.to_m("CAD"),
            item.flow_price_adjustments.adjusting("item").sum
          )
        end

        def test_adjust_in_euros
          order = Order.new(
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
                      "original_price" => 82.41,
                      "tax_code" => nil
                    },
                    amount: { cents: 8241.0, currency_iso: "USD" }
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

          shipping = Shipping.new

          FlowLocalizationCalculator.test_adjust(order, shipping)
        end
      end
    end
  end
end
