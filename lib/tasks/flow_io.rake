namespace :workarea do
  namespace :flow_io do
    desc 'export products'
    task export_products: :environment do
      puts "Exporting products..."
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
      puts "Creating localization attributes..."
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

    desc 'create webhooks'
    task create_webhooks: :environment do
      puts "Creating webhooks..."
      unless Workarea::FlowIo.webhook_shared_secret.present?
        warn <<~eos
          **************************************************
          ⛔️ Webhooks require flow_io.webhook_shared_secret to be set in your credentials/secrets
          **************************************************
        eos
        next
      end

      client = Workarea::FlowIo.client
      organization_id = Workarea::FlowIo.organization_id
      host = Workarea.config.host

      webhook_url = Workarea::Storefront::Engine
        .routes
        .url_helpers
        .flow_io_webhook_url(host: host, protocol: "https")

      client.webhooks.post(
        organization_id,
        Io::Flow::V0::Models::WebhookForm.new(
          events: Workarea::FlowIo.config.webhook_events,
          url: webhook_url
        )
      )
    end

    desc 'Initialize Flow Plugin'
    task install: :environment do
      Rake::Task['workarea:flow_io:create_localization_attributes'].execute
      Rake::Task['workarea:flow_io:create_webhooks'].execute
      Rake::Task['workarea:flow_io:export_products'].execute
    end

    desc 'Delete items'
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
            puts item.number
            begin
              Workarea::FlowIo::ItemImporter.perform!(item)
            rescue Mongoid::Errors::DocumentNotFound => _error
              puts "Missing pricing sku: #{item.number}"
            end
          end
        end
      end
    end
  end
end
