module Workarea
  module FlowIo
    class Price
      include ApplicationDocument

      field :price, type: Money
      field :label, type: String

      validates_presence_of :price, :label
    end
  end
end
