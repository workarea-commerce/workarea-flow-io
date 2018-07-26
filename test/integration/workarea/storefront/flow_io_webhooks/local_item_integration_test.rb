require 'test_helper'

module Workarea
  module Storefront
    module FlowIoWebHooks
      class LocalItemIntegrationTest < Workarea::IntegrationTest
        include Workarea::FlowIo::WebhookIntegrationTest

        def test_local_item_update
          _sku = create_pricing_sku(id: "432981453-6")
          post storefront.flow_io_webhook_path, params: local_item_upserted, headers: headers
          assert(response.ok?)
          assert_equal({ "status" => 200 }, JSON.parse(response.body))
          assert_equal(200, response.status)
        end

        def test_missing_sku
          post storefront.flow_io_webhook_path, params: local_item_upserted, headers: headers
          refute(response.ok?)
          assert_equal(404, response.status)

          json_response = JSON.parse(response.body)
          assert_equal(["432981453-6"], json_response["params"])
          assert_equal("Document(s) not found for class Workarea::Pricing::Sku with id(s) 432981453-6.", json_response["problem"])
        end

        private

        def local_item_upserted
          {
            "event_id" => "evt-b2354110b01044d49f1a30ab7559ea90",
            "timestamp" => "2018-06-15T14:36:23.877Z",
            "organization" => "workarea-sandbox",
            "local_item" => {
              "id" => "mit-65fa028edd2e4a3592dbf8a499cccf4e",
              "experience" => {
                "id" => "exp-f9ec9be879a341ddb8a67e9a1f34775b",
                "key" => "europe",
                "name" => "Europe",
                "country" => "GBR",
                "currency" => "EUR",
                "language" => "en"
              },
              "item" => {
                "id" => "mit-65fa028edd2e4a3592dbf8a499cccf4e",
                "number" => "432981453-6"
              },
              "pricing" => {
                "price" => {
                  "currency" => "EUR",
                  "amount" => 60.95,
                  "label" => "60,95 €",
                  "base" => {
                    "amount" => 69.13,
                    "currency" => "USD",
                    "label" => "US$69.13"
                  },
                  "includes" => {
                    "key" => "vat",
                    "label" => "Includes VAT"
                  }
                },
                "attributes" => {
                  "msrp" => {
                    "currency" => "CAD",
                    "amount" => 40,
                    "label" => "CA$40.00",
                    "base" => {
                      "amount" => 29.33,
                      "currency" => "USD",
                      "label" => "US$29.33"
                    }
                  },
                  "regular_price" => {
                    "currency" => "CAD",
                    "amount" => 20,
                    "label" => "CA$20.00",
                    "base" => {
                      "amount" => 14.67,
                      "currency" => "USD",
                      "label" => "US$14.67"
                    }
                  },
                  "sale_price" => {
                    "currency" => "CAD",
                    "amount" => 20,
                    "label" => "CA$20.00",
                    "base" => {
                      "amount" => 14.67,
                      "currency" => "USD",
                      "label" => "US$14.67"
                    }
                  }
                }
              },
              "status" => "included"
            },
            "discriminator" => "local_item_upserted"
          }.to_json
        end
      end
    end
  end
end
