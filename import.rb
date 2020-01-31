sku = Workarea::Pricing::Sku.find('879376761-7')
row = {
  'experience[key]' => 'canada',
  'item[number]' => sku.id,
  'prices[price_attributes][regular_price][amount]' => 10,
  'prices[price_attributes][regular_price][currency]' => 'CAD',
  'prices[price_attributes][regular_price][label]' => 'Regular',
  'prices[price_attributes][regular_price][base][amount]' => 8,
  'prices[price_attributes][regular_price][base][currency]' => 'USD',
  'prices[price_attributes][regular_price][label]' => 'Regular'
}
experiences = Workarea::FlowIo.client.experiences.get(
  Workarea::FlowIo.organization_id
)

Workarea::FlowIo::ImportedItem.process(row, experiences)
