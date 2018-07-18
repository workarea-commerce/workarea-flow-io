Workarea.configure do |config|
  config.flow_io ||= ActiveSupport::Configurable::Configuration.new

  config.flow_io.image_sizes = [:small_thumb, :detail]

  # The countries that will be considered domestic
  # countries not in array will be sent to a
  # flow.io hosted checkout.
  config.flow_io.domestic_order_origins = [Country[:us]]

  # URI that flow checkouts will be redirected to.
  # Exclude the trailing slash.
  config.flow_io.checkout_uri = "https://checkout.flow.io"

  # The locale in which the content of the catalog is written.
  config.flow_io.original_locale = "en_US"

  config.flow_io.localization_attributes = [
    {
      key: 'regular_price',
      options: {
        required: true,
        show_in_catalog: true,
        show_in_harmonization: true
      },
      label: 'Regular Price',
      intent: 'price',
      type: 'decimal'
    },
    {
      key: 'sale_price',
      options: {
        required: false,
        show_in_catalog: true,
        show_in_harmonization: true
      },
      label: 'Sale Price',
      intent: 'price',
      type: 'decimal'
    },
    {
      key: 'msrp',
      options: {
        required: false,
        show_in_catalog: true,
        show_in_harmonization: true
      },
      label: 'MSRP',
      intent: 'price',
      type: 'decimal'
    },
    {
      key: 'product_id',
      options: {
        required: true,
        show_in_catalog: true,
        show_in_harmonization: false
      },
      label: 'Product ID',
      intent: 'product_id',
      type: 'string'
    },
    {
      key: 'fulfillment_method',
      options: {
        required: false,
        show_in_catalog: true,
        show_in_harmonization: false
      },
      label: 'Fulfillment Method',
      intent: 'fulfillment_method',
      type: 'String'
    }
  ]
end
