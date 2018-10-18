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

        urlLocale = function (url) {
            var parsedUrl = WORKAREA.url.parse(url),
                parts = _.filter(parsedUrl.path.split("/"), function(part) { return part !== ""; } ),
                matches = (parts[0] || "").match(/^(\w{3})$/);

            if (matches === null) {
                return;
            }
            else {
                return matches[1];
            }
        },

        redirectUrl = function(url, locale) {
           var oldLocale = urlLocale(url),
               parsedUrl;

            if (_.isUndefined(oldLocale)) {
                parsedUrl = WORKAREA.url.parse(url);
                return url.replace(new RegExp(parsedUrl.path + "$"), "/" + locale + parsedUrl.path);
            } else {
                return url.replace(oldLocale, locale);
            }
        },

        updateSession = function(status, session) {
            var country = session.geo.country.iso_3166_3.toLowerCase(),
                url = WORKAREA.url.current();

            WORKAREA.cookie.create('flow_country', country, 365);
            WORKAREA.cookie.create('flow_experience', encodeURIComponent(JSON.stringify(session.experience)), 365);
            WORKAREA.url.redirectTo(redirectUrl(url, country));
        },

        initCountryPicker = function () {
            window.flow.countryPicker.createCountryPicker({
                type: "modal",
                containerId: "country-picker",
                onSessionUpdate: updateSession
            });
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

        // urlLocale and redirectUrl are only exposed for testing and
        // shouldn't be used as part of public API
        return {
            init: init,
            urlLocale: urlLocale,
            redirectUrl: redirectUrl
        };
}()));
