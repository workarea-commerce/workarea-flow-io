module Workarea
  module FlowIo
    class LocalItem
      include ApplicationDocument

      field :included_levies, type: Hash, default: {}

      embedded_in :sku, class_name: "Workarea::Pricing::Sku"

      embeds_one :experience, class_name: "Workarea::FlowIo::ExperienceSummary"
      embeds_one :msrp, class_name: "Workarea::FlowIo::PriceWithBase"
      embeds_many :prices, class_name: "Workarea::FlowIo::LocalizedPrice"

      validates_presence_of :experience

      delegate :on_sale?, to: :sku

      # Creates a Pricing::Price from this local item
      # used in Pricing::Sku#find_price
      #
      # @return [Pricing::Price]
      #
      def to_price(quantity = 1)
        prices.sort_by(&:min_quantity).reverse.detect do |localized_price|
          quantity >= localized_price.min_quantity
        end&.to_price || Workarea::Pricing::Price.new(regular: 0.to_m(experience.currency))
      end

      # TODO determine if we still need the original
      #
      #
      def to_flow_label(quantity = 1, &block)
        price = prices.sort_by(&:min_quantity).reverse.detect do |localized_price|
          quantity >= localized_price.min_quantity
        end

        return if price.blank?

        block.call(price)&.label
      end
    end
  end
end
