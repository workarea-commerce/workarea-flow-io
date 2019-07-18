require 'test_helper'

module Workarea
  class FlowLocaleIntegrationTest < IntegrationTest
    if Plugin.installed?(:multi_site)
      include MultiSite::TestCase
    end

    class FlowTestController < Workarea::Storefront::ApplicationController
      def index
        render plain: I18n.locale
      end
    end

    setup :add_routes

    def add_routes
      Rails.application.routes.prepend do
        get 'flow_locale_test',
              to: 'workarea/flow_locale_integration_test/flow_test#index'
      end

      Rails.application.reload_routes!
    end

    def test_does_not_change_i18n_locale
      get '/flow_locale_test'
      assert_equal I18n.default_locale.to_s, response.body

      get '/flow_locale_test?locale=usa'
      assert_equal I18n.default_locale.to_s, response.body
    end
  end
end
