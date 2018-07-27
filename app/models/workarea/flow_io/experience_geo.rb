module Workarea
  module FlowIo
    class ExperienceGeo
      include ApplicationDocument

      field :key, type: String
      field :name, type: String
      field :region, type: Hash
      field :country, type: Country
      field :currency, type: String
      field :language, type: String
      field :measurement_system, type: String

      embedded_in :experienceable, polymorphic: true
      validates_presence_of :key, :name
    end
  end
end
