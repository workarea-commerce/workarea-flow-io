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

      def create_pricing_sku_with_flow(overrides = {})
        attributes = {
          id: "004056270-0",
          msrp: {cents: 9241.0, currency_iso: "USD"},
          tax_code: "001",
          on_sale: false,
          prices: [
            {
              min_quantity: 1,
              regular: {cents: 8241.0, currency_iso: "USD"},
              sale: {cents: 8141.0, currency_iso: "USD"}
            }
          ],
          flow_io_local_items: overrides[:flow_io_local_items] || [build_pricing_flow_io_local_item]
        }.merge(overrides)

        Workarea::Pricing::Sku.new(attributes).tap(&:save!)
      end

      def build_pricing_flow_io_local_item(overrides = {},
                                           sell: 120.to_m("CAD"),
                                           msrp: 140.to_m("CAD"),
                                           regular: 120.to_m("CAD"),
                                           sale: 110.to_m("CAD"))

        attributes = {
          id: "mit-86beca991a514dac9a5fd48443f00b6b",
          experience: build_flow_io_experience_summary,
          pricing: {
            included_levies: {key: nil, label: nil},
            sell: {
              price: sell,
              label: "CA$120.00"
            },
            regular: {
              price: regular,
              label: "CA$120.00"
            },
          }
        }.merge(overrides)

        Workarea::Pricing::FlowIoLocalItem.new(attributes).tap do |local_item|
          if msrp.present?
            local_item.pricing.msrp = Workarea::Pricing::FlowIoPriceWithLabel.new(
              price: msrp,
              label: "CA$140.00"
            )
          end

          if sale.present?
            local_item.pricing.sale = Workarea::Pricing::FlowIoPriceWithLabel.new(
              price: sale,
              label: "CA$110.00"
            )
          end
        end
      end
    end
  end
end
