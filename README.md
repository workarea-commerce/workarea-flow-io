Workarea Flow Io
================================================================================

Flow Io plugin for the Workarea platform.

Secrets
--------------------------------------------------------------------------------
    flow_io:
      api_token:
      organziation_id:
      webhook_username:
      webhook_password:

Configuration
--------------------------------------------------------------------------------

### Localization Attributes

The plugin provides localization attributes for: `original_price`, `sale_price`, `msrp`, `product_id` and `digital`
These correspond to values of the `attributes` when exporting an item to flow and come back in the `local_item_pricing` `attributes` field.
Other fields include `gtin`, `brand`, `hazardous` see https://docs.flow.io/module/localization/resource/attributes and
https://docs.flow.io/type/attribute-form

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
