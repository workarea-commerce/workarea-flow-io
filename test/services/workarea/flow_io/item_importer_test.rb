require 'test_helper'

module Workarea
  module FlowIo
    class ItemImporterTest < Workarea::TestCase
      def test_perform
        sku = create_pricing_sku(id: "772641894-X")
        ItemImporter.perform!(item)
        ItemImporter.perform!(item)

        sku.reload
        assert_equal(1, sku.flow_io_local_items.size)
        local_item = sku.flow_io_local_items.first
        assert_equal(1, local_item.prices.size)
      end

      def test_without_msrp
        sku = create_pricing_sku(id: "772641894-X")
        ItemImporter.perform!(item_without_msrp)

        sku.reload
        assert_equal(1, sku.flow_io_local_items.size)
        local_item = sku.flow_io_local_items.first
        assert_equal(1, local_item.prices.size)
      end

      def test_without_msrp
        sku = create_pricing_sku(id: "772641894-X")
        ItemImporter.perform!(item_without_sale_price)

        sku.reload
        assert_equal(1, sku.flow_io_local_items.size)
        local_item = sku.flow_io_local_items.first
        assert_equal(1, local_item.prices.size)
      end

      private

        def item
          ::Io::Flow::V0::Models::Item.new(
            id: "mit-e53e3b2beac74644a95569cea0dd17c8",
            number: "772641894-X",
            locale: "en_US",
            name: "Lightweight Paper Clock",
            price: {
              amount: 87.3,
              currency: "USD",
              label: "US$87.30"
            },
            categories: ["Bath", "Decor", "Bar", "Outdoor", "Bath Rugs", "Bath Towels", "Bathrobes and Slippers", "Office Furniture", "Office Lighting"],
            description: nil,
            attributes: {
              "msrp" => "97.3",
              "regular_price" => "87.3",
              "Material" => "Leather",
              "sale_price" => "85.3",
              "product_id" => "34ED240538",
              "Color" => "light_blue",
              "fulfillment_method" => "physical"
            },
            dimensions: {
              product: nil,
              packaging: nil
            },
            images: [
              {
                url: "https://plugins-qa.demo.workarea.com/product_images/lightweight-paper-clock/light_blue/5b203f44a0e1cd0f9bcfa7e7/small_thumb.jpg?c=1528840004",
                tags: ["thumbnail"]
              },
              {
                url: "https://plugins-qa.demo.workarea.com/product_images/lightweight-paper-clock/light_blue/5b203f44a0e1cd0f9bcfa7e7/medium_thumb.jpg?c=1528840004",
                tags: ["thumbnail"]
              },
              {
                url: "https://plugins-qa.demo.workarea.com/product_images/lightweight-paper-clock/light_blue/5b203f44a0e1cd0f9bcfa7e7/detail.jpg?c=1528840004",
                tags: ["checkout"]
              }
            ],
            local: {
              experience: {
                id: "exp-31b66afd8ac44a71a0669b2ad81a794d",
                key: "canada",
                name: "Canada",
                country: "CAN",
                currency: "CAD",
                language: "en"
              },
              prices: [
                {
                  currency: "CAD",
                  amount: 130,
                  label: "CA$130.00",
                  base: {
                    amount: 95.89,
                    currency: "USD",
                    label: "US$95.89"
                  },
                  includes: nil,
                  key: "localized_item_price"
                }
              ],
              rates: [],
              spot_rates: [],
              status: "included",
              attributes: {
                "msrp" => "140.0",
                "regular_price" => "130.0",
                "Material" => "Leather",
                "sale_price" => "130.0",
                "product_id" => "34ED240538",
                "Color" => "light_blue",
                "fulfillment_method" => "physical"
              },
              price_attributes: {
                "msrp" => {
                  currency: "CAD",
                  amount: 140,
                  label: "CA$140.00",
                  base: {
                    amount: 103.26,
                    currency: "USD",
                    label: "US$103.26"
                  }
                },
                "regular_price" => {
                  currency: "CAD",
                  amount: 130,
                  label: "CA$130.00",
                  base: {
                    amount: 95.89,
                    currency: "USD",
                    label: "US$95.89"
                  }
                },
                "sale_price" => {
                  currency: "CAD",
                  amount: 130,
                  label: "CA$130.00",
                  base: {
                    amount: 95.88,
                    currency: "USD",
                    label: "US$95.88"
                  }
                }
              }
            }
          )
        end

        def item_without_msrp
          ::Io::Flow::V0::Models::Item.new(
            id: "mit-e53e3b2beac74644a95569cea0dd17c8",
            number: "772641894-X",
            locale: "en_US",
            name: "Lightweight Paper Clock",
            price: {
              amount: 87.3,
              currency: "USD",
              label: "US$87.30"
            },
            categories: ["Bath", "Decor", "Bar", "Outdoor", "Bath Rugs", "Bath Towels", "Bathrobes and Slippers", "Office Furniture", "Office Lighting"],
            description: nil,
            attributes: {
              "regular_price" => "87.3",
              "Material" => "Leather",
              "sale_price" => "85.3",
              "product_id" => "34ED240538",
              "Color" => "light_blue",
              "fulfillment_method" => "physical"
            },
            dimensions: {
              product: nil,
              packaging: nil
            },
            images: [
              {
                url: "https://plugins-qa.demo.workarea.com/product_images/lightweight-paper-clock/light_blue/5b203f44a0e1cd0f9bcfa7e7/small_thumb.jpg?c=1528840004",
                tags: ["thumbnail"]
              },
              {
                url: "https://plugins-qa.demo.workarea.com/product_images/lightweight-paper-clock/light_blue/5b203f44a0e1cd0f9bcfa7e7/medium_thumb.jpg?c=1528840004",
                tags: ["thumbnail"]
              },
              {
                url: "https://plugins-qa.demo.workarea.com/product_images/lightweight-paper-clock/light_blue/5b203f44a0e1cd0f9bcfa7e7/detail.jpg?c=1528840004",
                tags: ["checkout"]
              }
            ],
            local: {
              experience: {
                id: "exp-31b66afd8ac44a71a0669b2ad81a794d",
                key: "canada",
                name: "Canada",
                country: "CAN",
                currency: "CAD",
                language: "en"
              },
              prices: [
                {
                  currency: "CAD",
                  amount: 130,
                  label: "CA$130.00",
                  base: {
                    amount: 95.89,
                    currency: "USD",
                    label: "US$95.89"
                  },
                  includes: nil,
                  key: "localized_item_price"
                }
              ],
              rates: [],
              spot_rates: [],
              status: "included",
              attributes: {
                "msrp" => "140.0",
                "regular_price" => "130.0",
                "Material" => "Leather",
                "sale_price" => "130.0",
                "product_id" => "34ED240538",
                "Color" => "light_blue",
                "fulfillment_method" => "physical"
              },
              price_attributes: {
                "regular_price" => {
                  currency: "CAD",
                  amount: 130,
                  label: "CA$130.00",
                  base: {
                    amount: 95.89,
                    currency: "USD",
                    label: "US$95.89"
                  }
                },
                "sale_price" => {
                  currency: "CAD",
                  amount: 130,
                  label: "CA$130.00",
                  base: {
                    amount: 95.88,
                    currency: "USD",
                    label: "US$95.88"
                  }
                }
              }
            }
          )
        end

        def item_without_sale_price
          ::Io::Flow::V0::Models::Item.new(
            id: "mit-e53e3b2beac74644a95569cea0dd17c8",
            number: "772641894-X",
            locale: "en_US",
            name: "Lightweight Paper Clock",
            price: {
              amount: 87.3,
              currency: "USD",
              label: "US$87.30"
            },
            categories: ["Bath", "Decor", "Bar", "Outdoor", "Bath Rugs", "Bath Towels", "Bathrobes and Slippers", "Office Furniture", "Office Lighting"],
            description: nil,
            attributes: {
              "regular_price" => "87.3",
              "Material" => "Leather",
              "sale_price" => "85.3",
              "product_id" => "34ED240538",
              "Color" => "light_blue",
              "fulfillment_method" => "physical"
            },
            dimensions: {
              product: nil,
              packaging: nil
            },
            images: [
              {
                url: "https://plugins-qa.demo.workarea.com/product_images/lightweight-paper-clock/light_blue/5b203f44a0e1cd0f9bcfa7e7/small_thumb.jpg?c=1528840004",
                tags: ["thumbnail"]
              },
              {
                url: "https://plugins-qa.demo.workarea.com/product_images/lightweight-paper-clock/light_blue/5b203f44a0e1cd0f9bcfa7e7/medium_thumb.jpg?c=1528840004",
                tags: ["thumbnail"]
              },
              {
                url: "https://plugins-qa.demo.workarea.com/product_images/lightweight-paper-clock/light_blue/5b203f44a0e1cd0f9bcfa7e7/detail.jpg?c=1528840004",
                tags: ["checkout"]
              }
            ],
            local: {
              experience: {
                id: "exp-31b66afd8ac44a71a0669b2ad81a794d",
                key: "canada",
                name: "Canada",
                country: "CAN",
                currency: "CAD",
                language: "en"
              },
              prices: [
                {
                  currency: "CAD",
                  amount: 130,
                  label: "CA$130.00",
                  base: {
                    amount: 95.89,
                    currency: "USD",
                    label: "US$95.89"
                  },
                  includes: nil,
                  key: "localized_item_price"
                }
              ],
              rates: [],
              spot_rates: [],
              status: "included",
              attributes: {
                "msrp" => "140.0",
                "regular_price" => "130.0",
                "Material" => "Leather",
                "sale_price" => "130.0",
                "product_id" => "34ED240538",
                "Color" => "light_blue",
                "fulfillment_method" => "physical"
              },
              price_attributes: {
                "regular_price" => {
                  currency: "CAD",
                  amount: 130,
                  label: "CA$130.00",
                  base: {
                    amount: 95.89,
                    currency: "USD",
                    label: "US$95.89"
                  }
                }
              }
            }
          )
        end

        def setup_sidekiq
          Sidekiq::Testing.fake!

          Sidekiq::Callbacks.async(Workarea::IndexSkus)
          Sidekiq::Callbacks.enable(Workarea::IndexSkus)
          Sidekiq::Callbacks.async(Workarea::FlowIo::ItemExporter)
          Sidekiq::Callbacks.enable(Workarea::FlowIo::ItemExporter)

          Workarea::IndexSkus.clear
          Workarea::FlowIo::ItemExporter.clear
        end

        def teardown_sidekiq
          Sidekiq::Testing.inline!
        end
    end
  end
end
