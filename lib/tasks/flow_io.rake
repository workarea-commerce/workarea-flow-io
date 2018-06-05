namespace :workarea do
  namespace :flow_io do
    desc 'export products'
    task export_products: :environment do
      Workarea::Catalog::Product.all.each_by(100) do |product|
        client = FlowCommerce.instance(token: Workarea::FlowIo.api_token)
        organization_id = Workarea::FlowIo.organization_id

        product.variants.each do |variant|
          item = Workarea::FlowIo::Item.new(product, variant.sku)

          puts "adding #{variant.sku}"
          client.items.put_by_number(organization_id, variant.sku, item.form)
        end
      end
    end
  end
end
