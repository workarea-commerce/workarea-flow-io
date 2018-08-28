Workarea::Storefront::Engine.routes.draw do
  post :flow_webhook, as: :flow_io_webhook, controller: 'flow_io_webhook', action: 'event'
end

Workarea::Admin::Engine.routes.draw do
  resources :orders, only: [] do
    member do
      get :flow
    end
  end
end
