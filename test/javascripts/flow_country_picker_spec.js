//= require workarea/storefront/flow_io/flow_country_picker

(function () {
    'use strict';

    describe('WORKAREA.flowCountryPicker', function () {
        describe('urlLocale', function () {
            it('parses iso_3166_3 in url', function () {
                var url = 'https://example.com/deu/products/small-iron-bag'
                expect(WORKAREA.flowCountryPicker.urlLocale(url)).to.eq("deu");
            });

            it('handles url without iso_3166_3', function () {
                var url = 'https://example.com/products/small-iron-bag'
                expect(_.isUndefined(WORKAREA.flowCountryPicker.urlLocale(url))).to.eq(true);
            });
        });

        describe('redirectUrl', function () {
            it('replaces the country in the url', function () {
                var url = 'https://example.com/products/small-iron-bag'
                expect(WORKAREA.flowCountryPicker.redirectUrl(url, "gbr")).to.eq("https://example.com/gbr/products/small-iron-bag");
            });

            it('injects the country into the url', function () {
                var url = 'https://example.com/deu/products/small-iron-bag'
                expect(WORKAREA.flowCountryPicker.redirectUrl(url, "gbr")).to.eq("https://example.com/gbr/products/small-iron-bag");
            });

            it('works without path', function () {
                var url = 'https://example.com/'
                expect(WORKAREA.flowCountryPicker.redirectUrl(url, "gbr")).to.eq("https://example.com/gbr/");

                url = 'https://example.com'
                expect(WORKAREA.flowCountryPicker.redirectUrl(url, "gbr")).to.eq("https://example.com/gbr");
            });
        });
    });
}());
