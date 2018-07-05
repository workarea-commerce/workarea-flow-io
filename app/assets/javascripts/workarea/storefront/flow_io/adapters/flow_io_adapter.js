/**
 * @namespace WORKAREA.flowIoAdapter
 */

WORKAREA.analytics.registerAdapter('flowIoAdapter', function () {
    'use strict';

    return {
        'addToCartConfirmation': function (payload) {
            var cartAddEvent = {
                item_number: payload.sku,
                quantity: payload.quantity,
                price: {
                    amount: payload.price,
                    currency: payload.currency_code,
                },
            };

            flow.beacon('event', 'cart_add', cartAddEvent);
        },

        'removeFromCart': function (payload) {
            var cartRemoveEvent = {
                item_number: payload.sku
            };

            flow.beacon('event', 'cart_remove', cartRemoveEvent);
        },

        'checkoutOrderPlaced': function (payload) {
            var transactionEvent = {
                number: payload.id,
                revenue: {
                    amount: payload.total_price,
                    currency: payload.total_price_currence_code,
                },
                shipping: {
                    amount: payload.shipping_total,
                    currency: payload.shipping_total_currency_code
                },
                tax: {
                    amount: payload.tax_total,
                    currency: payload.tax_total_currency_code,
                },
                items: _.map(payload.items. function (impression) {
                    return {
                        number: impression.sku,
                        price: {
                            amount: impression.price,
                            currency: impression.currency_code
                        },
                        quantity: impression.quantity,
                        name: impression.product_name
                    };
                })
            };

            flow.beacon('event', 'transaction', transactionEvent);
        }
    };
});
