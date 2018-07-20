require 'test_helper'

module Workarea
  module FlowIo
    class DeleteItemsTest < Workarea::TestCase
      include Workers

      def test_deleting_product
        Sidekiq::Callbacks.enable(FlowIo::DeleteItems) do
          product = create_product(
            variants: [
              { sku: 'SKU1', regular: 5.00 },
              { sku: 'SKU2', regular: 5.00 },
            ]
          )

          BogusClient::Items.any_instance.expects(:delete_by_number).times(2)
          product.destroy
        end
      end

      def test_deleting_rpcing_sku
        Sidekiq::Callbacks.enable(FlowIo::DeleteItems) do
          create_product(
            variants: [
              { sku: 'SKU1', regular: 5.00 },
              { sku: 'SKU2', regular: 5.00 },
            ]
          )

          BogusClient::Items.any_instance.expects(:delete_by_number).times(1)
          Pricing::Sku.find("SKU1").destroy
        end
      end
    end
  end
end
