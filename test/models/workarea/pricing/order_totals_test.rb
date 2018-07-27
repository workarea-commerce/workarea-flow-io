require 'test_helper'

module Workarea
  module Pricing
    class OrderTotalsTest < Workarea::TestCase
      include Workarea::FlowIo::FlowFixtures

      def test_total_with_flow_order
        OrderTotals.new(order, shippings).total

        item = order.items.first
        assert_equal(1215.20.to_m('CAD'), item.flow_total_price)

        assert_equal(1215.20.to_m('CAD'), order.flow_subtotal_price)
        assert_equal(9.42.to_m("CAD"),    order.flow_shipping_total)
        assert_equal(42.85.to_m("CAD"),   order.flow_tax_total)
        assert_equal(1267.47.to_m("CAD"), order.flow_total_price)
        assert_equal(1215.20.to_m("CAD"), order.flow_total_value)
      end

      private

      def order
        @order ||= create_order(
          experience: canada_experience_geo,
          items: [
            {
              quantity: 16,
              product_id: "E345ECDD0C",
              sku: "575616391-3",
              price_adjustments: [
                {
                  quantity: 16,
                  data: {
                    currency: "CAD",
                    amount: 75.95,
                    label: "$75.95",
                    base: { amount: 84.59, currency: "USD", label: "US$84.59" },
                    includes: { key: "vat", label: "Includes VAT" },
                    key: "localized_item_price"
                  },
                  price: "item",
                  calculator: "Workarea::FlowIo::PriceApplier",
                  amount: { cents: 135344.0, currency_iso: "USD" },
                  description: "Flow Localized Item Price Base"
                }
              ],
              flow_price_adjustments: [
                {
                  quantity: 16,
                  price: "item",
                  calculator: "Workarea::FlowIo::PriceApplier",
                  amount: { cents: 121520.0, currency_iso: "CAD" },
                  description: "Flow Localized Item Price"
                }
              ]
            }
          ]
        )
      end

      def shippings
        @shippings ||= [
          create_shipping(
            experience: canada_experience_geo,
            price_adjustments: [
              {
                quantity: 1,
                data: {
                  key: "vat",
                  currency: "CAD",
                  amount: "21.25",
                  label: "CA$21.25",
                  base: { amount: 15.49, currency: "USD", label: "US$15.49" },
                  components: [
                    {
                      key: "vat_item_price",
                      currency: "CAD",
                      amount: "18.0",
                      label: "CA$18.00",
                      base: { amount: 13.11, currency: "USD", label: "US$13.11" },
                      name: "HST on item price"
                    },
                    {
                      key: "vat_duties_item_price",
                      currency: "CAD",
                      amount: "3.25",
                      label: "CA$3.25",
                      base: { amount: 2.38, currency: "USD", label: "US$2.38" },
                      name: "HST on duties on item price"
                    }
                  ],
                  name: "HST",
                  rate: nil
                },
                price: "tax",
                description: "HST",
                calculator: "Workarea::Shipping",
                amount: { cents: 1549.0, currency_iso: "USD" }
              },
              {
                quantity: 1,
                data: {
                  key: "duty",
                  currency: "CAD",
                  amount: "21.6",
                  label: "CA$21.60",
                  base: { amount: 15.74, currency: "USD", label: "US$15.74" },
                  components: [
                    {
                      key: "duties_item_price",
                      currency: "CAD",
                      amount: "21.6",
                      label: "CA$21.60",
                      base: { amount: 15.74, currency: "USD", label: "US$15.74" },
                      name: "Duties on item price"
                    }
                  ],
                  name: "Duties",
                  rate: nil
                },
                price: "tax",
                description: "Duties",
                calculator: "Workarea::Shipping",
                amount: { cents: 1574.0, currency_iso: "USD" }
              },
              {
                quantity: 1,
                data: {
                  key: "shipping",
                  currency: "CAD",
                  amount: "9.42",
                  label: "CA$9.42",
                  base: { amount: 6.86, currency: "USD", label: "US$6.86" },
                  components: [
                    {
                      key: "shipping",
                      currency: "CAD",
                      amount: "9.42",
                      label: "CA$9.42",
                      base: { amount: 6.86, currency: "USD", label: "US$6.86" },
                      name: "Shipping"
                    }
                  ],
                  name: "Shipping",
                  rate: nil
                },
                price: "shipping",
                description: "Shipping",
                calculator: "Workarea::Shipping",
                amount: { cents: 686.0, currency_iso: "USD" }
              }
            ],
            flow_price_adjustments: [
              {
                quantity: 1,
                data: {
                  key: "vat",
                  currency: "CAD",
                  amount: "21.25",
                  label: "CA$21.25",
                  base: { amount: 15.49, currency: "USD", label: "US$15.49" },
                  components: [
                    {
                      key: "vat_item_price",
                      currency: "CAD",
                      amount: "18.0",
                      label: "CA$18.00",
                      base: { amount: 13.11, currency: "USD", label: "US$13.11" },
                      name: "HST on item price"
                    },
                    {
                      key: "vat_duties_item_price",
                      currency: "CAD",
                      amount: "3.25",
                      label: "CA$3.25",
                      base: { amount: 2.38, currency: "USD", label: "US$2.38" },
                      name: "HST on duties on item price"
                    }
                  ],
                  name: "HST",
                  rate: nil
                },
                price: "tax",
                description: "HST",
                calculator: "Workarea::Shipping",
                amount: { cents: 2125.0, currency_iso: "CAD" }
              },
              {
                quantity: 1,
                data: {
                  key: "duty",
                  currency: "CAD",
                  amount: "21.6",
                  label: "CA$21.60",
                  base: { amount: 15.74, currency: "USD", label: "US$15.74" },
                  components: [
                    {
                      key: "duties_item_price",
                      currency: "CAD",
                      amount: "21.6",
                      label: "CA$21.60",
                      base: { amount: 15.74, currency: "USD", label: "US$15.74" },
                      name: "Duties on item price"
                    }
                  ],
                  name: "Duties",
                  rate: nil
                },
                price: "tax",
                description: "Duties",
                calculator: "Workarea::Shipping",
                amount: { cents: 2160.0, currency_iso: "CAD" }
              },
              {
                quantity: 1,
                data: {
                  key: "shipping",
                  currency: "CAD",
                  amount: "9.42",
                  label: "CA$9.42",
                  base: { amount: 6.86, currency: "USD", label: "US$6.86" },
                  components: [
                    {
                      key: "shipping",
                      currency: "CAD",
                      amount: "9.42",
                      label: "CA$9.42",
                      base: { amount: 6.86, currency: "USD", label: "US$6.86" },
                      name: "Shipping"
                    }
                  ],
                  name: "Shipping",
                  rate: nil
                },
                price: "shipping",
                description: "Shipping",
                calculator: "Workarea::Shipping",
                amount: { cents: 942.0, currency_iso: "CAD" }
              }
            ]
          )
        ]
      end
    end
  end
end
