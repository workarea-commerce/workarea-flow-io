module Workarea
  module FlowIo
    class Countries
      def self.all
        # @return [Io::Flow::V0::Models::Country]
        Rails.cache.fetch('flow-countries', expires_in: Workarea.config.cache_expirations.flow_io_country_cache) do
          FlowIo.client
            .organizations
            .get_countries_by_organization(Workarea::FlowIo.organization_id)
        end
      end
    end
  end
end
