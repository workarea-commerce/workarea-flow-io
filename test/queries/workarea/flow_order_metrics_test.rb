require 'test_helper'

module Workarea
  class FlowOrderMetricsTest < TestCase
    def test_discounts
      order = Order.new(
        flow: true,
        items: [
          {
            "total_value" => { "cents" => 0.0, "currency_iso" => "USD" },
            "total_price" => { "cents" => 0.0, "currency_iso" => "USD" },
            "sku" => "004056270-0",
            "product_id" => "cool-shirt",
            "price_adjustments" => [
              {
                "quantity" => 1,
                "data" => {
                  "on_sale" => false,
                  "original_price" => 5.0,
                  "tax_code" => nil,
                  "localized_item_price" => {
                    "currency" => "EUR",
                    "amount" => 92.95,
                    "label" => "92,95 €",
                    "base" => { "amount" => 104.28, "currency" => "USD", "label" => "US$104.28" },
                    "includes" => { "key" => "vat", "label" => "Includes VAT" },
                    "key" => "localized_item_price"
                  },
                  "description" => "Flow Localized Item Price Base"
                },
                "price" => "item",
                "calculator" => "Workarea::FlowIo::PriceApplier::ItemApplier",
                "amount" => { "cents" => 10428.0, "currency_iso" => "USD" },
                "description" => "Item Subtotal"
              },
              {
                "quantity" => 1,
                "data" => {
                  "localized_line_item_discount" => {
                    "amount" => 0.23,
                    "currency" => "EUR",
                    "label" => "0,23 €",
                    "base" => { "amount" => 0.25, "currency" => "USD", "label" => "US$0.25" },
                    "requested" => { "amount" => 0.25, "currency" => "USD" }
                  },
                  "description" => "Flow Localized Line Item Discount Base",
                  "discount_amount" => { "cents" => 25.0, "currency_iso" => "USD" },
                  "original_discounts" => [
                    {
                      "id" => "5b60ba1f87c68b6b757cde58",
                      "quantity" => 1,
                      "amount" => { "cents" => -25.0, "currency_iso" => "USD" }
                    }
                  ]
                },
                "price" => "item",
                "calculator" => "Workarea::FlowIo::PriceApplier::ItemApplier",
                "amount" => { "cents" => -25.0, "currency_iso" => "USD" },
                "description" => "Discount"
              },
              {
                "quantity" => 1,
                "data" => {
                  "description" => "Flow Localized Order Discount Base",
                  "original_discounts" => [
                    {
                      "id" => "5b60ba1f87c68b6b757cde59",
                      "quantity" => 1,
                      "amount" => { "cents" => -20.0, "currency_iso" => "USD" }
                    }
                  ],
                  "discount_value" => { "cents" => 20.0, "currency_iso" => "USD" }
                },
                "price" => "order",
                "calculator" => "Workarea::FlowIo::PriceApplier",
                "amount" => { "cents" => -20.0, "currency_iso" => "USD" },
                "description" => "Discount"
              }
            ]
          }
        ]
      )

      metrics = OrderMetrics.new(order)

      expected_discounts = {
        "5b60ba1f87c68b6b757cde58" => {
          orders: 1,
          merchandise: Money.from_amount(104.28, "USD"),
          discounts: Money.from_amount(-0.25, "USD"),
          revenue: Money.from_amount(0, "USD")
        },
        "5b60ba1f87c68b6b757cde59" => {
          orders: 1,
          merchandise: Money.from_amount(104.28, "USD"),
          discounts: Money.from_amount(-0.20, "USD"),
          revenue: Money.from_amount(0, "USD")
        }
      }

      assert_equal expected_discounts, metrics.discounts
    end
  end
end
