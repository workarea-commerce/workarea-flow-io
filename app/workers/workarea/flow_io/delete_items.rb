module Workarea
  module FlowIo
    class DeleteItems
      include Sidekiq::Worker
      include Sidekiq::CallbacksWorker

      sidekiq_options(
        enqueue_on: {
          Catalog::Product => :destroy,
          Pricing::Sku => :destroy,
          with: -> do
            if self.class.name == "Workarea::Catalog::Product"
              [self.skus]
            else
              [[id]]
            end
          end
        }
      )

      def perform(skus)
        client = FlowIo.client

        skus.each do |sku|
          client.items.delete_by_number(Workarea::FlowIo.organization_id, sku)
        end
      end
    end
  end
end
