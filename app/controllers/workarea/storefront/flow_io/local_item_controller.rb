module Workarea
  module Storefront
    class FlowIoLocalItemController < FlowIoWebhookController
      def upserted
        local_item_upserted = Io::Flow::V0::Models::LocalItemUpserted.new(params.to_unsafe_hash)
        sku = local_item_upserted.local_item.item.number
        Pricing::Sku.find(sku).import_flow_local_item(local_item_upserted.local_item)

        successful_response
      end
    end
  end
end
