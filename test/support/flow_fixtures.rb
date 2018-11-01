module Workarea
  module FlowIo
    module FlowFixtures
      def europe_experience
        @europe_experience ||= build_flow_io_experience_summary(
          id: "exp-f9ec9be879a341ddb8a67e9a1f34775b",
          key: "europe",
          name: "Europe",
          country: "GBR",
          currency: "EUR",
          language: "en"
        )
      end

      def canada_experience
        @canada_experience ||= build_flow_io_experience_summary(
          _id: "exp-31b66afd8ac44a71a0669b2ad81a794d",
          key: "canada",
          name: "Canada",
          country: "CA",
          currency: "CAD",
          language: "en"
        )
      end

      def canada_experience_geo
        @canada_experience_geo ||= build_flow_io_experience_geo(
          key: "canada",
          name: "Canada",
          region: { id: "can" },
          country: "CAN",
          currency: "CAD",
          language: "en",
          measurement_system: "metric"
        )
      end

      def europe_experience_geo
        @canada_experience_geo ||= build_flow_io_experience_geo(
          key: "europe",
          name: "Europe",
          region: { id: "europe" },
          country: "GBR",
          currency: "EUR",
          language: "en",
          measurement_system: "metric"
        )
      end

      def create_placed_canadian_flow_order
        order_id = "123ABC"
        product = create_product(variants: [{ sku: '386555310-9', regular: 5.00 }])
        product_2 = create_product(variants: [{ sku: '332477498-5', regular: 5.00 }])

        ['386555310-9', '332477498-5'].each do |sku|
          Pricing::Sku.find(sku).tap do |pricing_sku|
            pricing_sku.flow_io_local_items << build_flow_io_local_item(regular: 6.to_m("CAD"))
          end
        end

        order = create_order(
          id: order_id,
          flow: true,
          experience: canada_experience
         )

        order.add_item(product_id: product.id, sku: '386555310-9', quantity: 1)
        order.add_item(product_id: product_2.id, sku: '332477498-5', quantity: 1)

        Pricing.perform(order)

        flow_order = ::Io::Flow::V0::Models::OrderUpsertedV2.new(canadian_webhook_payload).order

        checkout = Workarea::FlowIo::Checkout.new(flow_order, order)
        checkout.build
        checkout.place_order

        order
      end

      def create_canadian_cart_with_order_discount
        order_id = "E62D6AD5B6"
        product = create_product(variants: [{ sku: '942594751-1', regular: 14.83 }])
        _order_total_discount = create_order_total_discount(order_total: 5.to_m)

        order = create_order(
          id: order_id,
          flow: true,
          experience: canada_experience
         )

        order.add_item(product_id: product.id, sku: '942594751-1', quantity: 1)

        Pricing.perform(order)

        order
      end

      def canadian_discount_webhook_payload(order_id = "E62D6AD5B6")
        @canadian_discount_webhook_payload ||= {
          "event_id": "evt-0bdfe4c64c2d4a84a488e22fec641c78",
          "timestamp": "2018-08-28T17:19:57.823Z",
          "organization": "workarea-sandbox",
          "order": {
            "id": "ord-f1f27775b5054c1ab2068823089c723b",
            "number": "ord-f1f27775b5054c1ab2068823089c723b",
            "customer": {
              "name": {
                "first": "Jeff",
                "last": "Yucis"
              },
              "phone": "3027507743",
              "email": "jyucis-pa-test@weblinc.com",
              "address": {
                "name": {
                  "first": "Jeff",
                  "last": "Yucis"
                },
                "streets": [
                  "35 Letitia Ln"
                ],
                "city": "TORONTO",
                "province": "Ontario",
                "postal": "19063",
                "country": "CAN",
                "company": "Weblinc"
              }
            },
            "delivered_duty": "paid",
            "destination": {
              "streets": [
                "35 Letitia Ln"
              ],
              "city": "TORONTO",
              "province": "Ontario",
              "postal": "19063",
              "country": "CAN",
              "contact": {
                "name": {
                  "first": "Jeff",
                  "last": "Yucis"
                },
                "company": "Weblinc",
                "email": "jyucis-pa-test@weblinc.com",
                "phone": "3027507743"
              }
            },
            "expires_at": "2018-08-28T18:19:56.293Z",
            "items": [
              {
                "number": "942594751-1",
                "name": "Intelligent Bronze Knife",
                "quantity": 1,
                "local": {
                  "experience": {
                    "id": "exp-95889ba1ff4b449f8a3c0e0a7a4fb23b",
                    "key": "canada",
                    "name": "Canada"
                  },
                  "prices": [
                    {
                      "currency": "CAD",
                      "amount": 20,
                      "label": "CA$20.00",
                      "base": {
                        "amount": 14.83,
                        "currency": "USD",
                        "label": "US$14.83"
                      },
                      "key": "localized_item_price"
                    }
                  ],
                  "rates": [],
                  "spot_rates": [],
                  "status": "included",
                  "attributes": {
                    "msrp": "40.0",
                    "Size": "Extra Large",
                    "regular_price": "20.0",
                    "sale_price": "20.0",
                    "product_id": "DD1252B4F3",
                    "Color": "Plum",
                    "fulfillment_method": "physical"
                  },
                  "price_attributes": {
                    "msrp": {
                      "currency": "CAD",
                      "amount": 40,
                      "label": "CA$40.00",
                      "base": {
                        "amount": 29.64,
                        "currency": "USD",
                        "label": "US$29.64"
                      }
                    },
                    "regular_price": {
                      "currency": "CAD",
                      "amount": 20,
                      "label": "CA$20.00",
                      "base": {
                        "amount": 14.83,
                        "currency": "USD",
                        "label": "US$14.83"
                      }
                    },
                    "sale_price": {
                      "currency": "CAD",
                      "amount": 20,
                      "label": "CA$20.00",
                      "base": {
                        "amount": 14.81,
                        "currency": "USD",
                        "label": "US$14.81"
                      }
                    }
                  }
                }
              }
            ],
            "deliveries": [
              {
                "id": "del-62a1cf214bc048deb1c4e3752d8dbf33",
                "items": [
                  {
                    "number": "942594751-1",
                    "quantity": 1,
                    "price": {
                      "currency": "CAD",
                      "amount": 20,
                      "base": {
                        "amount": 14.83,
                        "currency": "USD"
                      }
                    },
                    "attributes": {
                      "base_amount": "14.83",
                      "base_currency": "USD"
                    }
                  }
                ],
                "options": [
                  {
                    "id": "opt-618a7e56beb54471ab78d58ef04f032b",
                    "cost": {
                      "currency": "CAD",
                      "amount": 9.26,
                      "label": "CA$9.26",
                      "base": {
                        "amount": 6.86,
                        "currency": "USD",
                        "label": "US$6.86"
                      }
                    },
                    "delivered_duty": "unpaid",
                    "price": {
                      "currency": "CAD",
                      "amount": 9.26,
                      "label": "CA$9.26",
                      "base": {
                        "amount": 6.86,
                        "currency": "USD",
                        "label": "US$6.86"
                      }
                    },
                    "service": {
                      "id": "landmark-global",
                      "carrier": {
                        "id": "landmark"
                      },
                      "name": "Global"
                    },
                    "tier": {
                      "id": "tie-fc0ec702c4384dc8805ae645ef6156e8",
                      "integration": "information",
                      "name": "Standard Shipping",
                      "services": [
                        "landmark-global",
                        "dhl-express-worldwide"
                      ],
                      "strategy": "lowest_cost",
                      "visibility": "public",
                      "currency": "CAD",
                      "display": {
                        "estimate": {
                          "type": "calculated",
                          "label": "2-5 Business Days"
                        }
                      }
                    },
                    "window": {
                      "from": "2018-08-30T00:00:00.000Z",
                      "to": "2018-09-04T00:00:00.000Z",
                      "timezone": "America/Toronto",
                      "label": "2-5 Business Days"
                    },
                    "cost_details": [
                      {
                        "source": "ratecard",
                        "currency": "CAD",
                        "amount": 9.26,
                        "label": "CA$9.26",
                        "components": [
                          {
                            "key": "ratecard_base_cost",
                            "currency": "CAD",
                            "amount": 9.26,
                            "label": "CA$9.26",
                            "base": {
                              "amount": 6.86,
                              "currency": "USD",
                              "label": "US$6.86"
                            }
                          }
                        ],
                        "base": {
                          "amount": 6.86,
                          "currency": "USD",
                          "label": "US$6.86"
                        }
                      }
                    ],
                    "rule_outcome": {
                      "discriminator": "at_cost"
                    },
                    "weight": {
                      "gravitational": {
                        "value": "1.25",
                        "units": "pound"
                      },
                      "dimensional": {
                        "value": "2.12",
                        "units": "inch"
                      }
                    }
                  },
                  {
                    "id": "opt-c0f9091fe6984227be3f00775f1811ba",
                    "cost": {
                      "currency": "CAD",
                      "amount": 9.26,
                      "label": "CA$9.26",
                      "base": {
                        "amount": 6.86,
                        "currency": "USD",
                        "label": "US$6.86"
                      }
                    },
                    "delivered_duty": "paid",
                    "price": {
                      "currency": "CAD",
                      "amount": 9.26,
                      "label": "CA$9.26",
                      "base": {
                        "amount": 6.86,
                        "currency": "USD",
                        "label": "US$6.86"
                      }
                    },
                    "service": {
                      "id": "landmark-global",
                      "carrier": {
                        "id": "landmark"
                      },
                      "name": "Global"
                    },
                    "tier": {
                      "id": "tie-fc0ec702c4384dc8805ae645ef6156e8",
                      "integration": "information",
                      "name": "Standard Shipping",
                      "services": [
                        "landmark-global",
                        "dhl-express-worldwide"
                      ],
                      "strategy": "lowest_cost",
                      "visibility": "public",
                      "currency": "CAD",
                      "display": {
                        "estimate": {
                          "type": "calculated",
                          "label": "2-5 Business Days"
                        }
                      }
                    },
                    "window": {
                      "from": "2018-08-30T00:00:00.000Z",
                      "to": "2018-09-04T00:00:00.000Z",
                      "timezone": "America/Toronto",
                      "label": "2-5 Business Days"
                    },
                    "cost_details": [
                      {
                        "source": "ratecard",
                        "currency": "CAD",
                        "amount": 9.26,
                        "label": "CA$9.26",
                        "components": [
                          {
                            "key": "ratecard_base_cost",
                            "currency": "CAD",
                            "amount": 9.26,
                            "label": "CA$9.26",
                            "base": {
                              "amount": 6.86,
                              "currency": "USD",
                              "label": "US$6.86"
                            }
                          }
                        ],
                        "base": {
                          "amount": 6.86,
                          "currency": "USD",
                          "label": "US$6.86"
                        }
                      }
                    ],
                    "rule_outcome": {
                      "discriminator": "at_cost"
                    },
                    "weight": {
                      "gravitational": {
                        "value": "1.25",
                        "units": "pound"
                      },
                      "dimensional": {
                        "value": "2.12",
                        "units": "inch"
                      }
                    }
                  }
                ],
                "center": {
                  "id": "cen-394b1db3c61a495c964dd1fe60969160",
                  "key": "center-workarea"
                },
                "discriminator": "physical_delivery"
              }
            ],
            "selections": [
              "opt-c0f9091fe6984227be3f00775f1811ba"
            ],
            "prices": [
              {
                "key": "subtotal",
                "currency": "CAD",
                "amount": 20,
                "label": "CA$20.00",
                "base": {
                  "amount": 14.83,
                  "currency": "USD",
                  "label": "US$14.83"
                },
                "components": [
                  {
                    "key": "item_price",
                    "currency": "CAD",
                    "amount": 18.02,
                    "label": "CA$18.02",
                    "base": {
                      "amount": 13.36,
                      "currency": "USD",
                      "label": "US$13.36"
                    },
                    "name": "Item price"
                  },
                  {
                    "key": "rounding",
                    "currency": "CAD",
                    "amount": 1.98,
                    "label": "CA$1.98",
                    "base": {
                      "amount": 1.47,
                      "currency": "USD",
                      "label": "US$1.47"
                    },
                    "name": "Rounding"
                  }
                ],
                "name": "Item subtotal"
              },
              {
                "key": "vat",
                "currency": "CAD",
                "amount": 3.07,
                "label": "CA$3.07",
                "base": {
                  "amount": 2.27,
                  "currency": "USD",
                  "label": "US$2.27"
                },
                "components": [
                  {
                    "key": "vat_item_price",
                    "currency": "CAD",
                    "amount": 2.6,
                    "label": "CA$2.60",
                    "base": {
                      "amount": 1.92,
                      "currency": "USD",
                      "label": "US$1.92"
                    },
                    "name": "HST on item price"
                  },
                  {
                    "key": "vat_duties_item_price",
                    "currency": "CAD",
                    "amount": 0.47,
                    "label": "CA$0.47",
                    "base": {
                      "amount": 0.35,
                      "currency": "USD",
                      "label": "US$0.35"
                    },
                    "name": "HST on duties on item price"
                  }
                ],
                "name": "HST"
              },
              {
                "key": "duty",
                "currency": "CAD",
                "amount": 3.6,
                "label": "CA$3.60",
                "base": {
                  "amount": 2.67,
                  "currency": "USD",
                  "label": "US$2.67"
                },
                "components": [
                  {
                    "key": "duties_item_price",
                    "currency": "CAD",
                    "amount": 3.6,
                    "label": "CA$3.60",
                    "base": {
                      "amount": 2.67,
                      "currency": "USD",
                      "label": "US$2.67"
                    },
                    "name": "Duties on item price"
                  }
                ],
                "name": "Duties"
              },
              {
                "key": "shipping",
                "currency": "CAD",
                "amount": 9.26,
                "label": "CA$9.26",
                "base": {
                  "amount": 6.86,
                  "currency": "USD",
                  "label": "US$6.86"
                },
                "components": [
                  {
                    "key": "shipping",
                    "currency": "CAD",
                    "amount": 9.26,
                    "label": "CA$9.26",
                    "base": {
                      "amount": 6.86,
                      "currency": "USD",
                      "label": "US$6.86"
                    },
                    "name": "Shipping"
                  }
                ],
                "name": "Shipping"
              },
              {
                "key": "discount",
                "currency": "CAD",
                "amount": -1.8,
                "label": "-CA$1.80",
                "base": {
                  "amount": -1.27,
                  "currency": "USD",
                  "label": "-US$1.27"
                },
                "components": [
                  {
                    "key": "order_discount",
                    "currency": "CAD",
                    "amount": -1.8,
                    "label": "-CA$1.80",
                    "base": {
                      "amount": -1.27,
                      "currency": "USD",
                      "label": "-US$1.27"
                    },
                    "name": "Order discount"
                  }
                ],
                "name": "Discount"
              }
            ],
            "total": {
              "currency": "CAD",
              "amount": 34.13,
              "label": "CA$34.13",
              "base": {
                "amount": 25.36,
                "currency": "USD",
                "label": "US$25.36"
              }
            },
            "attributes": {
              "number": "#{order_id}"
            },
            "merchant_of_record": "flow",
            "experience": {
              "key": "canada",
              "discriminator": "experience_reference"
            },
            "submitted_at": "2018-08-28T17:19:57.782Z",
            "lines": [
              {
                "item_number": "942594751-1",
                "quantity": 1,
                "price": {
                  "currency": "CAD",
                  "amount": 20,
                  "label": "CA$20.00",
                  "base": {
                    "amount": 14.83,
                    "currency": "USD",
                    "label": "US$14.83"
                  }
                },
                "total": {
                  "currency": "CAD",
                  "amount": 20,
                  "label": "CA$20.00",
                  "base": {
                    "amount": 14.83,
                    "currency": "USD",
                    "label": "US$14.83"
                  }
                }
              }
            ],
            "promotions": {
              "applied": [
                {
                  "id": "order_put_form_discount",
                  "label": "Discount",
                  "price": {
                    "currency": "CAD",
                    "amount": -1.8,
                    "label": "-CA$1.80",
                    "base": {
                      "amount": -1.27,
                      "currency": "USD",
                      "label": "-US$1.27"
                    }
                  },
                  "attributes": {
                    "discount_type": "order_put_form_discount"
                  },
                  "discriminator": "discount"
                }
              ],
              "available": []
            },
            "payments": [
              {
                "id": "opm-3dd423128d804a5b90c2986bd8be11ab",
                "type": "card",
                "merchant_of_record": "flow",
                "reference": "aut-k7YUhioHWekBGpAi9VA7cD4fqs2xoH4Z",
                "description": "VISA ending with 1111",
                "total": {
                  "currency": "CAD",
                  "amount": 34.13,
                  "label": "CA$34.13",
                  "base": {
                    "amount": 25.36,
                    "currency": "USD",
                    "label": "US$25.36"
                  }
                },
                "attributes": {},
                "address": {
                  "name": {
                    "first": "Jeff",
                    "last": "Yucis"
                  },
                  "streets": [
                    "35 Letitia Ln"
                  ],
                  "city": "TORONTO",
                  "province": "Ontario",
                  "postal": "19063",
                  "country": "CAN"
                },
                "date": "2018-08-28T17:19:57.167Z"
              }
            ],
            "balance": {
              "currency": "CAD",
              "amount": 0,
              "label": "CA$0.00",
              "base": {
                "amount": 0,
                "currency": "USD",
                "label": "US$0.00"
              }
            }
          },
          "discriminator": "order_upserted_v2"
        }
      end

      def canadian_webhook_payload(order_id = "6F3A2186EB")
        @canadian_webhook_payload ||= {
          "event_id": "evt-37ba2577b4e54d55b8847891a1ec3a1f",
          "timestamp": "2018-08-09T17:16:54.542Z",
          "organization": "workarea-sandbox",
          "order": {
            "id": "ord-7d170417473c43c99d7ea88f938bfebb",
            "number": "ord-7d170417473c43c99d7ea88f938bfebb",
            "customer": {
              "name": {
                "first": "Jeff",
                "last": "Yucis"
              },
              "phone": "3027507743",
              "email": "flow-test@weblinc.com",
              "address": {
                "name": {
                  "first": "Jeff",
                  "last": "Yucis"
                },
                "streets": [
                  "35 Letitia Ln"
                ],
                "city": "Media",
                "province": "Alberta",
                "postal": "19063",
                "country": "CAN",
                "company": "Weblinc"
              }
            },
            "delivered_duty": "paid",
            "destination": {
              "streets": [
                "35 Letitia Ln"
              ],
              "city": "Media",
              "province": "Alberta",
              "postal": "19063",
              "country": "CAN",
              "contact": {
                "name": {
                  "first": "Jeff",
                  "last": "Yucis"
                },
                "company": "Weblinc",
                "email": "jyucis-relate-new@weblinc.com",
                "phone": "3027507743"
              }
            },
            "expires_at": "2018-08-09T18:16:53.063Z",
            "items": [
              {
                "number": "386555310-9",
                "name": "Incredible Cotton Bag",
                "quantity": 1,
                "local": {
                  "experience": {
                    "id": "exp-95889ba1ff4b449f8a3c0e0a7a4fb23b",
                    "key": "canada",
                    "name": "Canada"
                  },
                  "prices": [
                    {
                      "currency": "CAD",
                      "amount": 80,
                      "label": "CA$80.00",
                      "base": {
                        "amount": 59.07,
                        "currency": "USD",
                        "label": "US$59.07"
                      },
                      "key": "localized_item_price"
                    }
                  ],
                  "rates": [],
                  "spot_rates": [],
                  "status": "included",
                  "attributes": {
                    "msrp": "59.74",
                    "Size": "Extra Large",
                    "regular_price": "49.74",
                    "sale_price": "70.0",
                    "product_id": "890726C80A",
                    "Color": "Orange",
                    "fulfillment_method": "physical"
                  },
                  "price_attributes": {
                    "sale_price": {
                      "currency": "CAD",
                      "amount": 70,
                      "label": "CA$70.00",
                      "base": {
                        "amount": 51.69,
                        "currency": "USD",
                        "label": "US$51.69"
                      }
                    }
                  }
                }
              },
              {
                "number": "332477498-5",
                "name": "Gorgeous Bronze Plate",
                "quantity": 1,
                "local": {
                  "experience": {
                    "id": "exp-95889ba1ff4b449f8a3c0e0a7a4fb23b",
                    "key": "canada",
                    "name": "Canada"
                  },
                  "prices": [
                    {
                      "currency": "CAD",
                      "amount": 100,
                      "label": "CA$100.00",
                      "base": {
                        "amount": 73.84,
                        "currency": "USD",
                        "label": "US$73.84"
                      },
                      "key": "localized_item_price"
                    }
                  ],
                  "rates": [],
                  "spot_rates": [],
                  "status": "included",
                  "attributes": {
                    "msrp": "76.96",
                    "Size": "Extra Small",
                    "regular_price": "66.96",
                    "sale_price": "90.0",
                    "product_id": "82F12BBA56",
                    "Color": "Teal",
                    "fulfillment_method": "physical"
                  },
                  "price_attributes": {
                    "sale_price": {
                      "currency": "CAD",
                      "amount": 90,
                      "label": "CA$90.00",
                      "base": {
                        "amount": 66.46,
                        "currency": "USD",
                        "label": "US$66.46"
                      }
                    }
                  }
                }
              }
            ],
            "deliveries": [
              {
                "id": "del-2270eea7d85b4ee386137cf8018a37a2",
                "items": [
                  {
                    "number": "633652208-3",
                    "quantity": 1,
                    "price": {
                      "currency": "CAD",
                      "amount": 80,
                      "base": {
                        "amount": 59.07,
                        "currency": "USD"
                      }
                    },
                    "attributes": {
                      "base_amount": "59.07",
                      "base_currency": "USD"
                    }
                  },
                  {
                    "number": "573446691-3",
                    "quantity": 1,
                    "price": {
                      "currency": "CAD",
                      "amount": 100,
                      "base": {
                        "amount": 73.84,
                        "currency": "USD"
                      }
                    },
                    "attributes": {
                      "base_amount": "73.84",
                      "base_currency": "USD"
                    }
                  }
                ],
                "options": [
                  {
                    "id": "opt-447ba414cf9448ca995464e88241fb8f",
                    "cost": {
                      "currency": "CAD",
                      "amount": 9.29,
                      "label": "CA$9.29",
                      "base": {
                        "amount": 6.86,
                        "currency": "USD",
                        "label": "US$6.86"
                      }
                    },
                    "delivered_duty": "unpaid",
                    "price": {
                      "currency": "CAD",
                      "amount": 9.29,
                      "label": "CA$9.29",
                      "base": {
                        "amount": 6.86,
                        "currency": "USD",
                        "label": "US$6.86"
                      }
                    },
                    "service": {
                      "id": "landmark-global",
                      "carrier": {
                        "id": "landmark"
                      },
                      "name": "Global"
                    },
                    "tier": {
                      "id": "tie-fc0ec702c4384dc8805ae645ef6156e8",
                      "experience": {
                        "id": "canada",
                        "currency": "CAD"
                      },
                      "integration": "information",
                      "name": "Standard Shipping",
                      "services": [
                        "landmark-global",
                        "dhl-express-worldwide"
                      ],
                      "strategy": "lowest_cost",
                      "visibility": "public",
                      "currency": "CAD",
                      "display": {
                        "estimate": {
                          "type": "calculated",
                          "label": "2-5 Business Days"
                        }
                      }
                    },
                    "window": {
                      "from": "2018-08-13T00:00:00.000Z",
                      "to": "2018-08-16T00:00:00.000Z",
                      "timezone": "America/Toronto",
                      "label": "2-5 Business Days"
                    },
                    "cost_details": [
                      {
                        "source": "ratecard",
                        "currency": "CAD",
                        "amount": 9.29,
                        "label": "CA$9.29",
                        "components": [
                          {
                            "key": "ratecard_base_cost",
                            "currency": "CAD",
                            "amount": 9.29,
                            "label": "CA$9.29",
                            "base": {
                              "amount": 6.86,
                              "currency": "USD",
                              "label": "US$6.86"
                            }
                          }
                        ],
                        "base": {
                          "amount": 6.86,
                          "currency": "USD",
                          "label": "US$6.86"
                        }
                      }
                    ],
                    "rule_outcome": {
                      "discriminator": "at_cost"
                    },
                    "weight": {
                      "gravitational": {
                        "value": "2.5",
                        "units": "pound"
                      },
                      "dimensional": {
                        "value": "2.12",
                        "units": "inch"
                      }
                    }
                  },
                  {
                    "id": "opt-806563c2f4b448e8a4d36bb037de0a21",
                    "cost": {
                      "currency": "CAD",
                      "amount": 9.29,
                      "label": "CA$9.29",
                      "base": {
                        "amount": 6.86,
                        "currency": "USD",
                        "label": "US$6.86"
                      }
                    },
                    "delivered_duty": "paid",
                    "price": {
                      "currency": "CAD",
                      "amount": 9.29,
                      "label": "CA$9.29",
                      "base": {
                        "amount": 6.86,
                        "currency": "USD",
                        "label": "US$6.86"
                      }
                    },
                    "service": {
                      "id": "landmark-global",
                      "carrier": {
                        "id": "landmark"
                      },
                      "name": "Global"
                    },
                    "tier": {
                      "id": "tie-fc0ec702c4384dc8805ae645ef6156e8",
                      "experience": {
                        "id": "canada",
                        "currency": "CAD"
                      },
                      "integration": "information",
                      "name": "Standard Shipping",
                      "services": [
                        "landmark-global",
                        "dhl-express-worldwide"
                      ],
                      "strategy": "lowest_cost",
                      "visibility": "public",
                      "currency": "CAD",
                      "display": {
                        "estimate": {
                          "type": "calculated",
                          "label": "2-5 Business Days"
                        }
                      }
                    },
                    "window": {
                      "from": "2018-08-13T00:00:00.000Z",
                      "to": "2018-08-16T00:00:00.000Z",
                      "timezone": "America/Toronto",
                      "label": "2-5 Business Days"
                    },
                    "cost_details": [
                      {
                        "source": "ratecard",
                        "currency": "CAD",
                        "amount": 9.29,
                        "label": "CA$9.29",
                        "components": [
                          {
                            "key": "ratecard_base_cost",
                            "currency": "CAD",
                            "amount": 9.29,
                            "label": "CA$9.29",
                            "base": {
                              "amount": 6.86,
                              "currency": "USD",
                              "label": "US$6.86"
                            }
                          }
                        ],
                        "base": {
                          "amount": 6.86,
                          "currency": "USD",
                          "label": "US$6.86"
                        }
                      }
                    ],
                    "rule_outcome": {
                      "discriminator": "at_cost"
                    },
                    "weight": {
                      "gravitational": {
                        "value": "2.5",
                        "units": "pound"
                      },
                      "dimensional": {
                        "value": "2.12",
                        "units": "inch"
                      }
                    }
                  }
                ],
                "center": {
                  "id": "cen-394b1db3c61a495c964dd1fe60969160",
                  "key": "center-workarea"
                },
                "discriminator": "physical_delivery"
              }
            ],
            "selections": [
              "opt-806563c2f4b448e8a4d36bb037de0a21"
            ],
            "prices": [
              {
                "key": "subtotal",
                "currency": "CAD",
                "amount": 180,
                "label": "CA$180.00",
                "base": {
                  "amount": 132.91,
                  "currency": "USD",
                  "label": "US$132.91"
                },
                "components": [
                  {
                    "key": "item_price",
                    "currency": "CAD",
                    "amount": 165.94,
                    "label": "CA$165.94",
                    "base": {
                      "amount": 122.53,
                      "currency": "USD",
                      "label": "US$122.53"
                    },
                    "name": "Item price"
                  },
                  {
                    "key": "rounding",
                    "currency": "CAD",
                    "amount": 14.06,
                    "label": "CA$14.06",
                    "base": {
                      "amount": 10.38,
                      "currency": "USD",
                      "label": "US$10.38"
                    },
                    "name": "Rounding"
                  }
                ],
                "name": "Item subtotal"
              },
              {
                "key": "vat",
                "currency": "CAD",
                "amount": 10.62,
                "label": "CA$10.62",
                "base": {
                  "amount": 7.85,
                  "currency": "USD",
                  "label": "US$7.85"
                },
                "components": [
                  {
                    "key": "vat_item_price",
                    "currency": "CAD",
                    "amount": 9,
                    "label": "CA$9.00",
                    "base": {
                      "amount": 6.65,
                      "currency": "USD",
                      "label": "US$6.65"
                    },
                    "name": "GST on item price"
                  },
                  {
                    "key": "vat_duties_item_price",
                    "currency": "CAD",
                    "amount": 1.62,
                    "label": "CA$1.62",
                    "base": {
                      "amount": 1.2,
                      "currency": "USD",
                      "label": "US$1.20"
                    },
                    "name": "GST on duties on item price"
                  }
                ],
                "name": "GST"
              },
              {
                "key": "duty",
                "currency": "CAD",
                "amount": 32.4,
                "label": "CA$32.40",
                "base": {
                  "amount": 23.93,
                  "currency": "USD",
                  "label": "US$23.93"
                },
                "components": [
                  {
                    "key": "duties_item_price",
                    "currency": "CAD",
                    "amount": 32.4,
                    "label": "CA$32.40",
                    "base": {
                      "amount": 23.93,
                      "currency": "USD",
                      "label": "US$23.93"
                    },
                    "name": "Duties on item price"
                  }
                ],
                "name": "Duties"
              },
              {
                "key": "shipping",
                "currency": "CAD",
                "amount": 9.29,
                "label": "CA$9.29",
                "base": {
                  "amount": 6.86,
                  "currency": "USD",
                  "label": "US$6.86"
                },
                "components": [
                  {
                    "key": "shipping",
                    "currency": "CAD",
                    "amount": 9.29,
                    "label": "CA$9.29",
                    "base": {
                      "amount": 6.86,
                      "currency": "USD",
                      "label": "US$6.86"
                    },
                    "name": "Shipping"
                  }
                ],
                "name": "Shipping"
              }
            ],
            "total": {
              "currency": "CAD",
              "amount": 232.31,
              "label": "CA$232.31",
              "base": {
                "amount": 171.55,
                "currency": "USD",
                "label": "US$171.55"
              }
            },
            "attributes": {
              "number": "#{order_id}"
            },
            "merchant_of_record": "flow",
            "experience": {
              "key": "canada",
              "discriminator": "experience_reference"
            },
            "submitted_at": "2018-08-09T17:16:54.534Z",
            "lines": [
              {
                "item_number": "633652208-3",
                "quantity": 1,
                "price": {
                  "currency": "CAD",
                  "amount": 80,
                  "label": "CA$80.00",
                  "base": {
                    "amount": 59.07,
                    "currency": "USD",
                    "label": "US$59.07"
                  }
                },
                "total": {
                  "currency": "CAD",
                  "amount": 80,
                  "label": "CA$80.00",
                  "base": {
                    "amount": 59.07,
                    "currency": "USD",
                    "label": "US$59.07"
                  }
                }
              },
              {
                "item_number": "573446691-3",
                "quantity": 1,
                "price": {
                  "currency": "CAD",
                  "amount": 100,
                  "label": "CA$100.00",
                  "base": {
                    "amount": 73.84,
                    "currency": "USD",
                    "label": "US$73.84"
                  }
                },
                "total": {
                  "currency": "CAD",
                  "amount": 100,
                  "label": "CA$100.00",
                  "base": {
                    "amount": 73.84,
                    "currency": "USD",
                    "label": "US$73.84"
                  }
                }
              }
            ],
            "promotions": {
              "applied": [],
              "available": []
            },
            "payments": [
              {
                "id": "opm-009ef64e13b84baa805d07570072895b",
                "type": "card",
                "merchant_of_record": "flow",
                "reference": "aut-kYDowZbpSrUEqggeDWW9D0phXQrpDybj",
                "description": "VISA ending with 1111",
                "total": {
                  "currency": "CAD",
                  "amount": 232.31,
                  "label": "CA$232.31",
                  "base": {
                    "amount": 171.55,
                    "currency": "USD",
                    "label": "US$171.55"
                  }
                },
                "attributes": {},
                "address": {
                  "name": {
                    "first": "Jeff",
                    "last": "Yucis"
                  },
                  "streets": [
                    "35 Letitia Ln"
                  ],
                  "city": "Media",
                  "province": "Alberta",
                  "postal": "19063",
                  "country": "CAN"
                },
                "date": "2018-08-09T17:16:54.061Z"
              }
            ],
            "balance": {
              "currency": "CAD",
              "amount": 0,
              "label": "CA$0.00",
              "base": {
                "amount": 0,
                "currency": "USD",
                "label": "US$0.00"
              }
            }
          },
          "discriminator": "order_upserted_v2"
        }
      end
    end
  end
end
