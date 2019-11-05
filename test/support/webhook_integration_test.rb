module Workarea
  module FlowIo
    module WebhookIntegrationTest
      def self.included(test)
        test.setup :setup_flow_io_basic_auth_credentials
        test.teardown :restore_credentials
      end

      def post_signed(path, params:, **args)
        digest = OpenSSL::Digest.new('sha256')
        signature = "sha256=#{OpenSSL::HMAC.hexdigest(digest, webhook_shared_secret, params.to_s)}"

        headers = {
          'X-Flow-Signature' => signature,
          'CONTENT_TYPE' => 'application/json'
        }

        post(path, args.merge(params: params, headers: headers))
      end

      private

        def setup_flow_io_basic_auth_credentials
          @_old_credentials = Workarea::FlowIo.credentials

          Rails.application.secrets.flow_io = {
            webhook_shared_secret: "password"
          }
        end

        def restore_credentials
          Rails.application.secrets.flow_io = @_old_credentials
        end

        def webhook_shared_secret
          @webhook_shared_secret ||= begin
            secret = Workarea::FlowIo::Webhook::SharedSecret.first_or_create!
            secret.token
          end
        end
    end
  end
end
