module Workarea
  module FlowIo
    class BogusClient
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
    end
  end
end
