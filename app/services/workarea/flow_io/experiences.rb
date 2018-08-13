module Workarea
  module FlowIo
    class Experiences
      def self.all
        # @return [::Io::Flow::V0::Models::Experience]
        Rails.cache.fetch("flow-expereinces-#{FlowIo.organization_id}", expires_in: 1.hour) do
          FlowIo.client.experiences.get(FlowIo.organization_id).select do |experience|
            experience.status.value == "active"
          end
        end
      end

      def self.refresh_cache
        Rails.cache.delete("flow-expereinces-#{FlowIo.organization_id}")
        Experiences.all
      end

      # @return [String]
      def self.all_currencies
        Experiences.all.map(&:currency).uniq
      end
    end
  end
end
