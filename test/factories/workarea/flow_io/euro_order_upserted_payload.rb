module Workarea
  module Factories
    module FlowIo
      class EuroOrderUpsertedPayload
        attr_reader :order

        def initialize(order:, shipping: nil, payment: nil)
          @order = order
        end

        def to_json
          {
            "event_id" => "evt-37ba2577b4e54d55b8847891a1ec3a1f",
            "timestamp" => "2018-08-09T17:16:54.542Z",
            "organization" => "workarea-sandbox",
            "order" => {
              "id" => "ord-7d170417473c43c99d7ea88f938bfebb",
              "number" => "ord-7d170417473c43c99d7ea88f938bfebb",
              "customer" => customer,
              "delivered_duty" => "paid",
              "destination" => destination,
              "expires_at" => "2018-08-09T18:16:53.063Z",
              "items" => localized_line_items,
              "deliveries" => [
                {
                  "id" => "del-2270eea7d85b4ee386137cf8018a37a2",
                  "items" => delivery_items,
                  "options" => [
                    {
                      "id" => "opt-447ba414cf9448ca995464e88241fb8f",
                      "cost" => {
                        "currency" => "EUR",
                        "amount" => 9.29,
                        "label" => "CA$9.29",
                        "base" => {
                          "amount" => 6.86,
                          "currency" => "USD",
                          "label" => "US$6.86"
                        }
                      },
                      "delivered_duty" => "unpaid",
                      "price" => {
                        "currency" => "EUR",
                        "amount" => 9.29,
                        "label" => "CA$9.29",
                        "base" => {
                          "amount" => 6.86,
                          "currency" => "USD",
                          "label" => "US$6.86"
                        }
                      },
                      "service" => {
                        "id" => "landmark-global",
                        "carrier" => {
                          "id" => "landmark"
                        },
                        "name" => "Global"
                      },
                      "tier" => {
                        "id" => "tie-fc0ec702c4384dc8805ae645ef6156e8",
                        "experience" => { "id" => "europe", "currency" => "EUR" },
                        "integration" => "information",
                        "name" => "Standard Shipping",
                        "services" => [
                          "landmark-global",
                          "dhl-express-worldwide"
                        ],
                        "strategy" => "lowest_cost",
                        "visibility" => "public",
                        "currency" => "EUR",
                        "display" => {
                          "estimate" => {
                            "type" => "calculated",
                            "label" => "2-5 Business Days"
                          }
                        }
                      },
                      "window" => {
                        "from" => "2018-08-13T00:00:00.000Z",
                        "to" => "2018-08-16T00:00:00.000Z",
                        "timezone" => "America/Toronto",
                        "label" => "2-5 Business Days"
                      },
                      "cost_details" => [
                        {
                          "source" => "ratecard",
                          "currency" => "EUR",
                          "amount" => 9.29,
                          "label" => "CA$9.29",
                          "components" => [
                            {
                              "key" => "ratecard_base_cost",
                              "currency" => "EUR",
                              "amount" => 9.29,
                              "label" => "CA$9.29",
                              "base" => {
                                "amount" => 6.86,
                                "currency" => "USD",
                                "label" => "US$6.86"
                              }
                            }
                          ],
                          "base" => {
                            "amount" => 6.86,
                            "currency" => "USD",
                            "label" => "US$6.86"
                          }
                        }
                      ],
                      "rule_outcome" => {
                        "discriminator" => "at_cost"
                      },
                      "weight" => {
                        "gravitational" => {
                          "value" => "2.5",
                          "units" => "pound"
                        },
                        "dimensional" => {
                          "value" => "2.12",
                          "units" => "inch"
                        }
                      }
                    },
                    {
                      "id" => "opt-806563c2f4b448e8a4d36bb037de0a21",
                      "cost" => {
                        "currency" => "EUR",
                        "amount" => 9.29,
                        "label" => "CA$9.29",
                        "base" => {
                          "amount" => 6.86,
                          "currency" => "USD",
                          "label" => "US$6.86"
                        }
                      },
                      "delivered_duty" => "paid",
                      "price" => {
                        "currency" => "EUR",
                        "amount" => 9.29,
                        "label" => "CA$9.29",
                        "base" => {
                          "amount" => 6.86,
                          "currency" => "USD",
                          "label" => "US$6.86"
                        }
                      },
                      "service" => {
                        "id" => "landmark-global",
                        "carrier" => {
                          "id" => "landmark"
                        },
                        "name" => "Global"
                      },
                      "tier" => {
                        "id" => "tie-fc0ec702c4384dc8805ae645ef6156e8",
                        "experience" => { "id" => "europe", "currency" => "EUR" },
                        "integration" => "information",
                        "name" => "Standard Shipping",
                        "services" => [
                          "landmark-global",
                          "dhl-express-worldwide"
                        ],
                        "strategy" => "lowest_cost",
                        "visibility" => "public",
                        "currency" => "EUR",
                        "display" => {
                          "estimate" => {
                            "type" => "calculated",
                            "label" => "2-5 Business Days"
                          }
                        }
                      },
                      "window" => {
                        "from" => "2018-08-13T00:00:00.000Z",
                        "to" => "2018-08-16T00:00:00.000Z",
                        "timezone" => "America/Toronto",
                        "label" => "2-5 Business Days"
                      },
                      "cost_details" => [
                        {
                          "source" => "ratecard",
                          "currency" => "EUR",
                          "amount" => 9.29,
                          "label" => "CA$9.29",
                          "components" => [
                            {
                              "key" => "ratecard_base_cost",
                              "currency" => "EUR",
                              "amount" => 9.29,
                              "label" => "CA$9.29",
                              "base" => {
                                "amount" => 6.86,
                                "currency" => "USD",
                                "label" => "US$6.86"
                              }
                            }
                          ],
                          "base" => {
                            "amount" => 6.86,
                            "currency" => "USD",
                            "label" => "US$6.86"
                          }
                        }
                      ],
                      "rule_outcome" => {
                        "discriminator" => "at_cost"
                      },
                      "weight" => {
                        "gravitational" => {
                          "value" => "2.5",
                          "units" => "pound"
                        },
                        "dimensional" => {
                          "value" => "2.12",
                          "units" => "inch"
                        }
                      }
                    }
                  ],
                  "center" => {
                    "id" => "cen-394b1db3c61a495c964dd1fe60969160",
                    "key" => "center-workarea"
                  },
                  "discriminator" => "physical_delivery"
                }
              ],
              "selections" => [
                "opt-806563c2f4b448e8a4d36bb037de0a21"
              ],
              "prices" => prices,
              "total" => {
                "currency" => "EUR",
                "amount" => 232.31,
                "label" => "CA$232.31",
                "base" => {
                  "amount" => 171.55,
                  "currency" => "USD",
                  "label" => "US$171.55"
                }
              },
              "attributes" => { "number" => "#{order.id}" },
              "merchant_of_record" => "flow",
              "experience" => { "key" => "europe", "discriminator" => "experience_reference" },
              "submitted_at" => "2018-08-09T17:16:54.534Z",
              "lines" => lines,
              "promotions" => {
                "applied" => [],
                "available" => []
              },
              "payments" => [
                {
                  "id" => "opm-009ef64e13b84baa805d07570072895b",
                  "type" => "card",
                  "merchant_of_record" => "flow",
                  "reference" => "aut-kYDowZbpSrUEqggeDWW9D0phXQrpDybj",
                  "description" => "VISA ending with 1111",
                  "total" => {
                    "currency" => "EUR",
                    "amount" => 232.31,
                    "label" => "CA$232.31",
                    "base" => {
                      "amount" => 171.55,
                      "currency" => "USD",
                      "label" => "US$171.55"
                    }
                  },
                  "attributes" => {},
                  "address" => billing_address,
                  "date" => "2018-08-09T17:16:54.061Z"
                }
              ],
              "balance" => {
                "currency" => "EUR",
                "amount" => 0,
                "label" => "CA$0.00",
                "base" => {
                  "amount" => 0,
                  "currency" => "USD",
                  "label" => "US$0.00"
                }
              }
            },
            "discriminator" => "order_upserted_v2"
          }.to_json
        end

        private

          # Fake price conversions
          #
          # @param money [Money] the amount to convert
          # @param rate [Float] conversion rate between currencies
          # @param currency_code [String] currency to convert into
          #
          def convert_price(money, rate: 1.2, currency_code: "EUR")
            return unless money.present?

            fractional = (money.dup * rate).fractional
            remainder = fractional % 500

            Money.from_amount((fractional + 500 - remainder) / 100, currency_code)
          end

          def customer_name
            { "first" => "Worarea", "last" => "Customer" }
          end

          def billing_address
            {
              "name" => customer_name,
              "streets" => ["35 Letitia Ln"],
              "city" => "Media",
              "province" => "Alberta",
              "postal" => "19063",
              "country" => "CAN",
              "company" => "Weblinc"
            }
          end

          def customer
            {
              "name" => customer_name,
              "phone" => "3027507743",
              "email" => "flow-test@weblinc.com",
              "address" => billing_address
            }
          end

          def destination
            {
              "streets" => ["35 Letitia Ln"],
              "city" => "Media",
              "province" => "Alberta",
              "postal" => "19063",
              "country" => "CAN",
              "contact" => {
                "name" => customer_name,
                "company" => "Weblinc",
                "email" => "jyucis-relate-new@weblinc.com",
                "phone" => "3027507743"
              }
            }
          end

          def experience_key
            "europe"
          end

          def experience_name
            "Europe"
          end

          def localized_line_items
            order.items.map do |order_item|
              catalog_product =
                if order_item.product_attributes.present?
                  Mongoid::Factory.from_db(Workarea::Catalog::Product, order_item.product_attributes)
                else
                  Workarea::Catalog::Product.find_by_sku(order_item.sku)
                end

              converted_price = convert_price order_item.total_price
              {
                "number" => order_item.sku,
                "name" => catalog_product.name,
                "quantity" => order_item.quantity,
                "local" => {
                  "experience" => {
                    "id" => "exp-95889ba1ff4b449f8a3c0e0a7a4fb23b",
                    "key" => experience_key,
                    "name" => experience_name
                  },
                  "prices" => [
                    {
                      "currency" => "EUR",
                      "amount" => converted_price.to_f,
                      "label" => "EUR€#{converted_price}",
                      "base" => {
                        "amount" => order_item.total_price.to_f,
                        "currency" => "USD",
                        "label" => "US$#{order_item.total_price.to_f}"
                      },
                      "key" => "localized_item_price"
                    }
                  ],
                  "rates" => [],
                  "spot_rates" => [],
                  "status" => "included"
                }
              }
            end
          end

          def delivery_items
            order.items.map do |order_item|

              converted_price = convert_price order_item.total_price
              {
                "number" => order_item.sku,
                "quantity" => order_item.quantity,
                "price" => {
                  "currency" => "EUR",
                  "amount" => converted_price.to_f,
                  "base" => {
                    "amount" => order_item.total_price.to_f,
                    "currency" => "USD"
                  }
                }
              }
            end
          end

          def lines
            order.items.map do |order_item|

              converted_price = convert_price order_item.total_price
              {
                "item_number" => order_item.sku,
                "quantity" => order_item.quantity,
                "price" => {
                  "currency" => "EUR",
                  "amount" => converted_price.to_f,
                  "label" => "EUR€#{converted_price}",
                  "base" => {
                    "amount" => order_item.total_price.to_f,
                    "currency" => "USD",
                    "label" => "US$#{order_item.total_price.to_f}"
                  }
                },
                "total" => {
                  "currency" => "EUR",
                  "amount" => converted_price.to_f,
                  "label" => "EUR€#{converted_price}",
                  "base" => {
                    "amount" => order_item.total_price.to_f,
                    "currency" => "USD",
                    "label" => "US$#{order_item.total_price.to_f}"
                  }
                }
              }
            end
          end

          # TODO better prices for items
          #
          def prices
            [
              {
                "key" => "subtotal",
                "currency" => "EUR",
                "amount" => 180,
                "label" => "CA$180.00",
                "base" => {
                  "amount" => 132.91,
                  "currency" => "USD",
                  "label" => "US$132.91"
                },
                "components" => [
                  {
                    "key" => "item_price",
                    "currency" => "EUR",
                    "amount" => 165.94,
                    "label" => "CA$165.94",
                    "base" => {
                      "amount" => 122.53,
                      "currency" => "USD",
                      "label" => "US$122.53"
                    },
                    "name" => "Item price"
                  },
                  {
                    "key" => "rounding",
                    "currency" => "EUR",
                    "amount" => 14.06,
                    "label" => "CA$14.06",
                    "base" => {
                      "amount" => 10.38,
                      "currency" => "USD",
                      "label" => "US$10.38"
                    },
                    "name" => "Rounding"
                  }
                ],
                "name" => "Item subtotal"
              },
              {
                "key" => "vat",
                "currency" => "EUR",
                "amount" => 10.62,
                "label" => "CA$10.62",
                "base" => {
                  "amount" => 7.85,
                  "currency" => "USD",
                  "label" => "US$7.85"
                },
                "components" => [
                  {
                    "key" => "vat_item_price",
                    "currency" => "EUR",
                    "amount" => 9,
                    "label" => "CA$9.00",
                    "base" => {
                      "amount" => 6.65,
                      "currency" => "USD",
                      "label" => "US$6.65"
                    },
                    "name" => "GST on item price"
                  },
                  {
                    "key" => "vat_duties_item_price",
                    "currency" => "EUR",
                    "amount" => 1.62,
                    "label" => "CA$1.62",
                    "base" => {
                      "amount" => 1.2,
                      "currency" => "USD",
                      "label" => "US$1.20"
                    },
                    "name" => "GST on duties on item price"
                  }
                ],
                "name" => "GST"
              },
              {
                "key" => "duty",
                "currency" => "EUR",
                "amount" => 32.4,
                "label" => "CA$32.40",
                "base" => {
                  "amount" => 23.93,
                  "currency" => "USD",
                  "label" => "US$23.93"
                },
                "components" => [
                  {
                    "key" => "duties_item_price",
                    "currency" => "EUR",
                    "amount" => 32.4,
                    "label" => "CA$32.40",
                    "base" => {
                      "amount" => 23.93,
                      "currency" => "USD",
                      "label" => "US$23.93"
                    },
                    "name" => "Duties on item price"
                  }
                ],
                "name" => "Duties"
              },
              {
                "key" => "shipping",
                "currency" => "EUR",
                "amount" => 9.29,
                "label" => "CA$9.29",
                "base" => {
                  "amount" => 6.86,
                  "currency" => "USD",
                  "label" => "US$6.86"
                },
                "components" => [
                  {
                    "key" => "shipping",
                    "currency" => "EUR",
                    "amount" => 9.29,
                    "label" => "CA$9.29",
                    "base" => {
                      "amount" => 6.86,
                      "currency" => "USD",
                      "label" => "US$6.86"
                    },
                    "name" => "Shipping"
                  }
                ],
                "name" => "Shipping"
              }
            ]
          end
      end
    end
  end
end
