module Workarea
  module FlowIo
    class ExperienceSummary
      include ApplicationDocument

      field :key, type: String
      field :name, type: String
      field :country, type: Country
      field :currency, type: String
      field :language, type: String

      validates_presence_of :key, :name

      def self.build_from_hash(hash)
        country = Country.find_country_by_alpha3(hash[:country])
        new(hash.merge(country: country))
      end
    end
  end
end
