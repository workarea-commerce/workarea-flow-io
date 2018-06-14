module Workarea
  module Pricing
    class FlowIoLocalItem
      include ApplicationDocument

      embeds_one :experience, class_name: "Workarea::FlowIo::ExperienceSummary"
      embeds_one :pricing, class_name: "Workarea::Pricing::FlowIoLocalItemPricing"

      # @param Io::Flow::V0::Models::LocalItem
      def update_from_flow_local_item(local_item)
        self.attributes = {
          id: local_item.id,
          experience: {
            id: local_item.experience.id,
            key: local_item.experience.key,
            name: local_item.experience.name,
            country: Country.find_country_by_alpha3(local_item.experience.country),
            currency: local_item.experience.currency,
            language: local_item.experience.language
          },
          pricing: FlowIoLocalItemPricing.build_from_local_item_pricing(local_item.pricing)
        }
      end

      # @param Io::Flow::V0::Models::Item
      def update_from_flow_item(item)
        self.attributes = {
          id: item.id,
          experience: {
            id: item.local.experience.id,
            key: item.local.experience.key,
            name: item.local.experience.name,
            country: Country.find_country_by_alpha3(item.local.experience.country),
            currency: item.local.experience.currency,
            language: item.local.experience.language
          },
          pricing: FlowIoLocalItemPricing.build_from_local(item.local)
        }
      end
    end
  end
end
