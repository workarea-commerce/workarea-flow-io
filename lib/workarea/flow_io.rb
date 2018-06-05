require 'flowcommerce'

require 'workarea'
require 'workarea/storefront'
require 'workarea/admin'

require 'workarea/flow_io/engine'
require 'workarea/flow_io/version'
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

    def self.client
      if api_token.present?
        FlowCommerce.instance(token: Workarea::FlowIo.api_token)
      else
        FlowIo::BogusClient.new
      end
    end
  end
end
