module Workarea
  module FlowIo
    class Item
      include ActionView::Helpers::AssetUrlHelper
      include Core::Engine.routes.url_helpers
      include Workarea::ApplicationHelper

      attr_reader :product, :sku
      delegate :name, :description, to: :product

      def initialize(product, sku)
        @product = product
        @sku = sku
      end

      def form
        ::Io::Flow::V0::Models::ItemForm.new(self.to_h)
      end

      def to_h
        {
          number:     sku,
          locale:     FlowIo.config.original_locale,
          name:       name,
          currency:   pricing_sku.sell_price.currency.iso_code,
          price:      price,
          categories: categories,
          attributes: attributes,
          dimensions: dimensions,
          images:     images
        }
      end

      private

      def variant
        @variant ||= product.variants.find_by(sku: sku)
      end

      def shipping_sku
        @shipping_sku ||= Shipping::Sku.find(sku) rescue nil
      end

      def pricing_sku
        @pricing_sku ||= Pricing::Sku.find(sku) rescue Pricing::Sku.new(id: sku)
      end

      def price
        pricing_sku.sell_price.dollars.to_f
      end

      def categories
        @categories ||= Categorization.new(product).to_models.map(&:name)
      end

      def attributes
        variant_attributes.merge(
          "product_id" => product.id,
          "msrp" => pricing_sku.msrp&.dollars&.to_f,
          "regular_price" => sku_price.regular.dollars.to_f,
          "sale_price" => sku_price.sale&.dollars&.to_f,
          "fulfillment_method" => product.digital ? "digital" : "physical"
        ).compact.map { |k, v| [k, v.to_s] }.to_h
      end

      def dimensions
        return unless shipping_sku.present?

        spatial_dimensions =
          if shipping_sku.dimensions.present?
            {
              depth:  { value: shipping_sku.height, units: shipping_sku.length_units },
              length: { value: shipping_sku.length, units: shipping_sku.length_units },
              width:  { value: shipping_sku.width,  units: shipping_sku.length_units },
            }
          else
            {}
          end

        weight =
          if shipping_sku.weight.present?
            { weight: { value: shipping_sku.weight, units: shipping_sku.weight_units } }
          else
            {}
          end

        { packing: spatial_dimensions.merge(weight) }
      end

      def variant_specific_images
        @variant_specific_images ||=
          begin
            sku_options = variant.details.values.flat_map { |options| options.map(&:optionize) }

            product.images.select do |image|
              sku_options.include?(image.option.optionize)
            end
          end
      end

      def images
        @images ||= (variant_specific_images || [product.images.first]).flat_map do |image|
          FlowIo.image_sizes.map do |processor, tags|
            { url: product_image_url(image, processor), tags: tags }
          end
        end
      end

      private

        def sku_price
          @sku_price ||= pricing_sku.find_price(quantity: 1)
        end

        def variant_attributes
          variant.details.map { |k, v| [k, v.join(', ')] }.to_h
        end

        def mounted_core
          self
        end
    end
  end
end
