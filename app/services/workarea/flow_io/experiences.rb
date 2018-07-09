module Workarea
  module FlowIo
    class Experiences
      def self.all
        # TODO expires_in to config - add race condition ttl
        # @return [::Io::Flow::V0::Models::Experience]
        Rails.cache.fetch('flow-expereinces', expires_in: 1.hour) do
          FlowIo.client.experiences.get(FlowIo.organization_id).select do |experience|
            experience.status.value == "active"
          end
        end
      end
    end
  end
end