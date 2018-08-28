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

      def test_without_f60_session
        get('/?sync_country=true', headers: { "HTTP_COOKIE" => "_f60_session=1;" })
        assert_equal('pass', response.headers['X-Rack-Cache'])
        flow_session = JSON.parse(response.cookies["flow_io"])
        assert(flow_session.present?)
      end

      def test_with_flow_session
        session = FlowIo.client.sessions.get_by_session(1)
        puts 'first hit'
        get("/", headers: { "HTTP_COOKIE" => "_f60_session=1; flow_io=>#{JSON.generate(session)}" })
        assert_equal('miss', response.headers['X-Rack-Cache'])
        assert_equal("X-Requested-With, X-Flash-Messages, X-Flow-Experience", response.headers["Vary"])
        assert_nil(response.headers["X-Flow-Experience"])

        puts 'second hit'
        get("/", headers: { "HTTP_COOKIE" => "_f60_session=1; flow_io=>#{JSON.generate(session)}" })
        assert_equal('fresh', response.headers['X-Rack-Cache'])
      end

      private

      def app
        @app ||= Rack::Builder.new do
          use AddEnvMiddleware
          use RackCacheConfigMiddleware
          use FlowIo::SessionMiddleware
          use Rack::Cache, metastore: 'heap:/', entitystore: 'heap:/'
          run Rails.application
        end
      end
    end
  end
end
