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
    end
  end
end
