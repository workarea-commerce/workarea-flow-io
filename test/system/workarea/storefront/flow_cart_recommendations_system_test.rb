require 'test_helper'

module Workare
  module Storefront
    class FlowCartRecommendationsSystemTest < Workarea::SystemTest
      setup :set_product
      setup :set_recommendation

      def test_showing_recommendations
        visit storefront.product_path(@product)
        select @product.skus.first, from: 'sku'
        click_button t('workarea.storefront.products.add_to_cart')
        click_link t('workarea.storefront.carts.view_cart')

        visit storefront.cart_path

        assert_text(@product.name)
        assert_text('Recommendation Product')
        assert_text("Total $5")
      end

      private

        def set_product
          @product =
            begin
              prod = create_product(
                name: 'Integration Product',
                variants: [
                  { name: 'SKU1', sku: 'SKU1', regular: 5.to_m },
                  { name: 'SKU2', sku: 'SKU2', regular: 6.to_m }
                ]
              )
              ['SKU1', 'SKU2'].each do |sku|
                Workarea::Pricing::Sku.find(sku).tap do |pricing|
                  pricing.flow_io_local_items << build_flow_io_local_item
                  pricing.save!
                end
              end

              prod
            end
        end

        def set_recommendation
          @recommendation = create_product(
            name: 'Recommendation Product',
            variants: [{ sku: 'SKU3', regular: 5.to_m }]
          )

          Workarea::Pricing::Sku.find('SKU3').tap do |pricing|
            pricing.flow_io_local_items << build_flow_io_local_item
            pricing.save!
          end

          create_inventory(id: 'SKU1', policy: 'standard', available: 2)
          create_inventory(id: 'SKU2', policy: 'standard', available: 2)
          create_inventory(id: 'SKU3', policy: 'standard', available: 2)

          create_recommendations(
            id: @product.id,
            product_ids: [@recommendation.id]
          )
        end
    end
  end
end
