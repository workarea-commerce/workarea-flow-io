module Workarea
  module FlowIo
    class Webhook::ExperienceUpsertedV2 < Webhook
      def process
        FlowIo::Experiences.refresh_cache
      end
    end
  end
end
