Workarea.append_javascripts(
  'storefront.modules',
  'workarea/storefront/flow_io/flow_country_picker'
)

Workarea.append_partials(
  'storefront.document_head',
  'workarea/storefront/flow_beacon'
)

Workarea.append_partials(
  'storefront.footer_help',
  'workarea/storefront/flow_io_country_picker'
)

Workarea::Plugin.append_stylesheets(
  'storefront.components',
  'flow_io/storefront/country_picker'
)
