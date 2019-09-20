Workarea Flow Io 1.1.2 (2019-09-20)
--------------------------------------------------------------------------------

*   Handle orders changing currency during flow checkout

    Changing shipping address in flow checkout would update the experience
    and currency causing the webhook to error.  Update the
    `Order#experience` when processing the order upserted webhook

    FLOW-60
    Eric Pigeon



Workarea Flow Io 1.1.1 (2019-07-18)
--------------------------------------------------------------------------------

*   Update setting site locale with multiste

    Multisite uses it's own method to set I18n.locale; override this method
    to prevent from setting the locale from a flow experience

    FLOW-59
    Eric Pigeon



Workarea Flow Io 1.1.0 (2019-04-16)
--------------------------------------------------------------------------------

*   Set payment token to correct value from activemerchant gateway

    Properly set the stored credit card the value returned from the store
    method on the activemerchant integration.

    FLOW-58
    Jeff Yucis



Workarea Flow Io 1.0.0 (2018-11-13)
--------------------------------------------------------------------------------

*   Workarea Flow.io

    Flow enables merchants to create localized shopping experiences,
    including localized prices, payment and shipping options.

    FLOW-1
    Eric Pigeon



