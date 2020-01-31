sku = Workarea::Pricing::Sku.find('879376761-7')
row = {
  experience: { key: 'canada' },
  item: { number: sku.id }
}
experiences = Workarea::FlowIo.client.experiences.get(
  Workarea::FlowIo.organization_id
)

Workarea::FlowIo::ImportedItem.process(row, experiences)
