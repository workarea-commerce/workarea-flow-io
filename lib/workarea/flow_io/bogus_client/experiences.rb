module Workarea
  module FlowIo
    class BogusClient
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
    end
  end
end
