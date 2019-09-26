require 'test_helper'

module Workarea
  module Storefront
    class FlowIoSessionIntegrationTest < Workarea::IntegrationTest
      include FlowBogusClientSupport

      thread_cattr_accessor :geo_headers

      class AddEnvMiddleware
        def initialize(app)
          @app = app
        end

        def call(env)
          env.merge!(Rails.application.env_config)
          if FlowIoSessionIntegrationTest.geo_headers.present?
            env.merge!(FlowIoSessionIntegrationTest.geo_headers)
          end
          @app.call(env)
        end
      end

      setup :clean_rack_cache_storage

      def test_domestic_request
        Workarea.with_config do |config|
          config.strip_http_caching_in_tests = false

          get("/")

          assert_equal('miss, store', response.headers['X-Rack-Cache'])
          assert_match("_f60_session=F51MUamlJKDTPUwlhZ4D2bwYnFUbmlwv0ULNnlMs2UkURkioYJNmNY5pRjNHC3bH", response.headers['Set-Cookie'])
          assert_match("flow_experience", response.headers['Set-Cookie'])

          expected_session_request = [nil, { ip: "127.0.0.1" }]
          assert_equal(expected_session_request, FlowIo::BogusClient.requests[:sessions][:post_organizations_by_organization].first)
          assert_equal("", cookies[:flow_experience])

          assert_equal(1, FlowIo::BogusClient.total_request_count)

          get("/")
          assert_equal('fresh', response.headers['X-Rack-Cache'])

          assert_equal(1, FlowIo::BogusClient.total_request_count)
        end
      end

      def test_foreign_session
        Workarea.with_config do |config|
          config.strip_http_caching_in_tests = false

          with_geo_headers('HTTP_GEOIP_CITY_COUNTRY_CODE3' => "CAN") do
            get("/")

            assert_equal('miss, store', response.headers['X-Rack-Cache'])
            assert_match("_f60_session=F51neI7zcfN7FVFyvuOmi9IvY1qY6CPtBk3dPJoeNL1Xy1wRxxfnjRgft8S8CapT", response.headers['Set-Cookie'])
            assert_match("flow_experience", response.headers['Set-Cookie'])

            expected_session_request = [nil, { ip: "127.0.0.1", country: "CAN" }]
            assert_equal(expected_session_request, FlowIo::BogusClient.requests[:sessions][:post_organizations_by_organization].first)
            expected_experience = {
              key: "canada",
              name: "Canada",
              region: { id: "can" },
              country: "CAN",
              currency: "CAD",
              language: "en",
              measurement_system: "metric"
            }.deep_stringify_keys
            assert_equal(expected_experience, JSON.parse(cookies[:flow_experience]))

            assert_equal(1, FlowIo::BogusClient.total_request_count)

            get("/")
            assert_equal('fresh', response.headers['X-Rack-Cache'])

            assert_equal(1, FlowIo::BogusClient.total_request_count)
          end
        end
      end

      def test_flow_session_missing
        Workarea.with_config do |config|
          config.strip_http_caching_in_tests = false

          cookies['_f60_session'] = "404"
          get("/")

          assert response.ok?
          assert_equal("F51MUamlJKDTPUwlhZ4D2bwYnFUbmlwv0ULNnlMs2UkURkioYJNmNY5pRjNHC3bH", cookies['_f60_session'])
          assert_equal(2, FlowIo::BogusClient.total_request_count)
        end
      end

      private

      def with_geo_headers(headers, &block)
        FlowIoSessionIntegrationTest.geo_headers = headers
        block.call
      ensure
        FlowIoSessionIntegrationTest.geo_headers = nil
      end

      def app
        @app ||= Rack::Builder.new do
          use AddEnvMiddleware
          use RackCacheConfigMiddleware
          use Workarea::FlowIo::SessionMiddleware
          use Rack::Cache, metastore: 'heap:/', entitystore: 'heap:/', verbose: true
          use ActionDispatch::Cookies
          use ActionDispatch::Session::CookieStore
          use Workarea::TrackingMiddleware
          run Rails.application.endpoint
        end
      end

      def clean_rack_cache_storage
        Rack::Cache::Storage.instance.instance_variable_set(:@metastores, {})
        Rack::Cache::Storage.instance.instance_variable_set(:@entitystores, {})
      end
    end
  end
end
