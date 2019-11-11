require 'test_helper'

module Workarea
  module FlowIo
    class ImportedItemTest < TestCase
      def test_import_from_params
        assert_difference -> { Pricing::Sku.count } do
          imported = ImportedItem.process(
            'experience[key]' => 'angola',
            'item[number]' => '607508142-9',
            'prices[item][amount]' => 19845.0,
            'prices[item][base][amount]' => 41.38,
            'prices[item][base][currency]' => 'USD',
            'prices[item][base][label]' => 'US$41.38',
            'prices[item][currency]' => 'AOA',
            'prices[item][label]' => '19 845,00 AOA',
          )
          sku = Pricing::Sku.find('607508142-9')
          local_item = sku.flow_io_local_items.last
          regular = local_item.prices.first.regular

          assert_equal(sku, imported.send(:sku))
          assert_equal(local_item, imported.send(:item))
          assert_equal(19845.to_m('AOA'), regular.price)
        end
      end
    end
  end
end
