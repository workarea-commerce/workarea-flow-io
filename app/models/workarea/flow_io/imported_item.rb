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

        {
          msrp: {
            price: Money.from_amount(msrp_attributes[:amount].to_f, msrp_attributes[:currency]),
            label: msrp_attributes[:label],
            base_currency: {
              price: Money.from_amount(msrp_attributes[:base][:amount].to_f, msrp_attributes[:base][:currency]),
              label: msrp_attributes[:base][:label]
            }
          }
        }
      end

      def prices
        regular = pricing_attributes[:regular_price]
        sale    = pricing_attributes[:sale_price]

        price = {
          min_quantity: 1,
          regular: {
            price: Money.from_amount(regular[:amount].to_f, regular[:currency]),
            label: regular[:label],
            base_currency: {
              price: Money.from_amount(regular[:base][:amount].to_f, regular[:base][:currency]),
              label: regular[:base][:label]
            }
          }
        }

        if sale.present?
          price[:sale] = {
            price: Money.from_amount(sale[:amount].to_f, sale[:currency]),
            label: sale[:label],
            base_currency: {
              price: Money.from_amount(sale[:base][:amount].to_f, sale[:base][:currency]),
              label: sale[:base][:label]
            }
          }
        end

        [price]
      end
    end
  end
end
