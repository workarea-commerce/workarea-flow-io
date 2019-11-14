Workarea.append_javascripts(
  'storefront.modules',
  'workarea/storefront/flow_io/flow'
)

Workarea.append_javascripts(
  'storefront.config',
  'workarea/storefront/flow_io/configuration'
)

Workarea.append_partials(
  'storefront.footer_help',
  'workarea/storefront/flow_io_country_picker'
)

Workarea.append_partials(
  'admin.order_cards',
  'workarea/admin/orders/flow'
)

Workarea.append_partials(
  'admin.order_show_workflow_bar_left',
  'workarea/admin/orders/flow_aux_navigation'
)

Workarea::Plugin.append_stylesheets(
  'storefront.components',
  'flow_io/storefront/country_picker'
)
