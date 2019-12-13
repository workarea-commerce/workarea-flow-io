Workarea::Storefront::Engine.routes.draw do
  post :flow_webhook, as: :flow_io_webhook, controller: 'flow_io_webhook', action: 'event'
end

Workarea::Admin::Engine.routes.draw do
  scope '(:locale)', constraints: Workarea::I18n.routes_constraint do
    resources :flow_imports, only: :index

    resources :orders, only: [] do
      member do
        get :flow
      end
    end

    resources :pricing_skus, only: [] do
      member do
        get :flow
      end
    end
  end
end
