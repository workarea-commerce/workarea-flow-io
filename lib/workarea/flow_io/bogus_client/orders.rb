module Workarea
  module FlowIo
    class BogusClient
      class Orders
        def put_by_number(_organization_id, number, order_put_form, options = {})
          if order_put_form.items.empty?
            raise ::Io::Flow::V0::HttpClient::ServerError.new(
              422,
              "Unprocessable Entity",
              body: "{\"code\":\"generic_error\",\"messages\":[\"Must have at least 1 item to create an order\"]}"
            )
          else
            OrderResponse.new(number, order_put_form, options).flow_model
          end
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
              unless ["canada", "europe"].include? experience_key
                raise "No bogus response for #{experience_key}"
              end

              order
            end

            private

              def convert_price(money, rate: 1.2)
                return unless money.present?

                fractional = (money.dup * rate).fractional
                remainder = fractional % 500

                Money.from_amount((fractional + 500 - remainder) / 100, currency_code)
              end

              def experience_key
                options[:experience]
              end

              def experience_id
                @experience_id ||= "exp-#{SecureRandom.hex(16)}"
              end

              def experience
                @experience ||=
                  case experience_key
                  when "canada"
                  when "europe"
                  end
              end

              def experience_summary
                @experience_summary ||= {
                  id: experience_id,
                  key: experience_key.downcase,
                  name: experience_key,
                  country: nil,
                  currency: nil,
                  language: nil
                }
              end

              def currency_code
                @experience ||=
                  case experience_key
                  when "canada" then "CAD"
                  when "europe" then "EUR"
                  end
              end

              def currency_symbol
                @experience ||=
                  case experience_key
                  when "canada" then "CA$"
                  when "europe" then "€"
                  end
              end

              def total
                126.72.to_m
              end

              def converted_total
                convert_price total
              end

              def order
                ::Io::Flow::V0::Models::Order.new(
                  id: "order-#{SecureRandom.hex(20).downcase}",
                  number: number,
                  merchant_of_record: "flow",
                  experience: { key: experience_key, discriminator: "experience_reference" },
                  customer: customer,
                  delivered_duty: "paid",
                  destination: destination,
                  expires_at: Time.now.iso8601,
                  items: items,
                  deliveries: deliveries,
                  selections: ["opt-c6cd61df76c64786b336e3d40098e797"],
                  prices: prices,
                  total: {
                    currency: currency_code,
                    amount: converted_total.to_f,
                    label: "#{currency_symbol}#{converted_total.to_f}",
                    base: { amount: total.to_f, currency: "USD", label: "US$#{total.to_f}" },
                    key: "localized_total"
                  },
                  attributes: { "number" => number },
                  submitted_at: nil,
                  lines: lines,
                  identifiers: nil,
                  promotions: nil,
                  payments: [],
                  balance: {
                    currency: currency_code,
                    amount: converted_total.to_f,
                    label: "#{currency_symbol}#{converted_total.to_f}",
                    base: { amount: total.to_f, currency: "USD", label: "US$#{total.to_f}" },
                    key: "localized_total"
                  },
                  rules: nil,
                  tax_registration: nil,
                  discriminator: "order"
                )
              end

              # TODO fix to correct currency
              #
              def prices
                [
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
                ]
              end

              def customer
                {
                  name: { first: nil, last: nil },
                  number: nil,
                  phone: nil,
                  email: nil
                }
              end

              def country_code
                @country_code ||=
                  case experience_key
                  when "CAD"
                  when "GBR"
                  end
              end

              def destination
                {
                  text: nil,
                  streets: nil,
                  city: nil,
                  province: nil,
                  postal: nil,
                  country: country_code,
                  latitude: nil,
                  longitude: nil,
                  contact: {
                    name: { first: nil, last: nil },
                    company: nil,
                    email: nil,
                    phone: nil
                  }
                }
              end

              # TODO fix to correct currency
              #
              def delivery_option(delivered_duty:)
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
                  delivered_duty: delivered_duty,
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
              end

              def deliveries
                [
                  {
                    id: "del-4070e782d85245f4bc29a8f56d55f33d",
                    center: { id: "cen-394b1db3c61a495c964dd1fe60969160", key: "center-workarea" },
                    items: delivery_items,
                    options: [
                      delivery_option(delivered_duty: "unpaid"),
                      delivery_option(delivered_duty: "paid"),
                    ],
                    discriminator: "physical_delivery"
                  }
                ]
              end

              def items
                order_put_form.items.map do |line_item_form|
                  price =
                    if line_item_form.price.is_a? Io::Flow::V0::Models::Price
                      line_item_form.price.to_m
                    elsif line_item_form.price.is_a? Hash
                      Io::Flow::V0::Models::Price.new(line_item_form.price).to_m
                    else
                      # ((rand(0..100.0) * 100).floor / 100.0).to_m
                      88.66.to_m
                    end

                  converted_price = convert_price(price)

                  {
                    number: line_item_form.number,
                    name: "Incredible Cotton Bag",
                    quantity: line_item_form.quantity,
                    center: nil,
                    price: nil,
                    attributes: nil,
                    local: {
                      experience: experience_summary,
                      prices: [
                        {
                          currency: converted_price.currency.iso_code,
                          amount: converted_price.to_f,
                          label: converted_price.format(disambiguate: true),
                          base: { amount: price.to_f, currency: price.currency.iso_code, label: price.format(disambiguate: true) },
                          includes: { key: "vat", label: "Includes VAT" },
                          key: "localized_item_price"
                        }
                      ],
                      rates: [],
                      spot_rates: [],
                      status: "included",
                      attributes: {
                        "Size" => "Extra Large",
                        "product_id" => "890726C80A",
                        "fulfillment_method" => "physical"
                      },
                      price_attributes: {}
                    },
                    shipment_estimate: nil,
                    discounts: line_item_form.discounts.discounts.map do |discount_form|
                      {
                        amount: -0.36,
                        requested: {
                          amount: -0.0358,
                          currency: currency_code,
                        },
                        currency: currency_code,
                        label: "-#{currency_symbol}0.36",
                        discount_label: discount_form.label,
                        base: {
                          amount: -0.25,
                          currency: 'USD',
                          label: "-US$0.25"
                        }
                      }
                    end
                  }
                end
              end

              # TODO fix to correct currency
              #
              def lines
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

              def delivery_items
                order_put_form.items.map do |line_item_form|
                  price =
                    if line_item_form.price.is_a? Io::Flow::V0::Models::Price
                      line_item_form.price.to_m
                    elsif line_item_form.price.is_a? Hash
                      Io::Flow::V0::Models::Price.new(line_item_form.price).to_m
                    else
                      ((rand(0..100.0) * 100).floor / 100.0).to_m
                    end

                  converted_price = convert_price(price)
                  {
                    number: line_item_form.number,
                    quantity: line_item_form.quantity,
                    shipment_estimate: nil,
                    price: { amount: converted_price.to_f, currency: currency_code },
                    attributes: { "base_amount" => "88.66", "base_currency" => "USD" },
                    center: nil,
                    discount: line_item_form.discount&.to_hash,
                  }
                end
              end
          end
      end
    end
  end
end
