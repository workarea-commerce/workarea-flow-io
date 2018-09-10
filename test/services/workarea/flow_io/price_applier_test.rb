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

        assert_equal(
          ["5b60ba1f87c68b6b757cde58", "5b60ba1f87c68b6b757cde59"],
          order.discount_ids
        )

        expected_orignal_discounts = [
          [
            {
              "id" => "5b60ba1f87c68b6b757cde58",
              "quantity" => 1,
              "amount" => { "cents" => -25.0, "currency_iso" => "USD" }
            }
          ],
          [
            { "id" => "5b60ba1f87c68b6b757cde59",
              "quantity" => 1,
              "amount" => { "cents" => -20.0, "currency_iso" => "USD" }
            }
          ]
        ]

        assert_equal(
          expected_orignal_discounts,
          item.price_adjustments.select(&:discount?).map do |price_adjustment|
            price_adjustment.data["original_discounts"].map(&:deep_stringify_keys)
          end
        )
      end

      def test_rounding_line_item
        order = Order.new(
          id: "ORD123",
          experience: europe_experience_geo,
          items: [
            {
              sku: "004056270-0",
              product_id: "cool-shirt",
              quantity: 3,
              price_adjustments: [
                {
                  price: "item",
                  quantity: 3,
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
                }
              ]
            }
          ]
        )

        flow_order = europe_rounding_order

        FlowIo::PriceApplier.perform(order: order, flow_order: flow_order)
      end

      private

      def europe_rounding_order
        ::Io::Flow::V0::Models::Order.new({
          id: "ord-de8014d720bc43ed8bf95ef66a246fbb",
          number: "41709C67CE",
          merchant_of_record: "flow",
          experience: {
            key: "europe",
            discriminator: "experience_reference"
          },
          customer: {
            name: {
              first: "Ben",
              last: "Crouse"
            },
            number: nil,
            phone: nil,
            email: "user@workarea.com"
          },
          delivered_duty: "paid",
          destination: {
            text: nil,
            streets: nil,
            city: nil,
            province: nil,
            postal: nil,
            country: "GBR",
            latitude: nil,
            longitude: nil,
            contact: {
              name: {
                first: "Ben",
                last: "Crouse"
              },
              company: nil,
              email: "user@workarea.com",
              phone: nil
            }
          },
          expires_at: "Thu, 09 Aug 2018 16:58:57 +0000",
          items: [
            {
              number: "004056270-0",
              name: "Intelligent Steel Knife",
              quantity: 3,
              center: nil,
              price: nil,
              discount: {
                amount: 0.41,
                currency: "EUR",
                label: "0,41 €",
                base: {
                  amount: 0.44,
                  currency: "USD",
                  label: "US$0.44"
                },
                requested: {
                  amount: 0.44,
                  currency: "USD"
                }
              },
              attributes: nil,
              local: {
                experience: {
                  id: "exp-72464b1f651d49fe8108dcabf4678942",
                  key: "europe",
                  name: "Europe",
                  country: nil,
                  currency: nil,
                  language: nil
                },
                prices: [
                  {
                    currency: "EUR",
                    amount: 0.95,
                    label: "0,95 €",
                    base: {
                      amount: 1.06,
                      currency: "USD",
                      label: "US$1.06"
                    },
                    includes: {
                      key: "vat",
                      label: "Includes VAT"
                    },
                    key: "localized_item_price"
                  }
                ],
                rates: [
                  {
                    id: "usd-gbp",
                    base: "USD",
                    target: "GBP",
                    effective_at: "Thu, 09 Aug 2018 15:58:57 +0000",
                    value: 0.843986052e0
                  },
                  {
                    id: "usd-eur",
                    base: "USD",
                    target: "EUR",
                    effective_at: "Thu, 09 Aug 2018 15:58:57 +0000",
                    value: 0.9403212e0
                  },
                  {
                    id: "gbp-eur",
                    base: "GBP",
                    target: "EUR",
                    effective_at: "Thu, 09 Aug 2018 15:58:57 +0000",
                    value: 0.11141430569518465e1
                  }
                ],
                spot_rates: [],
                status: "included",
                attributes: {
                  "msrp" => "10.44",
                  "Size" => "Large",
                  "regular_price" => "0.44",
                  "sale_price" => "3.95",
                  "product_id" => "A06AB102F5",
                  "Color" => "Fuchsia",
                  "fulfillment_method" => "physical"
                },
                price_attributes: {
                  "sale_price" => {
                    currency: "EUR",
                    amount: 3.95,
                    label: "3,95 €",
                    base: {
                      amount: 4.41,
                      currency: "USD",
                      label: "US$4.41"
                    }
                  }
                }
              },
              shipment_estimate: nil
            },
            {
              number: "493137410-7",
              name: "Synergistic Silk Plate",
              quantity: 3,
              center: nil,
              price: nil,
              discount: {
                amount: 0.41,
                currency: "EUR",
                label: "0,41 €",
                base: {
                  amount: 0.44,
                  currency: "USD",
                  label: "US$0.44"
                },
                requested: {
                  amount: 0.44,
                  currency: "USD"
                }
              },
              attributes: nil,
              local: {
                experience: {
                  id: "exp-72464b1f651d49fe8108dcabf4678942",
                  key: "europe",
                  name: "Europe",
                  country: nil,
                  currency: nil,
                  language: nil
                },
                prices: [
                  {
                    currency: "EUR",
                    amount: 0.95,
                    label: "0,95 €",
                    base: {
                      amount: 1.06,
                      currency: "USD",
                      label: "US$1.06"
                    },
                    includes: {
                      key: "vat",
                      label: "Includes VAT"
                    },
                    key: "localized_item_price"
                  }
                ],
                rates: [
                  {
                    id: "usd-gbp",
                    base: "USD",
                    target: "GBP",
                    effective_at: "Thu, 09 Aug 2018 15:58:57 +0000",
                    value: 0.843986052e0
                  },
                  {
                    id: "usd-eur",
                    base: "USD",
                    target: "EUR",
                    effective_at: "Thu, 09 Aug 2018 15:58:57 +0000",
                    value: 0.9403212e0
                  },
                  {
                    id: "gbp-eur",
                    base: "GBP",
                    target: "EUR",
                    effective_at: "Thu, 09 Aug 2018 15:58:57 +0000",
                    value: 0.11141430569518465e1
                  }
                ],
                spot_rates: [],
                status: "included",
                attributes: {
                  "msrp" => "100.5",
                  "Size" => "Extra Large",
                  "regular_price" => "0.44",
                  "sale_price" => "0.95",
                  "product_id" => "8C1FAF561F",
                  "Color" => "Green",
                  "fulfillment_method" => "physical"
                },
                price_attributes: {
                  "sale_price" => {
                    currency: "EUR",
                    amount: 0.95,
                    label: "0,95 €",
                    base: {
                      amount: 1.06,
                      currency: "USD",
                      label: "US$1.06"
                    }
                  }
                }
              },
              shipment_estimate: nil
            }
          ],
          deliveries: [
            {
              id: "del-924e558bc5134047a4d3b80eeca46952",
              center: {
                id: "cen-394b1db3c61a495c964dd1fe60969160",
                key: "center-workarea"
              },
              items: [
                {
                  number: "004056270-0",
                  quantity: 3,
                  shipment_estimate: nil,
                  price: {
                    amount: 0.95,
                    currency: "EUR"
                  },
                  attributes: {
                    "base_amount" => "1.06",
                    "base_currency" => "USD"
                  },
                  center: nil,
                  discount: {
                    amount: 0.44,
                    currency: "USD"
                  }
                }
              ],
              options: [
                {
                  id: "opt-e1910958ea1d437ea9a9b57a231eeb12",
                  cost: {
                    currency: "EUR",
                    amount: 5.26,
                    label: "5,26 €",
                    base: {
                      amount: 5.87,
                      currency: "USD",
                      label: "US$5.87"
                    }
                  },
                  cost_details: [
                    {
                      source: "ratecard",
                      currency: "EUR",
                      amount: 0.526e1,
                      label: "5,26 €",
                      base: {
                        amount: 5.87,
                        currency: "USD",
                        label: "US$5.87"
                      },
                      components: [
                        {
                          key: "ratecard_base_cost",
                          currency: "EUR",
                          amount: 0.526e1,
                          label: "5,26 €",
                          base: {
                            amount: 5.87,
                            currency: "USD",
                            label: "US$5.87"
                          }
                        }
                      ]
                    }
                  ],
                  delivered_duty: "unpaid",
                  price: {
                    currency: "EUR",
                    amount: 10,
                    label: "10,00 €",
                    base: {
                      amount: 10.63,
                      currency: "USD",
                      label: "US$10.63"
                    }
                  },
                  service: {
                    id: "landmark-global",
                    carrier: {
                      id: "landmark"
                    },
                    name: "Global",
                    center_code: nil
                  },
                  tier: {
                    id: "tie-6b992ea6b5c448b1bd033332fdd9dd45",
                    experience: {
                      id: "europe",
                      currency: "EUR"
                    },
                    integration: "information",
                    name: "Standard Shipping",
                    services: ["landmark-global"],
                    strategy: "lowest_cost",
                    visibility: "public",
                    currency: "EUR",
                    display: {
                      estimate: {
                        type: "calculated",
                        label: "2-4 Business Days"
                      }
                    }
                  },
                  window: {
                    from: "Mon,
13 Aug 2018 00:00:00 +0000",
to: "Wed,
15 Aug 2018 00:00:00 +0000",
timezone: "Etc/GMT",
label: "2-4 Business Days"
                  },
                  rule_outcome: {
                    price: {
                      amount: 10,
                      currency: "EUR",
                      label: "10,00 €"
                    },
                    discriminator: "flat_rate"
                  },
                  weight: {
                    gravitational: {
                      value: "6.75",
                      units: "pound"
                    },
                    dimensional: {
                      value: "3.81",
                      units: "inch"
                    }
                  },
                  send_to: nil
                },
                {
                  id: "opt-0ab2474735714fcda94f18e420a0a1b7",
                  cost: {
                    currency: "EUR",
                    amount: 5.26,
                    label: "5,26 €",
                    base: {
                      amount: 5.87,
                      currency: "USD",
                      label: "US$5.87"
                    }
                  },
                  cost_details: [
                    {
                      source: "ratecard",
                      currency: "EUR",
                      amount: 0.526e1,
                      label: "5,26 €",
                      base: {
                        amount: 5.87,
                        currency: "USD",
                        label: "US$5.87"
                      },
                      components: [
                        {
                          key: "ratecard_base_cost",
                          currency: "EUR",
                          amount: 0.526e1,
                          label: "5,26 €",
                          base: {
                            amount: 5.87,
                            currency: "USD",
                            label: "US$5.87"
                          }
                        }
                      ]
                    }
                  ],
                  delivered_duty: "paid",
                  price: {
                    currency: "EUR",
                    amount: 10,
                    label: "10,00 €",
                    base: {
                      amount: 10.63,
                      currency: "USD",
                      label: "US$10.63"
                    }
                  },
                  service: {
                    id: "landmark-global",
                    carrier: {
                      id: "landmark"
                    },
                    name: "Global",
                    center_code: nil
                  },
                  tier: {
                    id: "tie-6b992ea6b5c448b1bd033332fdd9dd45",
                    experience: {
                      id: "europe",
                      currency: "EUR"
                    },
                    integration: "information",
                    name: "Standard Shipping",
                    services: ["landmark-global"],
                    strategy: "lowest_cost",
                    visibility: "public",
                    currency: "EUR",
                    display: {
                      estimate: {
                        type: "calculated",
                        label: "2-4 Business Days"
                      }
                    }
                  },
                  window: {
                    from: "Mon,
13 Aug 2018 00:00:00 +0000",
to: "Wed,
15 Aug 2018 00:00:00 +0000",
timezone: "Etc/GMT",
label: "2-4 Business Days"
                  },
                  rule_outcome: {
                    price: {
                      amount: 10,
                      currency: "EUR",
                      label: "10,00 €"
                    },
                    discriminator: "flat_rate"
                  },
                  weight: {
                    gravitational: {
                      value: "6.75",
                      units: "pound"
                    },
                    dimensional: {
                      value: "3.81",
                      units: "inch"
                    }
                  },
                  send_to: nil
                }
              ],
              discriminator: "physical_delivery"
            }
          ],
          selections: ["opt-0ab2474735714fcda94f18e420a0a1b7"],
          prices: [
            {
              key: "subtotal",
              currency: "EUR",
              amount: 0.1378e2,
              label: "13,78 €",
              base: {
                amount: 17.78,
                currency: "USD",
                label: "US$17.78"
              },
              components: [
                {
                  key: "adjustment",
                  currency: "EUR",
                  amount: 0.1764e2,
                  label: "17,64 €",
                  base: {
                    amount: 19.72,
                    currency: "USD",
                    label: "US$19.72"
                  },
                  name: "Adjustment"
                },
                {
                  key: "vat_deminimis",
                  currency: "EUR",
                  amount: -0.1043e2,
                  label: "-10,43 €",
                  base: {
                    amount: -11.65,
                    currency: "USD",
                    label: "-US$11.65"
                  },
                  name: "VAT de minimis adjustment"
                },
                {
                  key: "vat_item_price",
                  currency: "EUR",
                  amount: 0.931e1,
                  label: "9,31 €",
                  base: {
                    amount: 10.4,
                    currency: "USD",
                    label: "US$10.40"
                  },
                  name: "VAT on item price"
                },
                {
                  key: "vat_duties_item_price",
                  currency: "EUR",
                  amount: 0.112e1,
                  label: "1,12 €",
                  base: {
                    amount: 1.25,
                    currency: "USD",
                    label: "US$1.25"
                  },
                  name: "VAT on duties on item price"
                },
                {
                  key: "item_price",
                  currency: "EUR",
                  amount: 0.4649e2,
                  label: "46,49 €",
                  base: {
                    amount: 51.92,
                    currency: "USD",
                    label: "US$51.92"
                  },
                  name: "Item price"
                },
                {
                  key: "item_discount",
                  currency: "EUR",
                  amount: -0.4485e2,
                  label: "-44,85 €",
                  base: {
                    amount: -47.7,
                    currency: "USD",
                    label: "-US$47.70"
                  },
                  name: "Item discount"
                },
                {
                  key: "rounding",
                  currency: "EUR",
                  amount: 0.333e1,
                  label: "3,33 €",
                  base: {
                    amount: 3.7,
                    currency: "USD",
                    label: "US$3.70"
                  },
                  name: "Rounding"
                },
                {
                  key: "vat_subsidy",
                  currency: "EUR",
                  amount: -0.883e1,
                  label: "-8,83 €",
                  base: {
                    amount: -9.86,
                    currency: "USD",
                    label: "-US$9.86"
                  },
                  name: "VAT subsidy"
                }
              ],
              name: "Item subtotal",
              rate: nil
            },
            {
              key: "shipping",
              currency: "EUR",
              amount: 0.1e2,
              label: "10,00 €",
              base: {
                amount: 10.63,
                currency: "USD",
                label: "US$10.63"
              },
              components: [
                {
                  key: "vat_deminimis",
                  currency: "EUR",
                  amount: -0.118e1,
                  label: "-1,18 €",
                  base: {
                    amount: -1.31,
                    currency: "USD",
                    label: "-US$1.31"
                  },
                  name: "VAT de minimis adjustment"
                },
                {
                  key: "vat_freight",
                  currency: "EUR",
                  amount: 0.105e1,
                  label: "1,05 €",
                  base: {
                    amount: 1.17,
                    currency: "USD",
                    label: "US$1.17"
                  },
                  name: "VAT on freight"
                },
                {
                  key: "vat_duties_freight",
                  currency: "EUR",
                  amount: 0.13e0,
                  label: "0,13 €",
                  base: {
                    amount: 0.14,
                    currency: "USD",
                    label: "US$0.14"
                  },
                  name: "VAT on duties on freight"
                },
                {
                  key: "shipping",
                  currency: "EUR",
                  amount: 0.1e2,
                  label: "10,00 €",
                  base: {
                    amount: 10.63,
                    currency: "USD",
                    label: "US$10.63"
                  },
                  name: "Shipping"
                }
              ],
              name: "Shipping",
              rate: nil
            }
          ],
          total: {
            currency: "EUR",
            amount: 23.78,
            label: "23,78 €",
            base: {
              amount: 28.41,
              currency: "USD",
              label: "US$28.41"
            },
            key: "localized_total"
          },
          attributes: {
            "number" => "41709C67CE"
          },
          submitted_at: nil,
          lines: [
            {
              item_number: "004056270-0",
              quantity: 3,
              price: {
                currency: "EUR",
                amount: 0.81,
                label: "0,81 €",
                base: {
                  amount: 0.9133333333333333,
                  currency: "USD",
                  label: "US$0.91"
                }
              },
              total: {
                currency: "EUR",
                amount: 2.43,
                label: "2,43 €",
                base: {
                  amount: 2.7399999999999998,
                  currency: "USD",
                  label: "US$2.74"
                }
              },
              attributes: nil
            }
          ],
          identifiers: nil,
          promotions: nil,
          payments: [],
          balance: {
            currency: "EUR",
            amount: 23.78,
            label: "23,78 €",
            base: {
              amount: 28.41,
              currency: "USD",
              label: "US$28.41"
            },
            key: "localized_total"
          },
          rules: nil,
          tax_registration: nil,
          discriminator: "order"
        })
      end
    end
  end
end
