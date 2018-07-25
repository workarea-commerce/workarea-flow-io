require 'test_helper'

module Workarea
  module FlowIo
    class ItemTest < Workarea::TestCase
      def test_to_h
        item = Item.new(product, product.skus.first)

        assert_equal(expected_product_hash, item.to_h.except(:images))
      end

      private

        def product
          @product ||=
            begin
              prod = create_product(
                id: "EEC66E04BC",
                variants: [{
                  sku: 'SKU',
                  regular: 5.00,
                  details: { "Color" => "Red", "Size" => "X-Small" }
                }]
              )

              prod.variants.each do |variant|

                Shipping::Sku.create!(
                  id: variant.sku,
                  weight: 5,
                  dimensions: [1, 2, 3]
                )
              end

              create_category(product_ids: [prod.id])

              prod
            end
        end

        def expected_product_hash
          {
            number: "SKU",
            locale: "en_US",
            name: "Test Product",
            currency: "USD",
            price: 5.0,
            categories: ["Test Category"],
            attributes: {
              "product_id" => "EEC66E04BC",
              "Color" => "Red",
              "Size" => "X-Small",
              "regular_price" => "5.0",
              "fulfillment_method" => "physical"
            },
            dimensions: {
              packing: {
                depth: { value: 3, units: :inches },
                length: { value: 1, units: :inches },
                width: { value: 2, units: :inches },
                weight: { value: 5.0, units: :grams }
              }
            }
          }
        end
    end
  end
end
