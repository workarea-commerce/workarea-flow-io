module Workarea
  module FlowIo
    class BogusClient
      class Orders
        def put_by_number(_organization_id, number, order_put_form, options = {})
          OrderResponse.new(number, order_put_form, options).flow_model
        end

        private

          class OrderResponse
            attr_reader :number, :order_put_form, :options

            def initialize(number, order_put_form, options)
              @number = number
              @order_put_form = order_put_form
              @options = options
            end

            def flow_model
              case options[:experience]
              when "canada" then canada_order
              when "europe" then europe_order
              else raise "No bogus response for #{options[:experience]}"
              end
            end

            private

              # TODO prices.discount based off of order_put_form
              def canada_order
                ::Io::Flow::V0::Models::Order.new(
                  id: "ord-0db4008f77b24065a1b826a18b9d87ad",
                  number: number,
                  merchant_of_record: "flow",
                  experience: { key: "canada", discriminator: "experience_reference" },
                  customer: {
                    name: { first: nil, last: nil },
                    number: nil,
                    phone: nil,
                    email: nil
                  },
                  delivered_duty: "paid",
                  destination: {
                    text: nil,
                    streets: nil,
                    city: nil,
                    province: nil,
                    postal: nil,
                    country: "CAN",
                    latitude: nil,
                    longitude: nil,
                    contact: {
                      name: { first: nil, last: nil },
                      company: nil,
                      email: nil,
                      phone: nil
                    }
                  },
                  expires_at: "Wed, 01 Aug 2018 14:58:30 +0000",
                  items: cadanda_items,
                  deliveries: [
                    {
                      id: "del-4070e782d85245f4bc29a8f56d55f33d",
                      center: { id: "cen-394b1db3c61a495c964dd1fe60969160", key: "center-workarea" },
                        items: canada_delivery_items,
                      options: [
                        {
                          id: "opt-9ea4f6c3b2894d7ebf334447469627e5",
                          cost: {
                            currency: "CAD",
                            amount: 9.29,
                            label: "CA$9.29",
                            base: { amount: 6.86, currency: "USD", label: "US$6.86" }
                          },
                          cost_details: [
                            {
                              source: "ratecard",
                              currency: "CAD",
                              amount: 0.929e1,
                              label: "CA$9.29",
                              base: { amount: 6.86, currency: "USD", label: "US$6.86" },
                              components: [
                                {
                                  key: "ratecard_base_cost",
                                  currency: "CAD",
                                  amount: 0.929e1,
                                  label: "CA$9.29",
                                  base: { amount: 6.86, currency: "USD", label: "US$6.86" }
                                }
                              ]
                            }
                          ],
                          delivered_duty: "unpaid",
                          price: {
                            currency: "CAD",
                            amount: 9.29,
                            label: "CA$9.29",
                            base: { amount: 6.86, currency: "USD", label: "US$6.86" }
                          },
                          service: {
                            id: "landmark-global",
                            carrier: { id: "landmark" },
                            name: "Global",
                            center_code: nil
                          },
                          tier: {
                            id: "tie-fc0ec702c4384dc8805ae645ef6156e8",
                            experience: { id: "canada", currency: "CAD" },
                            integration: "information",
                            name: "Standard Shipping",
                            services: ["landmark-global", "dhl-express-worldwide"],
                            strategy: "lowest_cost",
                            visibility: "public",
                            currency: "CAD",
                            display: { estimate: { type: "calculated", label: "2-5 Business Days" } }
                          },
                          window: {
                            from: "Fri, 03 Aug 2018 00:00:00 +0000",
                            to: "Wed, 08 Aug 2018 00:00:00 +0000",
                            timezone: "America/Toronto",
                            label: "2-5 Business Days"
                          },
                          rule_outcome: { ignore: nil, discriminator: "at_cost" },
                          weight: {
                            gravitational: { value: "1.25", units: "pound" },
                            dimensional: { value: "2.12", units: "inch" }
                          },
                          send_to: nil
                        },
                        {
                          id: "opt-c6cd61df76c64786b336e3d40098e797",
                          cost: {
                            currency: "CAD",
                            amount: 9.29,
                            label: "CA$9.29",
                            base: { amount: 6.86, currency: "USD", label: "US$6.86" }
                          },
                          cost_details: [
                            {
                              source: "ratecard",
                              currency: "CAD",
                              amount: 0.929e1,
                              label: "CA$9.29",
                              base: { amount: 6.86, currency: "USD", label: "US$6.86" },
                              components: [
                                {
                                  key: "ratecard_base_cost",
                                  currency: "CAD",
                                  amount: 0.929e1,
                                  label: "CA$9.29",
                                  base: { amount: 6.86, currency: "USD", label: "US$6.86" }
                                }
                              ]
                            }
                          ],
                          delivered_duty: "paid",
                          price: {
                            currency: "CAD",
                            amount: 9.29,
                            label: "CA$9.29",
                            base: { amount: 6.86, currency: "USD", label: "US$6.86" }
                          },
                          service: {
                            id: "landmark-global",
                            carrier: { id: "landmark" },
                            name: "Global",
                            center_code: nil
                          },
                          tier: {
                            id: "tie-fc0ec702c4384dc8805ae645ef6156e8",
                            experience: { id: "canada", currency: "CAD" },
                            integration: "information",
                            name: "Standard Shipping",
                            services: ["landmark-global", "dhl-express-worldwide"],
                            strategy: "lowest_cost",
                            visibility: "public",
                            currency: "CAD",
                            display: { estimate: { type: "calculated", label: "2-5 Business Days" } }
                          },
                          window: {
                            from: "Fri, 03 Aug 2018 00:00:00 +0000",
                            to: "Wed, 08 Aug 2018 00:00:00 +0000",
                            timezone: "America/Toronto",
                            label: "2-5 Business Days"
                          },
                          rule_outcome: { ignore: nil, discriminator: "at_cost" },
                          weight: {
                            gravitational: { value: "1.25", units: "pound" },
                            dimensional: { value: "2.12", units: "inch" }
                          },
                          send_to: nil
                        }
                      ],
                      discriminator: "physical_delivery"
                    }
                  ],
                  selections: ["opt-c6cd61df76c64786b336e3d40098e797"],
                  prices: [
                    {
                      key: "subtotal",
                      currency: "CAD",
                      amount: 0.11964e3,
                      label: "CA$119.64",
                      base: { amount: 88.41, currency: "USD", label: "US$88.41" },
                      components: [
                        {
                          key: "item_price",
                          currency: "CAD",
                          amount: 0.11712e3,
                          label: "CA$117.12",
                          base: { amount: 86.53, currency: "USD", label: "US$86.53" },
                          name: "Item price"
                        },
                        {
                          key: "item_discount",
                          currency: "CAD",
                          amount: -0.36e0,
                          label: "-CA$0.36",
                          base: { amount: -0.25, currency: "USD", label: "-US$0.25" },
                          name: "Item discount"
                        },
                        {
                          key: "rounding",
                          currency: "CAD",
                          amount: 0.288e1,
                          label: "CA$2.88",
                          base: { amount: 2.13, currency: "USD", label: "US$2.13" },
                          name: "Rounding"
                        }
                      ],
                      name: "Item subtotal",
                      rate: nil
                    },
                    {
                      key: "vat",
                      currency: "CAD",
                      amount: 0.2124e2,
                      label: "CA$21.24",
                      base: { amount: 15.69, currency: "USD", label: "US$15.69" },
                      components: [
                        {
                          key: "vat_item_price",
                          currency: "CAD",
                          amount: 0.18e2,
                          label: "CA$18.00",
                          base: { amount: 13.3, currency: "USD", label: "US$13.30" },
                          name: "HST on item price"
                        },
                        {
                          key: "vat_duties_item_price",
                          currency: "CAD",
                          amount: 0.324e1,
                          label: "CA$3.24",
                          base: { amount: 2.39, currency: "USD", label: "US$2.39" },
                          name: "HST on duties on item price"
                        }
                      ],
                      name: "HST",
                      rate: nil
                    },
                    {
                      key: "duty",
                      currency: "CAD",
                      amount: 0.216e2,
                      label: "CA$21.60",
                      base: { amount: 15.96, currency: "USD", label: "US$15.96" },
                      components: [
                        {
                          key: "duties_item_price",
                          currency: "CAD",
                          amount: 0.216e2,
                          label: "CA$21.60",
                          base: { amount: 15.96, currency: "USD", label: "US$15.96" },
                          name: "Duties on item price"
                        }
                      ],
                      name: "Duties",
                      rate: nil
                    },
                    {
                      key: "shipping",
                      currency: "CAD",
                      amount: 0.929e1,
                      label: "CA$9.29",
                      base: { amount: 6.86, currency: "USD", label: "US$6.86" },
                      components: [
                        {
                          key: "shipping",
                          currency: "CAD",
                          amount: 0.929e1,
                          label: "CA$9.29",
                          base: { amount: 6.86, currency: "USD", label: "US$6.86" },
                          name: "Shipping"
                        }
                      ],
                      name: "Shipping",
                      rate: nil
                    },
                    {
                      key: "discount",
                      currency: "CAD",
                      amount: -0.28e0,
                      label: "-CA$0.28",
                      base: { amount: -0.2, currency: "USD", label: "-US$0.20" },
                      components: [
                        {
                          key: "order_discount",
                          currency: "CAD",
                          amount: -0.28e0,
                          label: "-CA$0.28",
                          base: { amount: -0.2, currency: "USD", label: "-US$0.20" },
                          name: "Order discount"
                        }
                      ],
                      name: "Discount",
                      rate: nil
                    }
                  ],
                  total: {
                    currency: "CAD",
                    amount: 171.49,
                    label: "CA$171.49",
                    base: { amount: 126.72, currency: "USD", label: "US$126.72" },
                    key: "localized_total"
                  },
                  attributes: { "number" => number },
                  submitted_at: nil,
                  lines: canada_lines,
                  identifiers: nil,
                  promotions: nil,
                  payments: [],
                  balance: {
                    currency: "CAD",
                    amount: 171.49,
                    label: "CA$171.49",
                    base: { amount: 126.72, currency: "USD", label: "US$126.72" },
                    key: "localized_total"
                  },
                  rules: nil,
                  tax_registration: nil,
                  discriminator: "order"
                )
              end

              def cadanda_items
                order_put_form.items.map do |line_item_form|
                  item = {
                    number: line_item_form.number,
                    name: "Incredible Cotton Bag",
                    quantity: line_item_form.quantity,
                    center: nil,
                    price: nil,
                    attributes: nil,
                    local: {
                      experience: {
                        id: "exp-95889ba1ff4b449f8a3c0e0a7a4fb23b",
                        key: "canada",
                        name: "Canada",
                        country: nil,
                        currency: nil,
                        language: nil
                      },
                      prices: [
                        {
                          currency: "CAD",
                          amount: 120,
                          label: "CA$120.00",
                          base: { amount: 88.66, currency: "USD", label: "US$88.66" },
                          includes: nil,
                          key: "localized_item_price"
                        }
                      ],
                      rates: [],
                      spot_rates: [],
                      status: "included",
                      attributes: {
                        "msrp" => "92.41",
                        "Size" => "Extra Large",
                        "regular_price" => "82.41",
                        "sale_price" => "120.0",
                        "product_id" => "890726C80A",
                        "Color" => "Orange",
                        "fulfillment_method" => "physical"
                      },
                      price_attributes: {
                        "sale_price" => {
                          currency: "CAD",
                          amount: 120,
                          label: "CA$120.00",
                          base: { amount: 88.66, currency: "USD", label: "US$88.66" }
                        }
                      }
                    },
                    shipment_estimate: nil
                  }

                  if line_item_form.discount.present?
                    item.merge!(discount: {
                      amount: 0.36,
                      currency: "CAD",
                      label: "CA$0.36",
                      base: line_item_form.discount.to_hash.merge(label: "US$0.25"),
                      requested: line_item_form.discount
                    })
                  end

                  item
                end
              end

              def canada_lines
                order_put_form.items.map do |line_item_form|
                  {
                    item_number: line_item_form.number,
                    quantity: line_item_form.quantity,
                    price: {
                      currency: "CAD",
                      amount: 119.64,
                      label: "CA$119.64",
                      base: { amount: 88.41, currency: "USD", label: "US$88.41" }
                    },
                    total: {
                      currency: "CAD",
                      amount: 119.64,
                      label: "CA$119.64",
                      base: { amount: 88.41, currency: "USD", label: "US$88.41" }
                    },
                    attributes: nil
                  }
                end
              end

              def canada_delivery_items
                order_put_form.items.map do |line_item_form|
                  {
                    number: line_item_form.number,
                    quantity: line_item_form.quantity,
                    shipment_estimate: nil,
                    price: { amount: 120, currency: "CAD" },
                    attributes: { "base_amount" => "88.66", "base_currency" => "USD" },
                    center: nil,
                    discount: line_item_form.discount&.to_hash
                  }
                end
              end

              def europe_order
                ::Io::Flow::V0::Models::Order.new(
                  id: "ord-5e96fb772368459da53afdcbb0a71523",
                  number: "A4C6451953",
                  merchant_of_record: "flow",
                  experience: { key: "europe", discriminator: "experience_reference" },
                  customer: { name: { first: nil, last: nil }, number: nil, phone: nil, email: nil },
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
                      name: { first: nil, last: nil },
                      company: nil,
                      email: nil,
                      phone: nil
                    }
                  },
                  expires_at: "Thu, 02 Aug 2018 15:24:56 +0000",
                  items: europe_items,
                  deliveries: [
                    {
                      id: "del-d3b86de4c9b44810afa7907b32f646a9",
                      center: { id: "cen-394b1db3c61a495c964dd1fe60969160", key: "center-workarea" },
                      items: europe_delivery_items,
                      options: [
                        {
                          id: "opt-621baad1e93440afafb16b0d497e45f7",
                          cost: {
                            currency: "EUR",
                            amount: 5.23,
                            label: "5,23 €",
                            base: { amount: 5.87, currency: "USD", label: "US$5.87" }
                          },
                          cost_details: [
                            {
                              source: "ratecard",
                              currency: "EUR",
                              amount: 0.523e1,
                              label: "5,23 €",
                              base: { amount: 5.87, currency: "USD", label: "US$5.87" },
                              components: [
                                {
                                  key: "ratecard_base_cost",
                                  currency: "EUR",
                                  amount: 0.523e1,
                                  label: "5,23 €",
                                  base: { amount: 5.87, currency: "USD", label: "US$5.87" }
                                }
                              ]
                            }
                          ],
                          delivered_duty: "unpaid",
                          price: {
                            currency: "EUR",
                            amount: 10,
                            label: "10,00 €",
                            base: { amount: 10.68, currency: "USD", label: "US$10.68" }
                          },
                          service: {
                            id: "landmark-global",
                            carrier: { id: "landmark" },
                            name: "Global",
                            center_code: nil
                          },
                          tier: {
                            id: "tie-6b992ea6b5c448b1bd033332fdd9dd45",
                            experience: { id: "europe", currency: "EUR" },
                            integration: "information",
                            name: "Standard Shipping",
                            services: ["landmark-global"],
                            strategy: "lowest_cost",
                            visibility: "public",
                            currency: "EUR",
                            display: { estimate: { type: "calculated", label: "2-4 Business Days" } }
                          },
                          window: {
                            from: "Mon, 06 Aug 2018 00:00:00 +0000",
                            to: "Wed, 08 Aug 2018 00:00:00 +0000",
                            timezone: "Etc/GMT",
                            label: "2-4 Business Days"
                          },
                          rule_outcome: {
                            price: { amount: 10, currency: "EUR", label: "10,00 €" },
                            discriminator: "flat_rate"
                          },
                          weight: {
                            gravitational: { value: "1.25", units: "pound" },
                            dimensional: { value: "2.12", units: "inch" }
                          },
                          send_to: nil
                        },
                        {
                          id: "opt-213affb5d1f74737bbb3af3a4c117ad5",
                          cost:         { currency: "EUR",
                                          amount: 5.23,
                                          label: "5,23 €",
                                          base: { amount: 5.87, currency: "USD", label: "US$5.87" } },
                        cost_details:         [{ source: "ratecard",
                                                 currency: "EUR",
                                                 amount: 0.523e1,
                                                 label: "5,23 €",
                                                 base: { amount: 5.87, currency: "USD", label: "US$5.87" },
                                                 components:         [{ key: "ratecard_base_cost",
                                                                        currency: "EUR",
                                                                        amount: 0.523e1,
                                                                        label: "5,23 €",
                                                                        base: { amount: 5.87, currency: "USD", label: "US$5.87" } }] }],
                        delivered_duty: "paid",
                        price:         { currency: "EUR",
                                         amount: 10,
                                         label: "10,00 €",
                                         base: { amount: 10.68, currency: "USD", label: "US$10.68" } },
                        service:         { id: "landmark-global",
                                           carrier: { id: "landmark" },
                                           name: "Global",
                                           center_code: nil },
                                           tier:         { id: "tie-6b992ea6b5c448b1bd033332fdd9dd45",
                                                           experience: { id: "europe", currency: "EUR" },
                                                           integration: "information",
                                                           name: "Standard Shipping",
                                                           services: ["landmark-global"],
                                                           strategy: "lowest_cost",
                                                           visibility: "public",
                                                           currency: "EUR",
                                                           display:         { estimate: { type: "calculated", label: "2-4 Business Days" } } },
                        window:         { from: "Mon, 06 Aug 2018 00:00:00 +0000",
                                          to: "Wed, 08 Aug 2018 00:00:00 +0000",
                                          timezone: "Etc/GMT",
                                          label: "2-4 Business Days" },
                                          rule_outcome:         { price: { amount: 10, currency: "EUR", label: "10,00 €" },
                                                                  discriminator: "flat_rate" },
                                                                  weight:         { gravitational: { value: "1.25", units: "pound" },
                                                                                    dimensional: { value: "2.12", units: "inch" } },
                        send_to: nil }],
                        discriminator: "physical_delivery"
                    }
                  ],
                  selections: ["opt-213affb5d1f74737bbb3af3a4c117ad5"],
                  prices: [
                    {
                      key: "subtotal",
                      currency: "EUR",
                      amount: 0.9272e2,
                      label: "92,72 €",
                      base: { amount: 104.03, currency: "USD", label: "US$104.03" },
                      components: [
                        {
                          key: "vat_deminimis",
                          currency: "EUR",
                          amount: -0.185e1,
                          label: "-1,85 €",
                          base: { amount: -2.07, currency: "USD", label: "-US$2.07" },
                          name: "VAT de minimis adjustment"
                        },
                        {
                          key: "vat_item_price",
                          currency: "EUR",
                          amount: 0.1549e2,
                          label: "15,49 €",
                          base: { amount: 17.38, currency: "USD", label: "US$17.38" },
                          name: "VAT on item price"
                        },
                        {
                          key: "vat_duties_item_price",
                          currency: "EUR",
                          amount: 0.185e1,
                          label: "1,85 €",
                          base: { amount: 2.07, currency: "USD", label: "US$2.07" },
                          name: "VAT on duties on item price"
                        },
                        {
                          key: "item_price",
                          currency: "EUR",
                          amount: 0.7713e2,
                          label: "77,13 €",
                          base: { amount: 86.53, currency: "USD", label: "US$86.53" },
                          name: "Item price"
                        },
                        {
                          key: "item_discount",
                          currency: "EUR",
                          amount: -0.23e0,
                          label: "-0,23 €",
                          base: { amount: -0.25, currency: "USD", label: "-US$0.25" },
                          name: "Item discount"
                        },
                        {
                          key: "rounding",
                          currency: "EUR",
                          amount: 0.33e0,
                          label: "0,33 €",
                          base: { amount: 0.37, currency: "USD", label: "US$0.37" },
                          name: "Rounding"
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
                      base: { amount: 10.68, currency: "USD", label: "US$10.68" },
                      components: [
                        {
                          key: "vat_deminimis",
                          currency: "EUR",
                          amount: -0.13e0,
                          label: "-0,13 €",
                          base: { amount: -0.14, currency: "USD", label: "-US$0.14" },
                          name: "VAT de minimis adjustment"
                        },
                        {
                          key: "vat_freight",
                          currency: "EUR",
                          amount: 0.105e1,
                          label: "1,05 €",
                          base: { amount: 1.17, currency: "USD", label: "US$1.17" },
                          name: "VAT on freight"
                        },
                        {
                          key: "vat_duties_freight",
                          currency: "EUR",
                          amount: 0.13e0,
                          label: "0,13 €",
                          base: { amount: 0.14, currency: "USD", label: "US$0.14" },
                          name: "VAT on duties on freight"
                        },
                        {
                          key: "shipping",
                          currency: "EUR",
                          amount: 0.1e2,
                          label: "10,00 €",
                          base: { amount: 10.68, currency: "USD", label: "US$10.68" },
                          name: "Shipping"
                        },
                        {
                          key: "vat_subsidy",
                          currency: "EUR",
                          amount: -0.105e1,
                          label: "-1,05 €",
                          base: { amount: -1.17, currency: "USD", label: "-US$1.17" },
                          name: "VAT subsidy"
                        }
                      ],
                      name: "Shipping",
                      rate: nil
                    },
                    {
                      key: "discount",
                      currency: "EUR",
                      amount: -0.19e0,
                      label: "-0,19 €",
                      base: { amount: -0.2, currency: "USD", label: "-US$0.20" },
                      components: [
                        {
                          key: "order_discount",
                          currency: "EUR",
                          amount: -0.19e0,
                          label: "-0,19 €",
                          base: { amount: -0.2, currency: "USD", label: "-US$0.20" },
                          name: "Order discount"
                        }
                      ],
                      name: "Discount",
                      rate: nil
                    }
                  ],
                  total: {
                    currency: "EUR",
                    amount: 102.53,
                    label: "102,53 €",
                    base: { amount: 114.51, currency: "USD", label: "US$114.51" },
                    key: "localized_total"
                  },
                  attributes: { "number" => "A4C6451953" },
                  submitted_at: nil,
                  lines: europe_lines,
                  identifiers: nil,
                  promotions: nil,
                  payments: [],
                  balance: {
                    currency: "EUR",
                    amount: 102.53,
                    label: "102,53 €",
                    base: { amount: 114.51, currency: "USD", label: "US$114.51" },
                    key: "localized_total"
                  },
                  rules: nil,
                  tax_registration: nil,
                  discriminator: "order"
                )
              end

              def europe_items
                order_put_form.items.map do |line_item_form|
                  item = {
                    number: line_item_form.number,
                    name: "Incredible Cotton Bag",
                    quantity: 1,
                    center: nil,
                    price: nil,
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
                          amount: 92.95,
                          label: "92,95 €",
                          base: { amount: 104.28, currency: "USD", label: "US$104.28" },
                          includes: { key: "vat", label: "Includes VAT" },
                          key: "localized_item_price"
                        }
                      ],
                      rates: [
                        {
                          id: "usd-gbp",
                          base: "USD",
                          target: "GBP",
                          effective_at: "Thu, 02 Aug 2018 14:24:55 +0000",
                          value: 0.832102908e0
                        },
                        {
                          id: "usd-eur",
                          base: "USD",
                          target: "EUR",
                          effective_at: "Thu, 02 Aug 2018 14:24:55 +0000",
                          value: 0.935923716e0
                        },
                        {
                          id: "gbp-eur",
                          base: "GBP",
                          target: "EUR",
                          effective_at: "Thu, 02 Aug 2018 14:24:55 +0000",
                          value: 0.1124769192610489e1
                        }
                      ],
                      spot_rates: [],
                      status: "included",
                      attributes: {
                        "msrp" => "92.41",
                        "Size" => "Extra Large",
                        "regular_price" => "82.41",
                        "sale_price" => "91.95",
                        "product_id" => "890726C80A",
                        "Color" => "Orange",
                        "fulfillment_method" => "physical"
                      },
                      price_attributes: {
                        "sale_price" =>
                        { currency: "EUR",
                          amount: 91.95,
                          label: "91,95 €",
                          base: { amount: 103.16, currency: "USD", label: "US$103.16" }
                        }
                      }
                    },
                    shipment_estimate: nil
                  }

                  if line_item_form.discount.present?
                    item.merge!(discount: {
                      amount: 0.23,
                      currency: "EUR",
                      label: "0,23 €",
                      base: line_item_form.discount.to_hash.merge(label: "US$0.25"),
                      requested: line_item_form.discount
                    })
                  end

                  item
                end
              end

              def europe_lines
                order_put_form.items.map do |line_item_form|
                  {
                    item_number: line_item_form.number,
                    quantity: line_item_form.quantity,
                    price: {
                      currency: "EUR",
                      amount: 92.72,
                      label: "92,72 €",
                      base: { amount: 104.03, currency: "USD", label: "US$104.03" }
                    },
                    total: {
                      currency: "EUR",
                      amount: 92.72,
                      label: "92,72 €",
                      base: { amount: 104.03, currency: "USD", label: "US$104.03" }
                    },
                    attributes: nil
                  }
                end
              end

              def europe_delivery_items
                order_put_form.items.map do |line_item_form|
                  {
                    number: line_item_form.number,
                    quantity: line_item_form.quantity,
                    shipment_estimate: nil,
                    price: { amount: 92.95, currency: "EUR" },
                    attributes: { "base_amount" => "104.28", "base_currency" => "USD" },
                    center: nil,
                    discount: line_item_form.discount&.to_hash
                  }
                end
              end
          end
      end
    end
  end
end
