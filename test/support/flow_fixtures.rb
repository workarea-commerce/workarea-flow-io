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

      def create_placed_canadian_flow_order
        order_id = "123ABC"
        params = canadian_webhook_payload
        product = create_product

        order = create_order(
          id: order_id,
          flow: true,
          flow_order_id: params[:order][:id],
          imported_from_flow_at: DateTime.now
         )

        order.add_item(product_id: product.id, sku: 'SKU', quantity: 2)

        flow_order = ::Io::Flow::V0::Models::OrderUpsertedV2.new(canadian_webhook_payload).order

        checkout = Workarea::FlowIo::Checkout.new(flow_order, order).build

        checkout.place_order

        order
      end

      def canadian_webhook_payload(order_id = "6F3A2186EB")
        @canadian_webhook_payload = {
            "event_id": "evt-cd51260b774c437296321d8f54cd9ad2",
            "timestamp": "2018-07-18T18:27:43.907Z",
            "organization": "workarea-sandbox",
            "order": {
              "id": "ord-7d170417473c43c99d7ea88f938bfebb",
              "number": "ord-7d170417473c43c99d7ea88f938bfebb",
              "merchant_of_record": "flow",
              "customer": {
                "name": {
                  "first": "Jeff",
                  "last": "Yucis"
                },
                "phone": "5554441234",
                "email": "flow-test@weblinc.com"
              },
              "delivered_duty": "paid",
              "destination": {
                "streets": [
                  "35 canada street"
                ],
                "city": "Toronto",
                "province": "Ontario",
                "postal": "19806",
                "country": "CAN",
                "contact": {
                  "name": {
                    "first": "Jeff",
                    "last": "Yucis"
                  },
                  "email": "flow-test@weblinc.com",
                  "phone": "5554441234"
                }
              },
              "expires_at": "2018-07-18T19:27:41.856Z",
              "items": [
                {
                  "number": "386555310-9",
                  "name": "Synergistic Silk Plate",
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
                        "amount": 5.00,
                        "label": "CA$5.00",
                        "base": {
                          "amount": 5.00,
                          "currency": "USD",
                          "label": "US$50.99"
                        },
                        "key": "localized_item_price"
                      }
                    ],
                    "rates": [],
                    "spot_rates": [],
                    "status": "included",
                    "attributes": {
                      "msrp": "56.82",
                      "Size": "Large",
                      "regular_price": "46.82",
                      "sale_price": "70.0",
                      "product_id": "8C1FAF561F",
                      "Color": "Green",
                      "fulfillment_method": "physical"
                    },
                    "price_attributes": {
                      "sale_price": {
                        "currency": "CAD",
                        "amount": 5,
                        "label": "CA$5.00",
                        "base": {
                          "amount": 50.99,
                          "currency": "USD",
                          "label": "US$50.99"
                        }
                      }
                    }
                  }
                },
                {
                  "number": "332477498-5",
                  "name": "Intelligent Bronze Pants",
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
                        "amount": 5,
                        "label": "CA$5.00",
                        "base": {
                          "amount": 36.42,
                          "currency": "USD",
                          "label": "US$36.42"
                        },
                        "key": "localized_item_price"
                      }
                    ],
                    "rates": [],
                    "spot_rates": [],
                    "status": "included",
                    "attributes": {
                      "msrp": "5.00",
                      "Size": "Small",
                      "regular_price": "5.0",
                      "sale_price": "5.0",
                      "product_id": "0DE6F65806",
                      "Color": "Ivory",
                      "fulfillment_method": "physical"
                    },
                    "price_attributes": {
                      "sale_price": {
                        "currency": "CAD",
                        "amount": 5,
                        "label": "CA$5.00",
                        "base": {
                          "amount": 29.13,
                          "currency": "USD",
                          "label": "US$29.13"
                        }
                      }
                    }
                  }
                }
              ],
              "deliveries": [
                {
                  "id": "del-6373b1ab3f85403fb13d069f42247ba8",
                  "items": [
                    {
                      "number": "386555310-9",
                      "quantity": 1,
                      "price": {
                        "amount": 5,
                        "currency": "CAD"
                      },
                      "attributes": {
                        "base_amount": "50.99",
                        "base_currency": "USD"
                      }
                    },
                    {
                      "number": "332477498-5",
                      "quantity": 1,
                      "price": {
                        "amount": 5,
                        "currency": "CAD"
                      },
                      "attributes": {
                        "base_amount": "36.42",
                        "base_currency": "USD"
                      }
                    }
                  ],
                  "options": [
                    {
                      "id": "opt-af5d4cb4491c48188014d9b6faff42bb",
                      "cost": {
                        "currency": "CAD",
                        "amount": 9.42,
                        "label": "CA$9.42",
                        "base": {
                          "amount": 6.86,
                          "currency": "USD",
                          "label": "US$6.86"
                        }
                      },
                      "delivered_duty": "unpaid",
                      "price": {
                        "currency": "CAD",
                        "amount": 9.42,
                        "label": "CA$9.42",
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
                        "from": "2018-07-20T00:00:00.000Z",
                        "to": "2018-07-25T00:00:00.000Z",
                        "timezone": "America/Toronto",
                        "label": "2-5 Business Days"
                      },
                      "cost_details": [
                        {
                          "source": "ratecard",
                          "currency": "CAD",
                          "amount": 9.42,
                          "label": "CA$9.42",
                          "components": [
                            {
                              "key": "ratecard_base_cost",
                              "currency": "CAD",
                              "amount": 9.42,
                              "label": "CA$9.42",
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
                          "value": "2.50",
                          "units": "pound"
                        },
                        "dimensional": {
                          "value": "2.12",
                          "units": "inch"
                        }
                      }
                    },
                    {
                      "id": "opt-f5cb8850c9914d0a97caa533633d6745",
                      "cost": {
                        "currency": "CAD",
                        "amount": 9.42,
                        "label": "CA$9.42",
                        "base": {
                          "amount": 6.86,
                          "currency": "USD",
                          "label": "US$6.86"
                        }
                      },
                      "delivered_duty": "paid",
                      "price": {
                        "currency": "CAD",
                        "amount": 9.42,
                        "label": "CA$9.42",
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
                        "from": "2018-07-20T00:00:00.000Z",
                        "to": "2018-07-25T00:00:00.000Z",
                        "timezone": "America/Toronto",
                        "label": "2-5 Business Days"
                      },
                      "cost_details": [
                        {
                          "source": "ratecard",
                          "currency": "CAD",
                          "amount": 9.42,
                          "label": "CA$9.42",
                          "components": [
                            {
                              "key": "ratecard_base_cost",
                              "currency": "CAD",
                              "amount": 9.42,
                              "label": "CA$9.42",
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
                          "value": "2.50",
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
                "opt-f5cb8850c9914d0a97caa533633d6745"
              ],
              "prices": [
                {
                  "key": "subtotal",
                  "currency": "CAD",
                  "amount": 120,
                  "label": "CA$120.00",
                  "base": {
                    "amount": 87.41,
                    "currency": "USD",
                    "label": "US$87.41"
                  },
                  "components": [
                    {
                      "key": "item_price",
                      "currency": "CAD",
                      "amount": 109.43,
                      "label": "CA$109.43",
                      "base": {
                        "amount": 79.71,
                        "currency": "USD",
                        "label": "US$79.71"
                      },
                      "name": "Item price"
                    },
                    {
                      "key": "rounding",
                      "currency": "CAD",
                      "amount": 10.57,
                      "label": "CA$10.57",
                      "base": {
                        "amount": 7.7,
                        "currency": "USD",
                        "label": "US$7.70"
                      },
                      "name": "Rounding"
                    }
                  ],
                  "name": "Item subtotal"
                },
                {
                  "key": "vat",
                  "currency": "CAD",
                  "amount": 21.25,
                  "label": "CA$21.25",
                  "base": {
                    "amount": 15.49,
                    "currency": "USD",
                    "label": "US$15.49"
                  },
                  "components": [
                    {
                      "key": "vat_item_price",
                      "currency": "CAD",
                      "amount": 18,
                      "label": "CA$18.00",
                      "base": {
                        "amount": 13.11,
                        "currency": "USD",
                        "label": "US$13.11"
                      },
                      "name": "HST on item price"
                    },
                    {
                      "key": "vat_duties_item_price",
                      "currency": "CAD",
                      "amount": 3.25,
                      "label": "CA$3.25",
                      "base": {
                        "amount": 2.38,
                        "currency": "USD",
                        "label": "US$2.38"
                      },
                      "name": "HST on duties on item price"
                    }
                  ],
                  "name": "HST"
                },
                {
                  "key": "duty",
                  "currency": "CAD",
                  "amount": 21.6,
                  "label": "CA$21.60",
                  "base": {
                    "amount": 15.74,
                    "currency": "USD",
                    "label": "US$15.74"
                  },
                  "components": [
                    {
                      "key": "duties_item_price",
                      "currency": "CAD",
                      "amount": 21.6,
                      "label": "CA$21.60",
                      "base": {
                        "amount": 15.74,
                        "currency": "USD",
                        "label": "US$15.74"
                      },
                      "name": "Duties on item price"
                    }
                  ],
                  "name": "Duties"
                },
                {
                  "key": "shipping",
                  "currency": "CAD",
                  "amount": 9.42,
                  "label": "CA$9.42",
                  "base": {
                    "amount": 6.86,
                    "currency": "USD",
                    "label": "US$6.86"
                  },
                  "components": [
                    {
                      "key": "shipping",
                      "currency": "CAD",
                      "amount": 9.42,
                      "label": "CA$9.42",
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
                "amount": 172.27,
                "label": "CA$172.27",
                "base": {
                  "amount": 125.5,
                  "currency": "USD",
                  "label": "US$125.50"
                }
              },
              "attributes": {
                "number": "#{order_id}"
              },
              "experience": {
                "key": "canada",
                "discriminator": "experience_reference"
              },
              "submitted_at": "2018-07-18T18:27:43.798Z",
              "lines": [
                {
                  "item_number": "386555310-9",
                  "quantity": 1,
                  "price": {
                    "currency": "CAD",
                    "amount": 70,
                    "label": "CA$70.00",
                    "base": {
                      "amount": 50.99,
                      "currency": "USD",
                      "label": "US$50.99"
                    }
                  },
                  "total": {
                    "currency": "CAD",
                    "amount": 70,
                    "label": "CA$70.00",
                    "base": {
                      "amount": 50.99,
                      "currency": "USD",
                      "label": "US$50.99"
                    }
                  }
                },
                {
                  "item_number": "332477498-5",
                  "quantity": 1,
                  "price": {
                    "currency": "CAD",
                    "amount": 50,
                    "label": "CA$50.00",
                    "base": {
                      "amount": 36.42,
                      "currency": "USD",
                      "label": "US$36.42"
                    }
                  },
                  "total": {
                    "currency": "CAD",
                    "amount": 50,
                    "label": "CA$50.00",
                    "base": {
                      "amount": 36.42,
                      "currency": "USD",
                      "label": "US$36.42"
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
                  "id": "opm-76a584ed971b45ff9a4b3f452ff14c6c",
                  "type": "card",
                  "merchant_of_record": "flow",
                  "reference": "aut-y2d224WvoFFcVGvq6zvkBgVqmJ7h4ke6",
                  "description": "VISA ending with 1111",
                  "total": {
                    "currency": "CAD",
                    "amount": 19.42,
                    "label": "CA$172.27",
                    "base": {
                      "amount": 125.5,
                      "currency": "USD",
                      "label": "US$125.50"
                    }
                  },
                  "address": {
                    "streets": [
                      "35 canada street"
                    ],
                    "city": "Toronto",
                    "province": "Ontario",
                    "postal": "19806",
                    "country": "CAN"
                  },
                  "date": "2018-07-18T18:27:43.278Z"
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
