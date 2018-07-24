module Workarea
  module FlowIo
    class Webhook::LocalItemUpserted < Webhook
      def process
        sku = event.local_item.item.number
        Pricing::Sku.find(sku).import_flow_local_item(event.local_item)
      end
    end
  end
end
