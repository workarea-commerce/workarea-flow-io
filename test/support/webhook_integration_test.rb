module Workarea
  module FlowIo
    module WebhookIntegrationTest
      def self.included(test)
        test.setup :setup_flow_io_basic_auth_credentials
        test.teardown :restore_credentials
      end

      private

        def setup_flow_io_basic_auth_credentials
          @_old_credentials = Workarea::FlowIo.credentials

          Rails.application.secrets.flow_io = {
            webhook_username: "flow_io",
            webhook_password: "password"
          }
        end

        def restore_credentials
          Rails.application.secrets.flow_io = @_old_credentials
        end

        def headers
          {
            "Authorization" => "Basic #{Base64.encode64('flow_io:password')}",
            'CONTENT_TYPE' => 'application/json'
          }
        end
    end
  end
end
