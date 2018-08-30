 Workarea Flow Io
================================================================================

Flow Io plugin for the Workarea platform.

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

Checkout
--------------------------------------------------------------------------------

All international orders will be routed to a Flow.io hosted checkout page. By default the order confirmation page will hosted with Flow.io as well.

By default all US orders are considered domestic and will go through the normal Workarea checkout.
This can be modified by changing this config value:

    config.flow_io.domestic_order_origins = ['USA']


Customers will be redirected to the default Flow.io checkout url. However, most clients will choose to redirect to a subdomain.
The redirect domain is controlled via the following config:

    config.flow_io.checkout_uri = "https://checkout.flow.io"

Installation
--------------------------------------------------------------------------------

    bundle exec rake workarea:flow_io:create_localization_attributes

Workarea Platform Documentation
--------------------------------------------------------------------------------

See [http://developer.weblinc.com](http://developer.weblinc.com) for Workarea platform documentation.

Copyright & Licensing
--------------------------------------------------------------------------------

Copyright WebLinc 2018. All rights reserved.

For licensing, contact sales@workarea.com.
