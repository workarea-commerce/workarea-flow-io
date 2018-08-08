module Workarea
  module FlowIo
    class ItemExporter
      include Sidekiq::Worker
      include Sidekiq::CallbacksWorker

      sidekiq_options(
        enqueue_on: {
          Catalog::Product => :save,
          Shipping::Sku => :save,
          Pricing::Sku => :save,
          Pricing::Price => :save,
          with: -> { ItemExporter.perform_with(self) }
        }
      )

      def self.perform_with(model)
        case model.class.name
        when "Workarea::Pricing::Price"
          [model.sku.class.name, model.sku.id]
        else
          [model.class.name, model.id]
        end
      end

      def perform(class_name, id)
        product, skus =
          if class_name == "Workarea::Catalog::Product"
            prod = Catalog::Product.find(id)
            [prod, prod.skus]
          else
            [Catalog::Product.find_by_sku(id), [id]]
          end

        return unless product.present?

        client = FlowIo.client
        organization_id = Workarea::FlowIo.organization_id

        skus.each do |sku|
          item = Workarea::FlowIo::Item.new(product, sku)
          client.items.put_by_number(organization_id, sku, item.form)
        end
      end
    end
  end
end
