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
                    var country = session.geo.country.iso_3166_3.toLowerCase(),
                        url = WORKAREA.url.current(),
                        parsedUrl = WORKAREA.url.parse(url),
                        path = parsedUrl.path,
                        locale = pathLocale(path),
                        redirectUrl;

                    WORKAREA.cookie.create('flow_experience', encodeURIComponent(JSON.stringify(session.experience)), 365);

                    if (locale !== null) {
                        url = url.replace(locale, "");
                    }
                    redirectUrl = WORKAREA.url.updateParams(url, {locale: country});

                    WORKAREA.url.redirectTo(redirectUrl);
                }
            });
        },

        pathLocale = function (path) {
            var parts = _.filter(path.split("/"), function(part) { return part !== ""; } ),
                matches = (parts[0] || "").match(/^(\w{2})$/);

            if (matches === null) {
                return;
            }
            else {
                return "/" + matches[1];
            }
        },

        /**
         * @method
         * @name init
         * @memberof WORKAREA.flowCountryPicker
         */
        init = function ($scope) {
            if (_.isUndefined(window.flow) || _.isUndefined(window.flow.beacon)) { return; }

            var $container = $("#country-picker", $scope);

            if (_.isEmpty($container)) { return; }

            getScript().done(function() {
                window.flow.beacon('on', 'ready', initCountryPicker);
            });
        };

        return {
            init: init
        };
}()));
