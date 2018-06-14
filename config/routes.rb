Workarea::Storefront::Engine.routes.draw do
  post :local_item, as: :flow_io_local_item, controller: 'flow_io_local_item', action: 'upserted'
end
