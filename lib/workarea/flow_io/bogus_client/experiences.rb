module Workarea
  module FlowIo
    class BogusClient
      class Experiences
        def get(_organization_id)
          [canada_experience, canada_2_experience, china_experience, europe_experience]
        end

        # @param organization_id [String]
        # @param key [String]
        #
        def get_by_key(_organization_id, key)
          case key
          when "canada" then canada_experience
          when "canada2" then canada_2_experience
          when "china" then china_experience
          when "europe" then europe_experience
          else europe_experience
          end
        end

        private

          def china_experience
            ::Io::Flow::V0::Models::Experience.new(
              "id" => "exp-5af698539a884d568dcdb950ed01521c",
              "key" => "china",
              "name" => "China",
              "delivered_duty" => "paid",
              "region" => { "id" => "chn" },
              "country" => "CHN",
              "currency" => "CNY",
              "language" => "zh",
              "measurement_system" => "metric",
              "subcatalog" => {
                "id" => "sca-c06ac78fe14c4618b025d922bb1b5594",
                "discriminator" => "subcatalog_reference"
              },
              "position" => 2,
              "settings" => {
                "delivered_duty" => {
                  "default" => "paid",
                  "available" => ["paid", "unpaid"],
                  "display" => "all"
                },
                "pricing_settings" => {
                  "editable" => true,
                  "default_tax_display" => "included",
                  "default_duty_display" => "ignored"
                },
                "logistics_settings" => { "shipping_configuration" => { "key" => "001" } },
                "checkout_settings" => {
                  "configuration" => { "id" => "chc-5dd603d15c9c4f5fbf8c96b98d66eeda" }
                }
              },
              "status" => "active",
              "discriminator" => "experience"
            )
          end

          def europe_experience
            ::Io::Flow::V0::Models::Experience.new(
              "id" => "exp-5af698539a884d568dcdb950ed01521c",
              "key" => "europe",
              "name" => "Europe",
              "delivered_duty" => "paid",
              "region" => { "id" => "eur" },
              "country" => "GBR",
              "currency" => "EUR",
              "language" => "eu",
              "measurement_system" => "metric",
              "subcatalog" => {
                "id" => "sca-c06ac78fe14c4618b025d922bb1b5594",
                "discriminator" => "subcatalog_reference"
              },
              "position" => 2,
              "settings" => {
                "delivered_duty" => {
                  "default" => "paid",
                  "available" => ["paid", "unpaid"],
                "display" => "all"
                },
                "pricing_settings" => {
                  "editable" => true,
                  "default_tax_display" => "included",
                  "default_duty_display" => "ignored"
                },
                "logistics_settings" => { "shipping_configuration" => { "key" => "001" } },
                "checkout_settings" => {
                  "configuration" => { "id" => "chc-5dd603d15c9c4f5fbf8c96b98d66eeda" }
                }
              },
              "status" => "active",
              "discriminator" => "experience"
            )
          end

          def canada_experience
            ::Io::Flow::V0::Models::Experience.new(
              id: "exp-95889ba1ff4b449f8a3c0e0a7a4fb23b",
              key: "canada",
              name: "Canada",
              delivered_duty: "paid",
              region: { id: "can" },
              country: "CAN",
              currency: "CAD",
              language: "en",
              measurement_system: "metric",
              subcatalog: { id: "sca-e866a54205db401ca0d5add025d4706b",
              discriminator: "subcatalog_reference" },
              position: 0,
              settings: {
                delivered_duty: {
                  default: "paid",
                  available: ["paid", "unpaid"],
                  display: "all"
                }
              },
              status: "active",
              discriminator: "experience"
            )
          end

          def canada_2_experience
            ::Io::Flow::V0::Models::Experience.new(
              id: "exp-2d65a4a036e9480196bc36554b6a2b99",
              key: "canada-2",
              name: "Canada 2",
              delivered_duty: "paid",
              region: { id: "can" },
              country: "CAN",
              currency: "CAD",
              language: "en",
              measurement_system: "metric",
              subcatalog: { id: "sca-fc951797454d4431a4d73efee56f3d67",
              discriminator: "subcatalog_reference" },
              position: 1,
              settings: {
                delivered_duty: {
                  default: "paid",
                  available: ["paid", "unpaid"],
                  display: "all"
                }
              },
              status: "active",
              discriminator: "experience"
            )
          end
      end
    end
  end
end
