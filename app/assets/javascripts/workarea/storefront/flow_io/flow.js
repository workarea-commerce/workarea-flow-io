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

        initCountryPicker = _.once(function() {
            flow.cmd('on', 'ready', function () {
                flow.countryPicker.createCountryPicker({
                    type: "modal",
                    containerId: "country-picker",
                    onSessionUpdate: updateSession
                });
            });
        }),

        localizePrices = function() {
            flow.cmd('localize');
        },

        /**
         * @method
         * @name init
         * @memberof WORKAREA.flow
         */
        init = function () {
            if (_.isUndefined(WORKAREA.config.flow)) { return; }

            getScript();
            localizePrices();

            if (!_.isEmpty($("#country-picker"))) {
                initCountryPicker();
            }
        };

        // urlLocale and redirectUrl are only exposed for testing and
        // shouldn't be used as part of public API
        return {
            init: init,
            urlLocale: urlLocale,
            redirectUrl: redirectUrl
        };
}()));
