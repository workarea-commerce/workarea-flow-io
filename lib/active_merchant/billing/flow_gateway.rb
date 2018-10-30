module ActiveMerchant
  module Billing
    module FlowGatewayFixes
      FORM_TYPES = [
        :authorization_copy_form, :direct_authorization_form, :merchant_of_record_authorization_form,
        :paypal_authorization_form, :redirect_authorization_form, :inline_authorization_form,
        :card_authorization_form, :ach_authorization_form
      ]

      def purchase(credit_card, order_number, options = {})
        response = authorize(credit_card, order_number, options)
        capture(options[:amount], response.authorization, options)
      end

      # Create a new authorization.
      # https://docs.flow.io/module/payment/resource/authorizations#post-organization-authorizations
      def authorize(cc_or_token, order_number, opts = {})
        unless opts[:currency]
          return error_response('Currency is a required option')
        end

        unless opts[:discriminator]
          return error_response 'Discriminator is not defined, please choose one [%s]' % FORM_TYPES.join(', ')
        end

        unless FORM_TYPES.include?(opts[:discriminator].to_sym)
          return error_response 'Discriminator [%s] not found, please choose one [%s]' % [opts[:discriminator], FORM_TYPES.join(', ')]
        end

        body = {
          amount:        opts[:amount] || 0.0,
          currency:      opts[:currency],
          discriminator: opts[:discriminator],
          token:         store(cc_or_token),
          order_number:  order_number
        }

        response = flow_instance.authorizations.post @flow_organization, body

        # This is the only changed line, it just sets the response.id as Response#authorizzation
        Response.new true, 'Flow authorize - Success', { response: response }, { authorization: response.id }
      rescue => exception
        error_response exception
      end
    end
    FlowGateway.prepend FlowGatewayFixes
  end
end
