namespace :workarea do
  namespace :flow_io do
    desc 'export products'
    task export_products: :environment do
      client = FlowCommerce.instance(token: Workarea::FlowIo.api_token)
      organization_id = Workarea::FlowIo.organization_id

      Workarea::Catalog::Product.all.each_by(100) do |product|
        product.variants.each do |variant|
          item = Workarea::FlowIo::Item.new(product, variant.sku)

          puts "Adding #{variant.sku}"
          client.items.put_by_number(organization_id, variant.sku, item.form)
        end
      end
    end

    desc 'create localization attributes'
    task create_localization_attributes: :environment do
      client = Workarea::FlowIo.client
      organization_id = Workarea::FlowIo.organization_id

      Workarea::FlowIo.config.localization_attributes.each do |localization_attribute|
        puts "Adding attribute #{localization_attribute[:label]}"
        client.attributes.put_by_key(
          organization_id,
          localization_attribute[:key],
          localization_attribute
        )
      end
    end

    desc 'delete items'
    task delete_products: :environment do
      client = FlowCommerce.instance(token: Workarea::FlowIo.api_token)
      organization_id = Workarea::FlowIo.organization_id

      Workarea::Catalog::Product.all.each_by(100) do |product|

        product.variants.each do |variant|
          client.items.delete_by_number(organization_id, variant.sku)
        end
      end
    end

    desc 'import local items'
    task import_local_items: :environment do
      organization = Workarea::FlowIo.organization_id
      experiences = Workarea::FlowIo.client.experiences.get(organization)

      experiences.each do |experience|
        next unless experience.status.value == "active"

        page_size  = 100
        offset     = 0
        items      = []

        while offset == 0 || items.length == 100
          # show current list size
          puts "\nGetting items: %s, rows %s - %s" % [experience.key, offset, offset + page_size]

          items = Workarea::FlowIo.client.experiences.get_items organization, experience: experience.key, limit: page_size, offset: offset
          offset += page_size

          items.each do |item|
            sku = item.number.downcase
            begin
              Workarea::Pricing::Sku.find(sku).import_flow_item(item)
            rescue Mongoid::Errors::DocumentNotFound => _error
              puts "Missing pricing sku: #{sku}"
            end
          end
        end
      end
    end
  end
end
