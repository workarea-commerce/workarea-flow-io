module Workarea
  module FlowIo
    # Represents a local item imported by the CSV importer.
    class ImportedItem
      attr_reader :params, :experiences

      def initialize(row, experiences)
        # HACK needed to parse params with keys like
        # `parent[child][param]`, since that's what they come in
        # as from the CSV.
        @params = Rack::Utils.default_query_parser
                             .parse_nested_query(row.to_h.to_query)
                             .deep_symbolize_keys
        @experiences = experiences
      end

      def self.process(row, experiences)
        new(row, experiences).tap(&:save!)
      end

      def save!
        # World experience will be converted by Flow's javascript on the
        # storefront
        return if experience_key.match?(/world/i)

        Sidekiq::Callbacks.disable(Workarea::FlowIo::ItemExporter) do
          if local_item.present?
            local_item.update_attributes(local_item_attributes)
          else
            sku.flow_io_local_items.create!(local_item_attributes)
          end

          sku.save!
        end
      end

      private

      def experience_key
        params[:experience][:key]
      end

      def experience
        @experience ||=
          begin
            exp = experiences.detect { |e| e.key == experience_key }

            ExperienceSummary.new(
              key: experience_key,
              name: exp.name,
              country: Country.find_country_by_alpha3(exp.country),
              currency: exp.currency,
              language: exp.language
            )
          end
      end

      def sku
        @sku ||= Pricing::Sku.find_or_create_by!(_id: params[:item][:number])
      end

      def local_item
        @local_item ||= sku.flow_io_local_items
          .detect { |li| li.experience.key == experience.key }
      end

      def local_item_attributes
        {
          experience: experience,
          prices: prices
        }.merge(msrp)
      end

      def pricing_attributes
         params[:prices][:price_attributes]
      end

      def msrp
        return {} unless msrp_attributes = pricing_attributes[:msrp]

        msrp = price_from_amount(msrp_attributes[:amount].to_f, msrp_attributes[:currency])
        msrp_base = price_from_amount(msrp_attributes[:base][:amount].to_f, msrp_attributes[:base][:currency])

        return {} if msrp.blank? || msrp_base.blank?

        {
          msrp: {
            price: msrp,
            label: msrp_attributes[:label],
            base_currency: {
              price: msrp_base,
              label: msrp_attributes[:base][:label]
            }
          }
        }
      end

      def prices
        regular = pricing_attributes[:regular_price]
        sale    = pricing_attributes[:sale_price]
        regular_price = price_from_amount(regular[:amount].to_f, regular[:currency])
        regular_base_price = price_from_amount(regular[:base][:amount].to_f, regular[:base][:currency])

        return [] if regular_price.blank? || regular_base_price.blank?

        price = {
          min_quantity: 1,
          regular: {
            price: regular_price,
            label: regular[:label],
            base_currency: {
              price: regular_base_price,
              label: regular[:base][:label]
            }
          }
        }

        if sale.present?
          sale_price = price_from_amount(sale[:amount].to_f, sale[:currency])
          sale_base_price = price_from_amount(sale[:base][:amount].to_f, sale[:base][:currency])

          if sale_price.present? && sale_base_price.present?
            price[:sale] = {
              price: sale_price,
              label: sale[:label],
              base_currency: {
                price: sale_base_price,
                label: sale[:base][:label]
              }
            }
          end
        end

        [price]
      end

      def price_from_amount(amount = nil, currency = nil)
        return if amount.blank? || currency.blank?

        Money.from_amount(amount, currency)
      end
    end
  end
end
