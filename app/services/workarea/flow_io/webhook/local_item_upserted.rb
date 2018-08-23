module Workarea
  module FlowIo
    class Webhook::LocalItemUpserted < Webhook
      def process
        if local_item.present?
          local_item.update_attributes local_item_attributes
        else
          pricing_sku.flow_io_local_items.create!(local_item_attributes)
        end
        pricing_sku.save
      end

      private
        delegate :experience, :pricing, to: :upserted_local_item

        def sku
          @sku ||= event.local_item.item.number
        end

        def upserted_local_item
          @upserted_local_item ||= event.local_item
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
          @pricing_attributes || pricing.attributes.symbolize_keys
        end

        def msrp
          @msrp ||= pricing_attributes[:msrp]
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
            msrp: {
              price: msrp.to_m,
              label: msrp.label,
              base: { price: msrp.base.to_m, label: msrp.base.label }
            },
            prices: prices
          }
        end

        def prices
          regular = pricing_attributes[:regular_price]
          sale    = pricing_attributes[:sale_price]

          [
            {
              min_quantity: 1,
              regular: {
                price: regular.to_m,
                label: regular.label,
                base: {
                  price: regular.base.to_m,
                  label: regular.base.label
                }
              },
              sale: {
                price: sale.to_m,
                label: sale.label,
                base: {
                  price: sale.base.to_m,
                  label: sale.base.label
                }
              }
            }
          ]
        end
    end
  end
end
