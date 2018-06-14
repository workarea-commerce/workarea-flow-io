module Workarea
  module Pricing
    class FlowIoLocalItemPricing
      include ApplicationDocument

      field :included_levies, type: Hash, default: {}

      embeds_one :sell, class_name: "Workarea::Pricing::FlowIoPriceWithLabel"
      embeds_one :msrp, class_name: "Workarea::Pricing::FlowIoPriceWithLabel"
      embeds_one :regular, class_name: "Workarea::Pricing::FlowIoPriceWithLabel"
      embeds_one :sale, class_name: "Workarea::Pricing::FlowIoPriceWithLabel"

      validates_presence_of :sell, :regular

      # @param ::Io::Flow::V0::Models::LocalItemPricing
      def self.build_from_local_item_pricing(local_item_pricing)
        pricing_attributes = local_item_pricing.attributes.symbolize_keys
        msrp = pricing_attributes[:msrp]
        regular = pricing_attributes[:regular_price]
        sale = pricing_attributes[:sale_price]

        new(
          included_levies: {
            key: local_item_pricing.price.includes&.key&.value,
            label: local_item_pricing.price.includes&.label
          },
          sell: FlowIoPriceWithLabel.build_from_localized_item_price(local_item_pricing.price),
          msrp: FlowIoPriceWithLabel.build_from_price_with_base(msrp),
          regular: FlowIoPriceWithLabel.build_from_price_with_base(regular),
          sale: FlowIoPriceWithLabel.build_from_price_with_base(sale)
        )
      end

      # @param ::Io::Flow::V0::Models::Local
      def self.build_from_local(local)
        localized_item_price = local.prices.detect { |price| price.key == "localized_item_price" }
        pricing_attributes = local.price_attributes.symbolize_keys
        msrp = pricing_attributes[:msrp]
        regular = pricing_attributes[:regular_price]
        sale = pricing_attributes[:sale_price]

        new(
          included_levies: {
            key: localized_item_price.includes&.key&.value,
            label: localized_item_price.includes&.label
          },
          sell: FlowIoPriceWithLabel.build_from_localized_item_price(localized_item_price),
          msrp: FlowIoPriceWithLabel.build_from_price_with_base(msrp),
          regular: FlowIoPriceWithLabel.build_from_price_with_base(regular),
          sale: FlowIoPriceWithLabel.build_from_price_with_base(sale)
        )
      end
    end
  end
end
