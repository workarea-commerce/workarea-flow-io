module Workarea
  module Factories
    module FlowIo
      Factories.add self

      def build_flow_io_experience_summary(overrides = {})
        attributes = {
          _id: "exp-31b66afd8ac44a71a0669b2ad81a794d",
          key: "canada",
          name: "Canada",
          country: "CA",
          currency: "CAD",
          language: "en"
        }.merge(overrides)

        Workarea::FlowIo::ExperienceSummary.new(attributes)
      end

      def build_flow_io_experience_geo(overrides = {})
        attributes = {
          key: "canada",
          name: "Canada",
          region: { id: "can" },
          country: "CAN",
          currency: "CAD",
          language: "en",
          measurement_system: "metric"
        }.merge(overrides)

        Workarea::FlowIo::ExperienceGeo.new(attributes)
      end

      def create_pricing_sku_with_flow(overrides = {})
        attributes = {
          id: "004056270-0",
          msrp: { cents: 9241.0, currency_iso: "USD" },
          tax_code: "001",
          on_sale: false,
          prices: [
            {
              min_quantity: 1,
              regular: { cents: 8241.0, currency_iso: "USD" },
              sale: { cents: 8141.0, currency_iso: "USD" }
            }
          ],
          flow_io_local_items: overrides[:flow_io_local_items] || [build_flow_io_local_item]
        }.merge(overrides)

        Workarea::Pricing::Sku.new(attributes).tap(&:save!)
      end

      def build_flow_io_local_item(regular: 120.to_m("CAD"), sale: 110.to_m("CAD"), **overrides)
        price = { regular: { price: regular, label: regular.format } }.tap do |p|
          if sale.present?
            p[:sale] = { price: sale, label: sale.format }
          end
        end

        attributes = {
          id: "mit-86beca991a514dac9a5fd48443f00b6b",
          experience: build_flow_io_experience_summary,
          msrp: { price: 140.to_m("CAD"), label: "CA$140.00" },
          prices: [price]
        }.merge(overrides)

        Workarea::FlowIo::LocalItem.new(attributes)
      end

      def create_shipping_service(overrides = {})
        attributes = {
          name: "Test #{shipping_service_count}",
          service_code: shipping_service_count,
          rates: [{ price: 1.to_m }]
        }.merge(overrides)

        Shipping::Service.new(attributes.except(:rates)).tap do |service|
          if attributes[:rates].present?
            attributes[:rates].each do |attrs|
              service.rates.build(attrs)
            end
          end

          service.save!
          Factories.shipping_service_count += 1
        end
      end
    end
  end
end
