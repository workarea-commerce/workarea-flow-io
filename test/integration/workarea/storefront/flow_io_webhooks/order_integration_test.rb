require 'test_helper'

module Workarea
  module Storefront
    module FlowIoWebHooks
      class OrderIntegrationTest < Workarea::IntegrationTest
        include Workarea::FlowIo::WebhookIntegrationTest
        include Workarea::FlowIo::FlowFixtures

        def test_order_update
          product = create_product(variants: [{ sku: '386555310-9', regular: 5.00 }])
          product_2 = create_product(variants: [{ sku: '332477498-5', regular: 5.00 }])

          _shipping_service = create_shipping_service

          order = create_order(id: '6F3A2186EB', experience: canada_experience)

          order.add_item(product_id: product.id, sku: '386555310-9', quantity: 1)
          order.add_item(product_id: product_2.id, sku: '332477498-5', quantity: 1)

          post_signed storefront.flow_io_webhook_path, params: order_upserted
          shipping = Workarea::Shipping.find_or_create_by(order_id: order.id)

          assert(response.ok?)
          assert_equal({ "status" => 200 }, JSON.parse(response.body))
          assert_equal(200, response.status)

          order.reload
          assert_equal("flow-test@weblinc.com", order.email)
          assert_equal(171.55.to_m, order.total_price)

          assert_equal(Money.from_amount(180.00, "CAD"), order.flow_total_value)
          assert_equal(Money.from_amount(232.31, "CAD"), order.flow_total_price)
          assert_equal(Money.from_amount(9.29, "CAD"), order.flow_shipping_total)
          assert_equal(Money.from_amount(43.02, "CAD"), order.flow_tax_total)

          assert(order.placed?)

          payment = Payment.find(order.id)

          assert(payment.address.valid?)
          assert_equal(1, payment.tenders.size)
          assert_equal(1, payment.tenders.first.transactions.size)

          tender = payment.tenders.first
          assert_equal(171.55.to_m, tender.amount)

          shipping.reload
          assert(shipping.address.valid?)

          assert_equal(3, shipping.price_adjustments.size)
          assert_equal(3, shipping.flow_price_adjustments.size)
          assert_equal(6.86.to_m, shipping.shipping_total)
          assert_equal("paid", shipping.delivery_duty)
        end

        def test_order_update_no_billing_address
          product = create_product(variants: [{ sku: '386555310-9', regular: 5.00 }])
          product_2 = create_product(variants: [{ sku: '332477498-5', regular: 5.00 }])

          _shipping_service = create_shipping_service

          order = create_order(id: '6F3A2186EB', experience: canada_experience)

          order.add_item(product_id: product.id, sku: '386555310-9', quantity: 1)
          order.add_item(product_id: product_2.id, sku: '332477498-5', quantity: 1)

          shipping = Workarea::Shipping.find_or_create_by(order_id: order.id)

          Workarea::Pricing.perform(order, shipping)

          params = canadian_webhook_payload
          params[:order][:payments].first.delete(:address)

          post storefront.flow_io_webhook_path, params: params.to_json, headers: headers

          order.reload
          payment = Payment.find(order.id)

          assert(payment.address.valid?)
        end

        def test_order_not_found
          post_signed storefront.flow_io_webhook_path, params: invalid_order_params
          refute(response.ok?)

          message = JSON.parse(response.body)
          assert_equal(
            "Document(s) not found for class Workarea::Order with id(s) 95F11ED6B6.",
            message["problem"]
          )
        end

        private

        def invalid_order_params
          {
            "event_id": "evt-1fd430fd2d8e4add80073232261ddf40",
            "timestamp": "2018-08-21T14:09:22.386Z",
            "organization": "workarea-sandbox",
            "order": {
              "id": "ord-aa4c6f6d45e84bca9e3e35496306407e",
              "number": "ord-aa4c6f6d45e84bca9e3e35496306407e",
              "customer": {
                "name": {
                  "first": "Eric",
                  "last": "Pigeon"
                },
                "phone": "4847447524",
                "email": "epigeon@weblinc.com",
                "address": {
                  "name": {
                    "first": "Eric",
                    "last": "Pigeon"
                  },
                  "streets": [
                    "22 S 2rd st"
                  ],
                  "city": "Philadelphia",
                  "postal": "19104",
                  "country": "BEL"
                }
              },
              "delivered_duty": "paid",
              "destination": {
                "streets": [
                  "22 S 2rd st"
                ],
                "city": "Philadelphia",
                "postal": "19104",
                "country": "BEL",
                "contact": {
                  "name": {
                    "first": "Eric",
                    "last": "Pigeon"
                  },
                  "email": "epigeon@weblinc.com",
                  "phone": "4847447524"
                }
              },
              "expires_at": "2018-08-21T15:09:20.858Z",
              "items": [
                {
                  "number": "103832230-8",
                  "name": "Incredible Steel Clock",
                  "quantity": 2,
                  "local": {
                    "experience": {
                      "id": "exp-72464b1f651d49fe8108dcabf4678942",
                      "key": "europe",
                      "name": "Europe"
                    },
                    "prices": [
                      {
                        "currency": "EUR",
                        "amount": 98.95,
                        "label": "98,95 €",
                        "base": {
                          "amount": 109.3,
                          "currency": "USD",
                          "label": "US$109.30"
                        },
                        "includes": {
                          "key": "vat",
                          "label": "Includes VAT"
                        },
                        "key": "localized_item_price"
                      }
                    ],
                    "rates": [],
                    "spot_rates": [],
                    "status": "included",
                    "attributes": {
                      "msrp": "109.95",
                      "regular_price": "98.95",
                      "Material": "Concrete",
                      "sale_price": "97.95",
                      "product_id": "C18998E465",
                      "Color": "orange",
                      "fulfillment_method": "physical"
                    },
                    "price_attributes": {
                      "msrp": {
                        "currency": "EUR",
                        "amount": 109.95,
                        "label": "109,95 €",
                        "base": {
                          "amount": 121.45,
                          "currency": "USD",
                          "label": "US$121.45"
                        }
                      },
                      "regular_price": {
                        "currency": "EUR",
                        "amount": 98.95,
                        "label": "98,95 €",
                        "base": {
                          "amount": 109.3,
                          "currency": "USD",
                          "label": "US$109.30"
                        }
                      },
                      "sale_price": {
                        "currency": "EUR",
                        "amount": 97.95,
                        "label": "97,95 €",
                        "base": {
                          "amount": 108.19,
                          "currency": "USD",
                          "label": "US$108.19"
                        }
                      }
                    }
                  }
                }
              ],
              "deliveries": [
                {
                  "id": "del-610c437776054bf98eecf9a20991846a",
                  "items": [
                    {
                      "number": "103832230-8",
                      "quantity": 2,
                      "price": {
                        "currency": "EUR",
                        "amount": 98.95,
                        "base": {
                          "amount": 109.3,
                          "currency": "USD"
                        }
                      },
                      "attributes": {
                        "base_amount": "109.3",
                        "base_currency": "USD"
                      }
                    }
                  ],
                  "options": [
                    {
                      "id": "opt-146ee0350247406a99bd56c0f508adf8",
                      "cost": {
                        "currency": "EUR",
                        "amount": 7.06,
                        "label": "7,06 €",
                        "base": {
                          "amount": 7.8,
                          "currency": "USD",
                          "label": "US$7.80"
                        }
                      },
                      "delivered_duty": "unpaid",
                      "price": {
                        "currency": "EUR",
                        "amount": 10,
                        "label": "10,00 €",
                        "base": {
                          "amount": 10.52,
                          "currency": "USD",
                          "label": "US$10.52"
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
                        "id": "tie-6b992ea6b5c448b1bd033332fdd9dd45",
                        "integration": "information",
                        "name": "Standard Shipping",
                        "services": [
                          "landmark-global"
                        ],
                        "strategy": "lowest_cost",
                        "visibility": "public",
                        "currency": "EUR",
                        "display": {
                          "estimate": {
                            "type": "calculated",
                            "label": "4 Business Days"
                          }
                        }
                      },
                      "window": {
                        "from": "2018-08-27T00:00:00.000Z",
                        "to": "2018-08-27T00:00:00.000Z",
                        "timezone": "UTC",
                        "label": "4 Business Days"
                      },
                      "cost_details": [
                        {
                          "source": "ratecard",
                          "currency": "EUR",
                          "amount": 7.06,
                          "label": "7,06 €",
                          "components": [
                            {
                              "key": "ratecard_base_cost",
                              "currency": "EUR",
                              "amount": 7.06,
                              "label": "7,06 €",
                              "base": {
                                "amount": 7.8,
                                "currency": "USD",
                                "label": "US$7.80"
                              }
                            }
                          ],
                          "base": {
                            "amount": 7.8,
                            "currency": "USD",
                            "label": "US$7.80"
                          }
                        }
                      ],
                      "rule_outcome": {
                        "price": {
                          "amount": 10,
                          "currency": "EUR",
                          "label": "10,00 €"
                        },
                        "discriminator": "flat_rate"
                      },
                      "weight": {
                        "gravitational": {
                          "value": "2",
                          "units": "pound"
                        },
                        "dimensional": {
                          "value": "2.12",
                          "units": "inch"
                        }
                      }
                    },
                    {
                      "id": "opt-5b7ce144d8374dd5864e410747dcd0c3",
                      "cost": {
                        "currency": "EUR",
                        "amount": 7.06,
                        "label": "7,06 €",
                        "base": {
                          "amount": 7.8,
                          "currency": "USD",
                          "label": "US$7.80"
                        }
                      },
                      "delivered_duty": "paid",
                      "price": {
                        "currency": "EUR",
                        "amount": 10,
                        "label": "10,00 €",
                        "base": {
                          "amount": 10.52,
                          "currency": "USD",
                          "label": "US$10.52"
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
                        "id": "tie-6b992ea6b5c448b1bd033332fdd9dd45",
                        "integration": "information",
                        "name": "Standard Shipping",
                        "services": [
                          "landmark-global"
                        ],
                        "strategy": "lowest_cost",
                        "visibility": "public",
                        "currency": "EUR",
                        "display": {
                          "estimate": {
                            "type": "calculated",
                            "label": "4 Business Days"
                          }
                        }
                      },
                      "window": {
                        "from": "2018-08-27T00:00:00.000Z",
                        "to": "2018-08-27T00:00:00.000Z",
                        "timezone": "UTC",
                        "label": "4 Business Days"
                      },
                      "cost_details": [
                        {
                          "source": "ratecard",
                          "currency": "EUR",
                          "amount": 7.06,
                          "label": "7,06 €",
                          "components": [
                            {
                              "key": "ratecard_base_cost",
                              "currency": "EUR",
                              "amount": 7.06,
                              "label": "7,06 €",
                              "base": {
                                "amount": 7.8,
                                "currency": "USD",
                                "label": "US$7.80"
                              }
                            }
                          ],
                          "base": {
                            "amount": 7.8,
                            "currency": "USD",
                            "label": "US$7.80"
                          }
                        }
                      ],
                      "rule_outcome": {
                        "price": {
                          "amount": 10,
                          "currency": "EUR",
                          "label": "10,00 €"
                        },
                        "discriminator": "flat_rate"
                      },
                      "weight": {
                        "gravitational": {
                          "value": "2",
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
                "opt-5b7ce144d8374dd5864e410747dcd0c3"
              ],
              "prices": [
                {
                  "key": "subtotal",
                  "currency": "EUR",
                  "amount": 197.9,
                  "label": "197,90 €",
                  "base": {
                    "amount": 218.6,
                    "currency": "USD",
                    "label": "US$218.60"
                  },
                  "components": [
                    {
                      "key": "vat_item_price",
                      "currency": "EUR",
                      "amount": 34.34,
                      "label": "34,34 €",
                      "base": {
                        "amount": 37.92,
                        "currency": "USD",
                        "label": "US$37.92"
                      },
                      "name": "VAT on item price"
                    },
                    {
                      "key": "vat_duties_item_price",
                      "currency": "EUR",
                      "amount": 4.1,
                      "label": "4,10 €",
                      "base": {
                        "amount": 4.52,
                        "currency": "USD",
                        "label": "US$4.52"
                      },
                      "name": "VAT on duties on item price"
                    },
                    {
                      "key": "item_price",
                      "currency": "EUR",
                      "amount": 162.48,
                      "label": "162,48 €",
                      "base": {
                        "amount": 179.48,
                        "currency": "USD",
                        "label": "US$179.48"
                      },
                      "name": "Item price"
                    },
                    {
                      "key": "rounding",
                      "currency": "EUR",
                      "amount": 1.08,
                      "label": "1,08 €",
                      "base": {
                        "amount": 1.2,
                        "currency": "USD",
                        "label": "US$1.20"
                      },
                      "name": "Rounding"
                    },
                    {
                      "key": "vat_subsidy",
                      "currency": "EUR",
                      "amount": -4.1,
                      "label": "-4,10 €",
                      "base": {
                        "amount": -4.52,
                        "currency": "USD",
                        "label": "-US$4.52"
                      },
                      "name": "VAT subsidy"
                    }
                  ],
                  "name": "Item subtotal"
                },
                {
                  "key": "duty",
                  "currency": "EUR",
                  "amount": 20.33,
                  "label": "20,33 €",
                  "base": {
                    "amount": 22.46,
                    "currency": "USD",
                    "label": "US$22.46"
                  },
                  "components": [
                    {
                      "key": "duties_item_price",
                      "currency": "EUR",
                      "amount": 19.48,
                      "label": "19,48 €",
                      "base": {
                        "amount": 21.52,
                        "currency": "USD",
                        "label": "US$21.52"
                      },
                      "name": "Duties on item price"
                    },
                    {
                      "key": "duties_freight",
                      "currency": "EUR",
                      "amount": 0.85,
                      "label": "0,85 €",
                      "base": {
                        "amount": 0.94,
                        "currency": "USD",
                        "label": "US$0.94"
                      },
                      "name": "Duties on freight"
                    }
                  ],
                  "name": "Duties"
                },
                {
                  "key": "shipping",
                  "currency": "EUR",
                  "amount": 10,
                  "label": "10,00 €",
                  "base": {
                    "amount": 10.52,
                    "currency": "USD",
                    "label": "US$10.52"
                  },
                  "components": [
                    {
                      "key": "vat_freight",
                      "currency": "EUR",
                      "amount": 1.48,
                      "label": "1,48 €",
                      "base": {
                        "amount": 1.64,
                        "currency": "USD",
                        "label": "US$1.64"
                      },
                      "name": "VAT on freight"
                    },
                    {
                      "key": "vat_duties_freight",
                      "currency": "EUR",
                      "amount": 0.18,
                      "label": "0,18 €",
                      "base": {
                        "amount": 0.2,
                        "currency": "USD",
                        "label": "US$0.20"
                      },
                      "name": "VAT on duties on freight"
                    },
                    {
                      "key": "shipping",
                      "currency": "EUR",
                      "amount": 10,
                      "label": "10,00 €",
                      "base": {
                        "amount": 10.52,
                        "currency": "USD",
                        "label": "US$10.52"
                      },
                      "name": "Shipping"
                    },
                    {
                      "key": "vat_subsidy",
                      "currency": "EUR",
                      "amount": -1.66,
                      "label": "-1,66 €",
                      "base": {
                        "amount": -1.84,
                        "currency": "USD",
                        "label": "-US$1.84"
                      },
                      "name": "VAT subsidy"
                    }
                  ],
                  "name": "Shipping"
                }
              ],
              "total": {
                "currency": "EUR",
                "amount": 228.23,
                "label": "228,23 €",
                "base": {
                  "amount": 251.58,
                  "currency": "USD",
                  "label": "US$251.58"
                }
              },
              "attributes": {
                "number": "95F11ED6B6"
              },
              "merchant_of_record": "flow",
              "experience": {
                "key": "europe",
                "discriminator": "experience_reference"
              },
              "submitted_at": "2018-08-21T14:09:22.137Z",
              "lines": [
                {
                  "item_number": "103832230-8",
                  "quantity": 2,
                  "price": {
                    "currency": "EUR",
                    "amount": 98.95,
                    "label": "98,95 €",
                    "base": {
                      "amount": 109.3,
                      "currency": "USD",
                      "label": "US$109.30"
                    }
                  },
                  "total": {
                    "currency": "EUR",
                    "amount": 197.9,
                    "label": "197,90 €",
                    "base": {
                      "amount": 218.6,
                      "currency": "USD",
                      "label": "US$218.60"
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
                  "id": "opm-6896b7bcf0da431e83f06f6518bac10d",
                  "type": "card",
                  "merchant_of_record": "flow",
                  "reference": "aut-TDAxTeCVtkUwFp2EkGi2l4HrjDjGNqVj",
                  "description": "VISA ending with 1111",
                  "total": {
                    "currency": "EUR",
                    "amount": 228.23,
                    "label": "228,23 €",
                    "base": {
                      "amount": 251.58,
                      "currency": "USD",
                      "label": "US$251.58"
                    }
                  },
                  "attributes": {},
                  "address": {
                    "name": {
                      "first": "Eric",
                      "last": "Pigeon"
                    },
                    "streets": [
                      "22 S 2rd st"
                    ],
                    "city": "Philadelphia",
                    "postal": "19104",
                    "country": "BEL"
                  },
                  "date": "2018-08-21T14:09:21.709Z"
                }
              ],
              "balance": {
                "currency": "EUR",
                "amount": 0,
                "label": "0,00 €",
                "base": {
                  "amount": 0,
                  "currency": "USD",
                  "label": "US$0.00"
                }
              }
            },
            "discriminator": "order_upserted_v2"
          }.to_json
        end

        def order_upserted
          canadian_webhook_payload.to_json
        end
      end
    end
  end
end
