# Workarea Flow Io

[Flow](https://flow.io) is an international checkout solution.  Clients set up
an "experience" in Flow that targets specific currencies or regions.  A
customer is geolocated using a javascript call, or they can opt to change
their shipping country via a javascript widget.  Customers checking out
in foreign currencies get redirected to Flow's hosted checkout solution.

## Installation

To install Flow, add it to your Gemfile:

```ruby
gem 'workarea-flow_io'
```

...and run `bundle install`!

Next, configure your credentials in **config/secrets.yml**, as shown here:

```yaml
flow_io:
  # get your API token from https://console.flow.io
  # under 'Organization Settings > Integrations"
  api_token:
  organization_id:
  # the following credentials are provided by flow.io representatives..
  ftp_username:
  ftp_password:
```

Finally, run the generator to set up Flow for use with your application:

    rails workarea:flow_io:install

This task creates localization attributes, webhooks, and exports products
to Flow for later use, which are broken out into the following Rake
tasks (run in the same order):

    workarea:flow_io:create_localization_attributes
    workarea:flow_io:create_webhooks
    workarea:flow_io:export_products

Now you're ready to Let It Flow!

## Configuration

Flow is configured using your `Workarea.config`, much like most of our
other plugins. Many of these settings have defaults provided out of the
box. The above steps in "Installation" should be the bare minimum you
need to get the plugin working.

### JavaScript Integration

`Workarea::FlowIo` can optionally use [FlowJS](https://docs-beta.flow.io/docs/flowjs)
as an additional layer of real-time pricing updates, or as the primary
means by which "global" experience customers with no pre-defined
experience can view localized prices. It is off by default, but can be
enabled by setting the following in an initializer:

```ruby
Workarea.configure do |config|
  config.flow_io.enable_javascript = true
end
```

### Localization Attributes

The plugin provides localization attributes for: `original_price`,
`sale_price`, `msrp`, `product_id` and `digital` These correspond to
values of the `attributes` when exporting an item to flow, and they come back
in the `local_item_pricing` `attributes` field.  Other fields include
`gtin`, `brand`, and `hazardous`. For more information, visit
https://docs.flow.io/module/localization/resource/attributes and
https://docs.flow.io/type/attribute-form

### Checkout

All international orders will be routed to a Flow.io hosted checkout
page. By default the order confirmation page will be hosted with Flow.io as
well.

Customers will be redirected to the default Flow.io checkout url.
However, most clients will choose to redirect to a subdomain.  The
redirect domain is controlled via the following config:


```ruby
Workarea.configure do |config|
  config.flow_io.checkout_uri = 'https://checkout.flow.io'
end
```

## Under The Hood

This section explains a bit about how Flow integrates their pricing
model into your Workarea store.

### Item Exporting / Importing

A callbacks worker gets enqueued when `Catalog::Product`, `Shipping::Sku`,
`Pricing::Sku`, or `Pricing::Price` are saved.  Depending on the number of
skus changed, the worker will export the affected items to Flow.  Flow
will then create Local Items to represent those skus in each experience,
and push those prices back to Workarea in a flat file sent over SFTP.
The plugin embeds those local items on the `Pricing::Sku` for display.
The base price of a localized price will not necessarily be the same.
After the initial price is converted into the localized currency,
rounding and margin rules are applied and then it is converted back into
the default currency as the base price.

### Order Pricing

When a customer is transacting in a currency other than the default
currency, two sets of `PriceAdjustment`s are in effect.  The standard
`#price_adjustments` on `Order::Item` and `Shipping` are used to track
pricing in the sites default currency while `#flow_price_adjustments`
will store pricing the customer transacted in.

### Checkout Flow

A new pricing calculator is added, `FlowLocalizationCalculator` and
appended to the END of the pricing calculators array; it is important
that if a build adds custom calculators that the
`FlowLocalizationCalculator` is last.  This calculator sends the order
to flow and updates the `Order::Item` and `Shipping` `#price_adjutments`
with localized prices and updated base prices.  Because of the way
discounting is passed to flow, discounts are displaying as a generic
Discount adjustment, instead of an adjustment for each discount.
Display will still happen at the order or item level depending on how
the initial discount price adjutments were created.

A `before_action` in `Storefront::CheckoutsController` will send
customers to Flow's hosted checkout if they are checking out in a Flow
`Experience`.  After the customer completes the order in hosted
checkout.  Flow will send an `OrderUpsertedV2` webhook with a
`#submitted_at` value.  The `Workarea::Order` will be updated and marked
as placed.

When `Fulfillment::Item`s are shipped or canceled in Workarea, workers
will update Flow with `ShippingNotifications` or
`FulfillmentCancellations`.

### Session

A piece of middleware sits in front of `Rack::Cache` that will upsert a
`Session` in Flow if the `_f60_session` cookie is blank, passing the
`request.remote_ip` and `HTTP_GEOIP_CITY_COUNTRY_CODE3` from Nginx.  If
the `_f60_session` cookie is present and the `flow_experience` cookie
isn't a request will be made to get the session from the Flow API.  If
the API request 404s, a new session will be created and the
`_f60_session` cookie will be updated.  It updates HTTP's `Vary` header
to include `X-Flow-Experience` and stores the current `Experience` in
the `flow_experience` cookie as JSON.  If a user updates their country
via the `country_picker.js`, the `flow_experience` cookie is updated in
the `onSessionUpdate` in javascript.

### Caching

Cache keys are decorated to include the current `Experience` key.  The
Http Vary header is adjusted to include `X-Flow-Experience`  The current
country ISO-3166-3 code is added to the `locale` as an added measure
agaisnt browser caching and the etag is updated to include the
`Experience` key.

## Client Considerations

It's assumed that Flow will be the payment processor for foreign orders,
and that Flow will `purchase` those funds. 3PL(Third Party Logistics)
will need to be discussed between the client and Flow for foreign orders.

## Incompatibilities and Gotchas

When using this plugin with Gift Cards, make sure `flow_io` appears
after `gift_cards` in your Gemfile, like so:

```ruby
gem 'workarea-gift_cards'
gem 'workarea-flow_io'
```

## Contributing

Do you have a feature request, documentation update, bug report, or any
kind of feedback about this plugin? [Create a new issue](https://github.com/workarea-commerce/workarea-flow-io/issues/new/choose)
and tell us all about it!

If you have some code you'd like to contribute to `Workarea::FlowIo`,
make sure tests pass locally by running:

```bash
rails test                        # runs tests local to the plugin
rails app:workarea:test:decorated # runs decorated tests
```

Then, fork this repo and submit a pull request!

## License

`Workarea::FlowIo` is released under the [Business Software License](LICENSE)
