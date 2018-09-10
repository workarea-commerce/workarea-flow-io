module Workarea
  module FlowIo
    module WebhookRequestSignature
      # @param[String] request_signature
      # @param[String] request_body
      #
      # @return Boolean
      def self.valid?(request_signature:, request_body:)
        return false unless request_signature.present? && request_body.present?

        digest = OpenSSL::Digest.new('sha256')

        expected_signature = 'sha256=' + OpenSSL::HMAC.hexdigest(digest, Workarea::FlowIo.webhook_shared_secret, request_body)

        Rack::Utils.secure_compare request_signature, expected_signature
      end
    end
  end
end
