module Workarea
  module FlowIo
    class Webhook
      class NotFound < RuntimeError; end
      class UnhandledWebhook < RuntimeError; end

      # @param ::Io::Flow::V0::Models::Event
      def self.process(event)
        "Workarea::FlowIo::Webhook::#{event.discriminator.classify}"
          .constantize
          .new(event)
          .process
      rescue NameError
        raise UnhandledWebhook
      rescue Mongoid::Errors::DocumentNotFound
        raise NotFound
      end

      attr_reader :event

      def initialize(event)
        @event = event
      end

      def process; end
    end
  end
end
