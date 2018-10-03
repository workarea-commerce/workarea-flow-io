module Workarea
  module FlowIo
    class ControllerLogSubscriber < ActiveSupport::LogSubscriber
      def start_processing(event)
        return unless logger.info?

        payload = event.payload

        info "  Flow Experience: #{payload[:headers]['flow.io.experience'].to_hash}"
      end

      private

        def logger
          ActionController::Base.logger
        end
    end
  end
end

Workarea::FlowIo::ControllerLogSubscriber.attach_to :action_controller
