module Workarea
  module FlowIo
    class ItemImporter
      def self.perform!(item)
        new(item).perform!
      end

      attr_reader :item

      def initialize(item)
        @item = item
      end

      def perform!
        if local_item.present?
          local_item.update_attributes local_item_attributes
        else
          pricing_sku.flow_io_local_items.create!(local_item_attributes)
        end
        pricing_sku.save
      end

      private
        delegate :local, to: :item
        delegate :experience, to: :local

        def sku
          item.number
        end

        def pricing_sku
          @pricing_sku ||= Pricing::Sku.find sku
        end

        def local_item
          @local_item ||= pricing_sku
            .flow_io_local_items
            .detect { |li| li.experience.key == experience.key }
        end

        def pricing_attributes
          @pricing_attributes || local.price_attributes.symbolize_keys
        end

        def msrp_attributes
          @msrp_attributes ||= pricing_attributes[:msrp]
        end

        def msrp
          return {} unless msrp_attributes.present?

          {
            msrp: {
              price: msrp_attributes.to_m,
              label: msrp_attributes.label,
              base: { price: msrp_attributes.base.to_m, label: msrp_attributes.base.label }
            }
          }
        end

        def local_item_attributes
          {
            experience: {
              id:       experience.id,
              key:      experience.key,
              name:     experience.name,
              country:  Country.find_country_by_alpha3(experience.country),
              currency: experience.currency,
              language: experience.language
            },
            prices: prices
          }.merge(msrp)
        end

        def prices
          regular = pricing_attributes[:regular_price]
          sale    = pricing_attributes[:sale_price]

          price = {
            min_quantity: 1,
            regular: {
              price: regular.to_m,
              label: regular.label,
              base: {
                price: regular.base.to_m,
                label: regular.base.label
              }
            }
          }

          if sale.present?
            price[:sale] = {
              price: sale.to_m,
              label: sale.label,
              base: {
                price: sale.base.to_m,
                label: sale.base.label
              }
            }
          end

          [price]
        end
    end
  end
end
