require 'test_helper'

module Workarea
  module FlowIo
    class ItemExporterTest < Workarea::TestCase
      include Workers

      def test_exporting_from_product_save
        Sidekiq::Callbacks.enable(FlowIo::ItemExporter) do
          BogusClient::Items.any_instance.expects(:put_by_number).times(3)

          create_product(
            variants: [
              { sku: 'SKU1', regular: 5.00 },
              { sku: 'SKU2', regular: 5.00 },
            ]
          )
          Pricing::Sku.find("SKU2").tap do |sku|
            sku.prices.first.regular = 6.00
            sku.save
          end
        end
      end

      def test_exporting_from_updating_price
        create_product(
          variants: [
            { sku: 'SKU1', regular: 5.00 }
          ]
        )
        pricing_sku = Pricing::Sku.find('SKU1')
        price = pricing_sku.prices.first

        Sidekiq::Callbacks.enable(FlowIo::ItemExporter) do
          BogusClient::Items.any_instance.expects(:put_by_number).times(1)

          price.update_attributes(
            regular: 0.44,
            sale: 0.30,
            min_quantity: 1,
            active: true
          )
        end
      end
    end
  end
end
