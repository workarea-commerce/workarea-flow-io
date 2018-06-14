module Workarea
  module Pricing
    class FlowIoPriceWithLabel
      include ApplicationDocument

      field :price, type: Money
      field :label, type: String

      validates_presence_of :price, :label

      def self.build_from_localized_item_price(localized_item_price)
        new(
          price: localized_item_price.amount.to_money(localized_item_price.currency),
          label: localized_item_price.label
        )
      end

      def self.build_from_price_with_base(price_with_base)
        return nil unless price_with_base.present?

        new(
          price: price_with_base.amount.to_money(price_with_base.currency),
          label: price_with_base.label
        )
      end
    end
  end
end
