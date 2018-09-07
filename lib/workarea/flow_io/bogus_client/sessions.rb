module Workarea
  module FlowIo
    class BogusClient
      class Sessions
        def get_by_session(session = 1)
          attributes =
            case session
            when 1, "F51MUamlJKDTPUwlhZ4D2bwYnFUbmlwv0ULNnlMs2UkURkioYJNmNY5pRjNHC3bH"
              domestic_attributes
            when "404"
              raise ::Io::Flow::V0::HttpClient::ServerError.new(
                404,
                "Not Found",
                body: nil
              )
            else
              foreign_attributes
            end

          ::Io::Flow::V0::Models::Session.from_json(attributes)
        end

        def post_organizations_by_organization(_organization_id, session_form)
          if session_form[:country].blank? || session_form[:country] == "USA"
            ::Io::Flow::V0::Models::Session.from_json(domestic_attributes)
          else
            ::Io::Flow::V0::Models::Session.from_json(foreign_attributes)
          end
        end

        private

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
    end
  end
end
