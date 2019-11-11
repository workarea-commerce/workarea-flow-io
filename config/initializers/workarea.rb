Workarea.configure do |config|
  config.cache_expirations.flow_io_country_cache = 1.hour

  config.flow_io ||= ActiveSupport::Configurable::Configuration.new

  # Enable JS integration for real-time price updates. Defaults to
  # `false`.
  config.flow_io.enable_javascript = false

  # default payment action. FlowIO recomends purchase (auth/cap)
  config.flow_io.default_payment_action = "purchase"

  # default timeout on flow api calls
  config.flow_io.default_timeout = 2

  # hash of processor to image tags for flow
  # see https://docs.flow.io/type/image-tag
  config.flow_io.image_sizes = {
    small_thumb: ["thumbnail"],
    medium_thumb: ["checkout"],
  }

  # URI that flow checkouts will be redirected to.
  # Exclude the trailing slash.
  config.flow_io.checkout_uri = "https://checkout.flow.io"

  config.tender_types.prepend(:flow_payment)

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

  config.pricing_calculators << "Workarea::Pricing::Calculators::FlowLocalizationCalculator"

  config.flow_io.webhook_events = [
    "order_upserted_v2",
    "experience_deleted_v2",
    "experience_upserted_v2"
  ]

  config.run_credit_card_refund_tests = true
end
