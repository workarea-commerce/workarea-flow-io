require 'test_helper'

module Workarea
  module Storefront
    class FlowWebhookRackAttackIntegrationTest < Workarea::IntegrationTest
      include Workarea::FlowIo::WebhookIntegrationTest

      class AddEnvMiddleware
        def initialize(app)
          @app = app
        end

        def call(env)
          env.merge!(Rails.application.env_config)
          @app.call(env)
        end
      end

      def test_safelist_webhook_requests
        post "/", params: {}, headers: headers
        assert_equal("allow flow webhooks", @rack_attack_rules["rack.attack.matched"])
        assert_equal(:safelist, @rack_attack_rules["rack.attack.match_type"])
      end

      def test_doesnt_safelist_with_bad_auth
        post "/", params: {}
        assert_nil(@rack_attack_rules["rack.attack.matched"])
        assert_nil(@rack_attack_rules["rack.attack.match_type"])
      end

      private

      def app
        @app ||=
          begin
            endpoint = ->(env) do
              @rack_attack_rules = env.slice(
                "rack.attack.matched",
                "rack.attack.match_type"
              )
              [200, {}, []]
            end

            Rack::Builder.new do
              use AddEnvMiddleware
              use Rack::Attack
              use ActionDispatch::Cookies
              run endpoint
            end
          end
      end
    end
  end
end
