require 'test_helper'

module Workarea
  module Storefront
    class FlowIoSessionIntegrationTest < Workarea::IntegrationTest
      class AddEnvMiddleware
        def initialize(app)
          @app = app
        end

        def call(env)
          env.merge!(Rails.application.env_config)
          @app.call(env)
        end
      end

      setup :clean_rack_cache_storage

      def test_without_f60_session
        Workarea.with_config do |config|
          config.strip_http_caching_in_tests = false

          get('/?sync_country=true', headers: { "HTTP_COOKIE" => "_f60_session=1;" })
          assert_equal('pass', response.headers['X-Rack-Cache'])
          flow_session = JSON.parse(response.cookies["flow_io"])
          assert(flow_session.present?)

        end
      end

      def test_with_flow_session
        Workarea.with_config do |config|
          config.strip_http_caching_in_tests = false

          session = FlowIo.client.sessions.get_by_session(1).to_hash
          session_cookie_string = Rack::Utils.add_cookie_to_header(nil, "flow_io", JSON.generate(session))

          get("/", headers: { "HTTP_COOKIE" => "_f60_session=1; #{session_cookie_string}" })
          assert_equal('miss, store', response.headers['X-Rack-Cache'])
          assert_equal("X-Requested-With, X-Flash-Messages, X-Flow-Experience", response.headers["Vary"])
          assert_nil(response.headers["X-Flow-Experience"])

          get("/", headers: { "HTTP_COOKIE" => "_f60_session=1; #{session_cookie_string}" })
          assert_equal('fresh', response.headers['X-Rack-Cache'])
        end
      end

      def test_with_flow_session_in_experience
        Workarea.with_config do |config|
          config.strip_http_caching_in_tests = false

          session = FlowIo.client.sessions.get_by_session(1).to_hash
          session_cookie_string = Rack::Utils.add_cookie_to_header(nil, "flow_io", JSON.generate(session))
          get("/", headers: { "HTTP_COOKIE" => "_f60_session=1; #{session_cookie_string}" })
          assert_equal('miss, store', response.headers['X-Rack-Cache'])

          session = FlowIo.client.sessions.get_by_session(2).to_hash
          session_cookie_string = Rack::Utils.add_cookie_to_header(nil, "flow_io", JSON.generate(session))
          get("/", headers: { "HTTP_COOKIE" => "_f60_session=1; #{session_cookie_string}" })
          assert_equal('miss, store', response.headers['X-Rack-Cache'])
          assert_equal('canada', response.headers["X-Flow-Experience"])

          session = FlowIo.client.sessions.get_by_session(2).to_hash
          session_cookie_string = Rack::Utils.add_cookie_to_header(nil, "flow_io", JSON.generate(session))

          get("/", headers: { "HTTP_COOKIE" => "_f60_session=1; #{session_cookie_string}" })
          assert_equal('canada', response.headers["X-Flow-Experience"])
          assert_equal('fresh', response.headers['X-Rack-Cache'])
        end
      end

      private

      def app
        @app ||= Rack::Builder.new do
          use AddEnvMiddleware
          use RackCacheConfigMiddleware
          use Workarea::FlowIo::SessionMiddleware
          use Rack::Cache, metastore: 'heap:/', entitystore: 'heap:/', verbose: true
          use ActionDispatch::Cookies
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
