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
    end
  end
end
