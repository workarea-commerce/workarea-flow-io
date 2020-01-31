require 'test_helper'

module Workarea
  module FlowIo
    class ImportedItemTest < TestCase
      def test_import_from_params
        assert_difference -> { Pricing::Sku.count } do
          ImportedItem.process(
            {
              'experience[key]' => 'canada',
              'item[number]' => '607508142-9',
              'prices[item][amount]' => '20.0',
              'prices[item][base][amount]' => '14.6',
              'prices[item][base][currency]' => 'USD',
              'prices[item][base][label]' => 'US$14.60',
              'prices[item][currency]' => 'CAD',
              'prices[item][includes][key]' => 'none',
              'prices[item][includes][label]' => 'HST and duty not included',
              'prices[item][label]' => 'CA$20.00',
              'prices[price_attributes][msrp][amount]' => '30.0',
              'prices[price_attributes][msrp][base][amount]' => '21.9',
              'prices[price_attributes][msrp][base][currency]' => 'USD',
              'prices[price_attributes][msrp][base][label]' => 'US$21.90',
              'prices[price_attributes][msrp][currency]' => 'CAD',
              'prices[price_attributes][msrp][label]' => 'CA$30.00',
              'prices[price_attributes][regular_price][amount]' => '20.0',
              'prices[price_attributes][regular_price][base][amount]' => '14.6',
              'prices[price_attributes][regular_price][base][currency]' => 'USD',
              'prices[price_attributes][regular_price][base][label]' => 'US$14.60',
              'prices[price_attributes][regular_price][currency]' => 'CAD',
              'prices[price_attributes][regular_price][label]' => 'CA$20.00',
              'prices[price_attributes][sale_price][amount]' => '10.0',
              'prices[price_attributes][sale_price][base][amount]' => '7.3',
              'prices[price_attributes][sale_price][base][currency]' => 'USD',
              'prices[price_attributes][sale_price][base][label]' => 'US$7.30',
              'prices[price_attributes][sale_price][currency]' => 'CAD',
              'prices[price_attributes][sale_price][label]' => 'CA$10.00',
            },
            FlowIo.client.experiences.get(FlowIo.organization_id)
          )

          sku = Pricing::Sku.find('607508142-9')
          local_item = sku.flow_io_local_items.last
          regular = local_item.prices.first.regular

          assert_equal(20.to_m('CAD'), regular.price)
        end
      end

      def test_import_with_blank_amount_or_currency
        assert_difference -> { Pricing::Sku.count } do
          ImportedItem.process(
            {
              'experience[key]' => 'canada',
              'item[number]' => '607508142-9',
              'prices[item][amount]' => '20.0',
              'prices[item][base][amount]' => '14.6',
              'prices[item][base][currency]' => 'USD',
              'prices[item][base][label]' => 'US$14.60',
              'prices[item][currency]' => 'CAD',
              'prices[item][includes][key]' => 'none',
              'prices[item][includes][label]' => 'HST and duty not included',
              'prices[item][label]' => 'CA$20.00',
              'prices[price_attributes][msrp][amount]' => '30.0',
              'prices[price_attributes][msrp][base][amount]' => '21.9',
              'prices[price_attributes][msrp][base][currency]' => 'USD',
              'prices[price_attributes][msrp][base][label]' => 'US$21.90',
              'prices[price_attributes][msrp][currency]' => 'CAD',
              'prices[price_attributes][msrp][label]' => 'CA$30.00',
              'prices[price_attributes][regular_price][amount]' => '',
              'prices[price_attributes][regular_price][base][amount]' => '14.6',
              'prices[price_attributes][regular_price][base][currency]' => 'USD',
              'prices[price_attributes][regular_price][base][label]' => 'US$14.60',
              'prices[price_attributes][regular_price][currency]' => '',
              'prices[price_attributes][regular_price][label]' => 'CA$20.00',
              'prices[price_attributes][sale_price][amount]' => '10.0',
              'prices[price_attributes][sale_price][base][amount]' => '7.3',
              'prices[price_attributes][sale_price][base][currency]' => 'USD',
              'prices[price_attributes][sale_price][base][label]' => 'US$7.30',
              'prices[price_attributes][sale_price][currency]' => 'CAD',
              'prices[price_attributes][sale_price][label]' => 'CA$10.00',
            },
            FlowIo.client.experiences.get(FlowIo.organization_id)
          )

          sku = Pricing::Sku.find('607508142-9')
          local_item = sku.flow_io_local_items.last

          assert_empty(local_item.prices)
        end
      end
    end
  end
end
