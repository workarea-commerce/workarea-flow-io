module Workarea
  module FlowIo
    class Webhook
      class Error < RuntimeError; end
      class Error::NotFound < RuntimeError; end
      class Error::UnhandledWebhook < RuntimeError; end

      # @param ::Io::Flow::V0::Models::Event
      def self.process(event)
        begin
          klass = "Workarea::FlowIo::Webhook::#{event.discriminator.classify}".constantize
        rescue NameError => _error
          raise Error::UnhandledWebhook, "no class defined to handle #{event.discriminator.classify}"
        end

        klass.new(event).process
      end

      attr_reader :event

      def initialize(event)
        @event = event
      end

      def process; end
    end
  end
end
