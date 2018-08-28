module Workarea
  module FlowIo
    class BogusClient
      require 'workarea/flow_io/bogus_client/orders'

      def experiences
        @experiences || Experiences.new
      end

      def fulfillments
        @fulfillments ||= Fulfillments.new
      end

      def items
        @items ||= Items.new
      end

      def orders
        @orders ||= Orders.new
      end

      def organizations
        @organization ||= Organizations.new
      end

      def sessions
        @sessions ||= Sessions.new
      end

      def shipping_notifications
        @shipping_notifications = ShippingNotifications.new
      end

      class Experiences
        def get(_organization_id)
          [
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
            ),
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
            ),
            ::Io::Flow::V0::Models::Experience.new(
              id: "exp-72464b1f651d49fe8108dcabf4678942",
              key: "europe",
              name: "Europe",
              delivered_duty: "paid",
              region: { id: "europe" },
              country: "GBR",
              currency: "EUR",
              language: "en",
              measurement_system: "metric",
              subcatalog: { id: "sca-1879e0bb1b6a48e0b8d35d56bf1f42c6",
              discriminator: "subcatalog_reference" },
              position: 2,
              settings: {
                delivered_duty: {
                  default: "paid",
                  available: ["paid", "unpaid"],
                  display: "single"
                }
              },
              status: "active",
              discriminator: "experience"
            )
          ]
        end
      end

      class Fulfillments
        def put_cancellations(_organization, _number, _fulfillment_cancellation_form); end
      end

      class Items
        def put_by_number(organization, number, form); end

        def delete_by_number(organization_id, number); end
      end

      class Organizations
        def get_countries_by_organization(organization)
          [
            ::Io::Flow::V0::Models::Country.new(
              name: "Canada",
              iso_3166_2: "CA",
              iso_3166_3: "CAN",
              languages: ["en", "fr"],
              measurement_system: "metric",
              default_currency: "CAD",
              timezones: ["Canada/Eastern"],
              default_delivered_duty: nil
            ),
            ::Io::Flow::V0::Models::Country.new(
              name: "United Kingdom",
              iso_3166_2: "GB",
              iso_3166_3: "GBR",
              languages: ["cy", "en"],
              measurement_system: "metric",
              default_currency: "GBP",
              timezones: ["GMT"],
              default_delivered_duty: nil
            ),
            ::Io::Flow::V0::Models::Country.new(
              name: "United States of America",
              iso_3166_2: "US",
              iso_3166_3: "USA",
              languages: ["en"],
              measurement_system: "imperial",
              default_currency: "USD",
              timezones: ["America/Chicago", "America/Los_Angeles", "America/New_York"],
              default_delivered_duty: nil
            )
          ]
        end
      end

      class Sessions
        def get_by_session(session = 1)
          if session == 1
            domestic_attributes
          else
            foreign_attributes
          end

          ::Io::Flow::V0::Models::Session.from_json(attributes)
        end

        def domestic_attributes
          {
            id: "F51MUamlJKDTPUwlhZ4D2bwYnFUbmlwv0ULNnlMs2UkURkioYJNmNY5pRjNHC3bH",
            organization: "workarea-sandbox",
            visitor: { id: "F52Vkf7Y8cU9eQ0ELKI7Ba5Fc4UeKjLKislDjnkr93T8z7QKuHrVYN5eWXMzLuyg" },
            visit: { id: "F53cGqSw6mAi7z4LQEiZ2FJOWlm4wasFG8Y8ia0VDmQTrpmLjDUrrD0VFrZpT5dT", expires_at: "Wed, 18 Jul 2030 15:07:16 +0000" },
            environment: "sandbox",
            attributes: {},
            ip: "100.34.240.156",
            local: nil,
            geo: {
              country: {
                name: "United States of America",
                iso_3166_2: "US",
                iso_3166_3: "USA",
                languages: ["en"],
                measurement_system: "imperial",
                default_currency: "USD",
                timezones: ["America/Chicago", "America/Los_Angeles", "America/New_York"],
                default_delivered_duty: nil
              },
              currency: { name: "US Dollars", iso_4217_3: "USD", number_decimals: 2, symbols: { primary: "US$", narrow: "$" }, default_locale: "en-US" },
              language: { name: "English", iso_639_2: "en" },
              locale: { id: "en-US", name: "English - United States", country: "USA", language: "en", numbers: { decimal: ".", group: "," } }
            },
            experience: nil,
            format: { currency: { symbol: "primary", label_formatters: [] } },
            experiment: nil,
            discriminator: "organization_session"
          }
        end

        def foreign_attributes
          {
            id: "F51neI7zcfN7FVFyvuOmi9IvY1qY6CPtBk3dPJoeNL1Xy1wRxxfnjRgft8S8CapT",
            organization: "workarea-sandbox",
            visitor: { id: "F52ScAR8QT2sHU4frYukR9a6A8ZSljh8HDV5l7DUBgv7KCAK3piQnIRnMZx0AL9D" },
            visit: { id: "F53Ro2nv4jRetzy45aGIey3n2aidrJhozVukGPMBjDE9phxhC7uryiGaHhtkmybt", expires_at: "Tue, 17 Jul 2030 21:22:57 +0000" },
            environment: "sandbox",
            attributes: {},
            ip: "173.161.162.1",
            local: {
              country: {
                name: "Canada",
                iso_3166_2: "CA",
                iso_3166_3: "CAN",
                languages: ["en", "fr"],
                measurement_system: "metric",
                default_currency: "CAD",
                timezones: ["Canada/Eastern"],
                default_delivered_duty: nil
              },
              currency: { name: "Canadian Dollar", iso_4217_3: "CAD", number_decimals: 2, symbols: { primary: "CA$", narrow: "$" }, default_locale: "en-CA" },
              language: { name: "English", iso_639_2: "en" },
              locale: { id: "en-CA", name: "English - Canada", country: "CAN", language: "en", numbers: { decimal: ".", group: "," } },
              experience: { key: "canada", name: "Canada", region: { id: "can" }, country: "CAN", currency: "CAD", language: "en", measurement_system: "metric" },
              experiment: nil
            },
            geo: {
              country: {
                name: "Canada",
                iso_3166_2: "CA",
                iso_3166_3: "CAN",
                languages: ["en", "fr"],
                measurement_system: "metric",
                default_currency: "CAD",
                timezones: ["Canada/Eastern"],
                default_delivered_duty: nil
              },
              currency: { name: "Canadian Dollar", iso_4217_3: "CAD", number_decimals: 2, symbols: { primary: "CA$", narrow: "$" }, default_locale: "en-CA" },
              language: { name: "English", iso_639_2: "en" },
              locale: { id: "en-CA", name: "English - Canada", country: "CAN", language: "en", numbers: { decimal: ".", group: "," } }
            },
            experience: { key: "canada", name: "Canada", region: { id: "can" }, country: "CAN", currency: "CAD", language: "en", measurement_system: "metric" },
            format: { currency: { symbol: "primary", label_formatters: [] } },
            experiment: nil,
            discriminator: "organization_session"
          }
        end
      end

      class ShippingNotifications
        def post(_organization, _shipping_notification_form)
        end
      end
    end
  end
end
