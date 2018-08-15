module Workarea
  module Pricing
    class FlowIoLocalItem
      include ApplicationDocument

      embedded_in :sku, class_name: "Workarea::Pricing::Sku"
      embeds_one :experience, class_name: "Workarea::FlowIo::ExperienceSummary"
      embeds_one :pricing, class_name: "Workarea::Pricing::FlowIoLocalItemPricing"

      # @param Io::Flow::V0::Models::LocalItem
      def update_from_flow_local_item(local_item)
        self.attributes = {
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

      # Creates a Pricing::Price from this local item
      # used in Pricing::Sku#find_price
      #
      # @return [Pricing::Price]
      #
      def to_price
        Price.new(
          sku: self.sku.clone, # clone the sku so this price isn't added to #prices on real record
          # TODO change when quantity based pricing in implemented
          min_quantity: 1,
          regular: pricing.regular.price,
          sale: pricing.sale.price
        )
      end
    end
  end
end
