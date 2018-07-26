module Workarea
  module Storefront
    class FlowIoWebhookController < Storefront::ApplicationController
      skip_before_action :verify_authenticity_token
      before_action :authenticate

      def event
        event = Io::Flow::V0::Models::Event.from_json(params.to_unsafe_hash)
        FlowIo::Webhook.process(event)
        successful_response

      rescue Mongoid::Errors::DocumentNotFound => error
        not_found_response(params: error.params, problem: error.problem)
      rescue FlowIo::Webhook::Error::NotFound, FlowIo::Webhook::Error::UnhandledWebhook => _error
        not_found_response(error: "UnhandledWebhook")
      rescue RuntimeError => error # raised when Event.from_json gets malformed data
        error_response(error: error.to_s)
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


        def error_response(payload)
          render json: payload, status: :unprocessable_entity
        end

        def not_found_response(payload)
          render json: payload, status: :not_found
        end
    end
  end
end
