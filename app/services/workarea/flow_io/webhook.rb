module Workarea
  module FlowIo
    class Webhook
      class Error < RuntimeError; end
      class Error::NotFound < RuntimeError; end
      class Error::UnhandledWebhook < RuntimeError; end

      # @param ::Io::Flow::V0::Models::Event
      def self.process(event)
        "Workarea::FlowIo::Webhook::#{event.discriminator.classify}"
          .constantize
          .new(event)
          .process
      rescue NameError => _error
        byebug
        raise Error::UnhandledWebhook
      rescue Mongoid::Errors::DocumentNotFound
        raise Error::NotFound
      end

      attr_reader :event

      def initialize(event)
        @event = event
      end

      def process; end
    end
  end
end
