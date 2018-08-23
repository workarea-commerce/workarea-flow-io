 Workarea Flow Io
================================================================================

Flow Io is an international checkout solution.  Clients set up `Experience`s in Flow that target specific currencies
or regions.  A customer is geolocated using a javascript call, or can opt to change their shipping country via a javascript widget.
Customers checking out in foreign currencies get redirected to Flow's hosted checkout solution.

Secrets
--------------------------------------------------------------------------------
    flow_io:
      api_token:
      organziation_id:
      webhook_shared_secret:

Configuration
--------------------------------------------------------------------------------

### Localization Attributes

The plugin provides localization attributes for: `original_price`, `sale_price`, `msrp`, `product_id` and `digital`
These correspond to values of the `attributes` when exporting an item to flow and come back in the `local_item_pricing` `attributes` field.
Other fields include `gtin`, `brand`, `hazardous` see https://docs.flow.io/module/localization/resource/attributes and
https://docs.flow.io/type/attribute-form

### Checkout

All international orders will be routed to a Flow.io hosted checkout page. By default the order confirmation page will hosted with Flow.io as well.

By default all US orders are considered domestic and will go through the normal Workarea checkout.
This can be modified by changing this config value:

    config.flow_io.domestic_order_origins = ['USA']


Customers will be redirected to the default Flow.io checkout url. However, most clients will choose to redirect to a subdomain.
The redirect domain is controlled via the following config:

    config.flow_io.checkout_uri = "https://checkout.flow.io"

## Installation

    bundle exec rake workarea:flow_io:create_localization_attributes

This rake task will just run the following rake tasks in order:

    workarea:flow_io:create_localization_attributes
    workarea:flow_io:create_webhooks
    workarea:flow_io:export_products

## Flow under the hood
### Item Exporting / Importing
A callbacks worker gets enqueued on 'Catalog::Product', `Shipping::Sku`, `Pricing::Sku`, and `Pricing::Price` save.  Depending on the number
of skus changed, the worker will export the affected items to Flow.  Flow will then create Local Items to represent those skus in each experiece,
and push those prices back to Workarea.  The plugin embeds those local items on the `Pricing::Sku` for display.  The base price of a localized
price will not necessarily be the same.  After the initial price is converted into the localized currency, rounding and margin rules are applied
and then it is converted back into the default currency as the base price.

### Order Pricing
When a customer is transacting in a currency other than the default currency, two sets
of `PriceAdjutment`s are in effect.  The standard `#price_adjutments` on `Order::Item` and
`Shipping` are used to track pricing in the sites default currency while `#flow_price_adjustments`
will store pricing the customer transacted in.

### Checkout Flow
A new pricing calculator is added, `FlowLocalizationCalculator` and appended to the END of the
pricing calculators array; it is important that if a build adds custom calculators that the
`FlowLocalizationCalculator` is last.  This calculator sends the order to flow and updates the
`Order::Item` and `Shipping` `#price_adjutments` with localized prices and updated base prices.
Because of the way discounting is passed to flow, discounts are displaying as a generic Discount
adjustment, instead of an adjustment for each discount.  Display will still happen at the order or item
level depending on how the initial discount price adjutments were created.

A `before_action` in `Storefront::CheckoutsController` will send customers to Flow's hosted checkout
if they are checking out in a Flow `Experience`.  After the customer completes the order in hosted
checkout.  Flow will send an `OrderUpsertedV2` webhook with a `#submitted_at` value.  The `Workarea::Order`
will be updated and marked as placed.

When `Fulfillment::Item`s are shipped or cancaled in Workarea, workers will update Flow with
`ShippingNotifications` or `FulfillmentCancellations`

Workarea Platform Documentation
--------------------------------------------------------------------------------

See [http://developer.weblinc.com](http://developer.weblinc.com) for Workarea platform documentation.

Copyright & Licensing
--------------------------------------------------------------------------------

Copyright WebLinc 2018. All rights reserved.

For licensing, contact sales@workarea.com.
