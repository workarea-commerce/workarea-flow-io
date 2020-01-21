module Workarea
  module FlowIo
    class BogusClient
      class CheckoutTokens
        def post_checkout_and_tokens_by_organization(organization, checkout_token_form)
          unless checkout_token_form.is_a? ::Io::Flow::V0::Models::CheckoutTokenForm
            checkout_token_form = ::Io::Flow::V0::Models::CheckoutTokenForm.new(checkout_token_form)
          end

          ::Io::Flow::V0::Models::CheckoutToken.new(
            id: SecureRandom.hex(20),
            organization: { id: organization },
            order: { number: checkout_token_form.order_number },
            session: { id: checkout_token_form.session_id },
            urls: {
              continue_shopping: checkout_token_form.urls.continue_shopping
            },
            expires_at: 1.day.from_now.utc.iso8601(3),
            checkout: { id: 'foo' }
          )
        end
      end
    end
  end
end
