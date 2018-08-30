module Workarea
  module Storefront
    class FlowIoWebhookController < Storefront::ApplicationController
      skip_before_action :verify_authenticity_token
      before_action :verify_signature

      def event
        begin
          event = Io::Flow::V0::Models::Event.from_json(params.to_unsafe_hash)
          FlowIo::Webhook.process(event)
          successful_response

        rescue Mongoid::Errors::DocumentNotFound => error
          not_found_response(params: error.params, problem: error.problem)
        rescue FlowIo::Webhook::Error::NotFound, FlowIo::Webhook::Error::UnhandledWebhook => error
          not_found_response(error: "UnhandledWebhook: #{error}")
        rescue RuntimeError => error # raised when Event.from_json gets malformed data
          error_response(error: error.to_s)
        end
      end

      private

        def verify_signature
          request_valid = FlowIo::WebhookRequestSignature.valid?(
            request_signature: request.headers['X-Flow-Signature'],
            request_body: request.raw_post
          )

          unsuccessful_response unless request_valid
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
