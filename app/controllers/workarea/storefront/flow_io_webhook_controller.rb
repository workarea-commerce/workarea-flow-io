module Workarea
  module Storefront
    class FlowIoWebhookController < Storefront::ApplicationController
      skip_before_action :verify_authenticity_token
      before_action :authenticate

      def event
        FlowIo::Webhook.process(Io::Flow::V0::Models::Event.from_json(params.to_unsafe_hash))

        successful_response
      rescue FlowIo::Webhook::Error::NotFound,
        FlowIo::Webhook::Error::UnhandledWebhook => _error
        not_found_response
      rescue RuntimeError => _error # raised when Event.from_json gets malformed data
        unsuccessful_response
      end

      private

        def authenticate
          authenticated = authenticate_with_http_basic do |username, password|
            FlowIo.webhook_username.present? && FlowIo.webhook_password.present? &&
              username == FlowIo.webhook_username && password == FlowIo.webhook_password
          end

          unsuccessful_response unless authenticated
        end

        def successful_response
          render json: { status: 200 }
        end

        def unsuccessful_response
          head :bad_request
        end

        def not_found_response
          render json: { status: 404 }
        end
    end
  end
end
