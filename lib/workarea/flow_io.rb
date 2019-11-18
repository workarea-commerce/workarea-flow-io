require 'flowcommerce'
require 'flowcommerce-activemerchant'
require 'active_merchant/billing/bogus_flow_gateway'
require 'active_merchant/billing/flow_gateway'

require 'workarea'
require 'workarea/storefront'
require 'workarea/admin'
require 'workarea/freedom_patches/flow_io'
require 'workarea/flow_io/controller_log_subscriber'

require 'workarea/flow_io/engine'
require 'workarea/flow_io/version'
require 'workarea/flow_io/http_handler'
require 'workarea/flow_io/bogus_client'

module Workarea
  module FlowIo
    def self.credentials
      (Rails.application.secrets.flow_io || {}).deep_symbolize_keys
    end

    def self.config
      Workarea.config.flow_io
    end

    def self.api_token
      credentials[:api_token]
    end

    def self.organization_id
      credentials[:organization_id]
    end

    def self.image_sizes
      config.image_sizes
    end

    def self.client(timeout: nil, open_timeout: nil, read_timeout: nil, logger: nil, **options)
      timeout ||= config.default_timeout
      read_timeout ||= timeout
      open_timeout ||= timeout

      if api_token.present?
        FlowCommerce.instance(
          token: Workarea::FlowIo.api_token,
          http_handler: Workarea::FlowIo::HttpHandler.new(open_timeout: open_timeout, read_timeout: read_timeout, logger: logger, **options)
        )
      else
        FlowIo::BogusClient.new
      end
    end

    def self.webhook_shared_secret
      Workarea::FlowIo::Webhook::SharedSecret.first.try(:token)
    end

    # Conditionally use the real gateway when secrets are present.
    # Otherwise, use the bogus gateway.
    #
    # @return [ActiveMerchant::Billing::Gateway]
    def self.gateway
      if credentials.present?
        ActiveMerchant::Billing::FlowGateway.new(api_key: Workarea::FlowIo.api_token, organization: Workarea::FlowIo.organization_id)
      else
        ActiveMerchant::Billing::BogusGateway.new
      end
    end
  end
end
