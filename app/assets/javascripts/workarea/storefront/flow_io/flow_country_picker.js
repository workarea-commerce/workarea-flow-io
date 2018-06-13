/**
 * @namespace WORKAREA.flowCountryPicker
 */
WORKAREA.registerModule('flowCountryPicker', (function () {
    'use strict';

    var getScript = function () {
            return $.ajax({
                dataType: "script",
                cache: true,
                url: "https://cdn.flow.io/country-picker/js/v0/country-picker.js"
            });
        },

        initCountryPicker = function () {
            window.flow.countryPicker.createCountryPicker({
                type: "modal",
                containerId: "country-picker",
                onSessionUpdate: function (status, session) {
                    var country = session.geo.country.iso_3166_3,
                        redirectUrl = WORKAREA.url.updateParams(WORKAREA.url.current(), {country: country});

                    WORKAREA.url.redirectTo(redirectUrl);
                }
            });
        },

        /**
         * @method
         * @name init
         * @memberof WORKAREA.flowCountryPicker
         */
        init = function ($scope) {
            var $container = $("#country-picker", $scope);

            if (_.isEmpty($container)) { return; }

            getScript().done(function() {
                flow.beacon('on', 'ready', initCountryPicker);
            })
        };

        return {
            init: init
        };
}()));
