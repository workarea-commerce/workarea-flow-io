module Workarea
  module FlowIo
    class BogusClient
      require 'workarea/flow_io/bogus_client/proxy_client'
      require 'workarea/flow_io/bogus_client/experiences'
      require 'workarea/flow_io/bogus_client/fulfillments'
      require 'workarea/flow_io/bogus_client/items'
      require 'workarea/flow_io/bogus_client/orders'
      require 'workarea/flow_io/bogus_client/organizations'
      require 'workarea/flow_io/bogus_client/sessions'
      require 'workarea/flow_io/bogus_client/shipping_notifications'

      cattr_accessor :requests

      def self.reset_requests!
        self.requests = Hash.new do |client_hash, client_class|
          client_hash[client_class] = Hash.new do |method_hash, method_name|
            method_hash[method_name] = []
          end
        end
      end

      reset_requests!

      def method_missing(method)
        client_class = client(method)

        if client_class
          ProxyClient.new(method, client_class.new)
        else
          super
        end
      end

      def respond_to_missing?(method, include_all = false)
        client(method).present? || super
      end

      private

        def client(client_name)
          BogusClient.const_get(client_name.to_s.camelize) rescue nil
        end
    end
  end
end
