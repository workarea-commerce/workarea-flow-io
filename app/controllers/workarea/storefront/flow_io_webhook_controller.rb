module Workarea
  module Storefront
    class FlowIoWebhookController < Storefront::ApplicationController
      abstract!
      skip_before_action :verify_authenticity_token
      before_action :authenticate

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
    end
  end
end
