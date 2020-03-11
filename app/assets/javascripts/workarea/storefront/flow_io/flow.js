/**
 * Integrate flow.io's JS into your Workarea application.
 *
 * @namespace WORKAREA.flow
 */
WORKAREA.registerModule('flow', (function () {
    'use strict';

    var getScript = _.once(function () {
            !function (f, l, o, w, i, n, g) {
            f[i] = f[i] || {};f[i].cmd = f[i].cmd || function () {
            (f[i].q = f[i].q || []).push(arguments);};n = l.createElement(o);
            n.src = w;g = l.getElementsByTagName(o)[0];g.parentNode.insertBefore(n, g);
            }(window,document,'script','https://cdn.flow.io/flowjs/latest/flow.min.js','flow');

            flow.cmd('set', 'organization', WORKAREA.config.flow.organizationID);
            flow.cmd('init');
        }),

        initCountryPicker = _.once(function() {
            flow.cmd('on', 'ready', function () {
                flow.countryPicker.createCountryPicker({
                    type: "modal",
                    containerId: "country-picker"
                });
            });
        }),

        localizePrice = function(index, priceWrapper, experienceKey, currencyCode) {
            var $priceWrapper = $(priceWrapper),
                localPrices = _.merge({}, $priceWrapper.data('localPrices')),
                priceKey = experienceKey + "-" + currencyCode,
                priceLabel = localPrices[priceKey],
                priceAttr;

            if (_.isUndefined(priceLabel)) {
              priceAttr = $priceWrapper.data('flowPriceAttr');
              if (_.isUndefined(priceAttr)) {
                $priceWrapper.attr('data-flow-localize', 'item-price');
              }
              else {
                $priceWrapper.attr('data-flow-localize', 'item-price-attribute');
                $priceWrapper.attr('data-flow-item-price-attribute', priceAttr);
              }
            }
            else{
              $priceWrapper.removeAttr('data-flow-localize');
              $priceWrapper.removeAttr('data-flow-item-price-attribute');
              $priceWrapper.html(priceLabel);
           }
        },

        localizePrices = function($scope) {
            flow.cmd('on', 'ready', function () {
                var experienceKey = flow.session.getExperience(),
                    currencyCode = flow.session.getCurrency();

                $('[data-local-prices]', $scope).each(_.partialRight(localizePrice, experienceKey, currencyCode));
                flow.cmd('localize');
            });
        },

        /**
         * @method
         * @name init
         * @memberof WORKAREA.flow
         */
        init = function ($scope) {
            if (_.isUndefined(WORKAREA.config.flow)) { return; }

            getScript();
            localizePrices($scope);

            if (!_.isEmpty($("#country-picker"))) {
                initCountryPicker();
            }
        };

        return {
            init: init
        };
}()));
