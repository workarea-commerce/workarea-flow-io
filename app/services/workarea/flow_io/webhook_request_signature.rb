module Workarea
  module FlowIo
    module WebhookRequestSignature
      # @param[String] request_signature
      # @param[String] request_body
      #
      # @return Boolean
      def self.valid?(request_signature:, request_body:)
        digest = OpenSSL::Digest.new('sha256')

        expected_signature = 'sha-256=' + OpenSSL::HMAC.hexdigest(digest, Workarea::FlowIo.webhook_shared_secret, request_body)

        request_signature == expected_signature
      end
    end
  end
end
