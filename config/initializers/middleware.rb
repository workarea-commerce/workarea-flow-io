if Rails.application.config.action_dispatch.rack_cache
  Rails.application.config.middleware.insert_before(
    Rack::Cache,
    Workarea::FlowIo::SessionMiddleware
  )
else
  Rails.application.config.middleware.insert_before(
    Rack::Head,
    Workarea::FlowIo::SessionMiddleware
  )
end
