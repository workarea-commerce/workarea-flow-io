module Workarea
  module FlowIo
    # Represents a local item imported by the CSV importer.
    class ImportedItem
      attr_reader :params

      def initialize(row)
        # HACK needed to parse params with keys like
        # `parent[child][param]`, since that's what they come in
        # as from the CSV.
        @params = Rack::Utils.default_query_parser
                             .parse_nested_query(row.to_h.to_query)
                             .deep_symbolize_keys
      end

      def self.process(row)
        new(row).tap(&:save!)
      end

      def save!
        if item.experience.new_record?
          item.experience.name ||= params[:experience][:key].titleize
          item.save!
        end

        params[:prices].each do |name, attrs|
          import_price(name, attrs) unless attrs[:amount].blank?
        end

        sku.save!
      end

      private

      def import_price(name, attrs)
        price = item.prices.find_or_initialize_by(
          regular: {
            label: attrs[:label]
          }
        )
        regular = price.regular || price.build_regular
        regular.label ||= attrs[:label]

        if attrs[:amount].present? && attrs[:currency].present?
          regular.price = attrs[:amount].to_m(attrs[:currency])
        end

        regular.save!
      end

      def sku
        @sku ||= Pricing::Sku.find_or_create_by!(
          _id: params[:item][:number]
        )
      end

      def item
        @item ||= sku.flow_io_local_items.find_or_initialize_by(
          experience: params[:experience]
        )
      end
    end
  end
end
