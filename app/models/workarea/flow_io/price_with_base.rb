module Workarea
  module FlowIo
    class PriceWithBase < Price
      embeds_one :base_currency, class_name: "Workarea::FlowIo::Price"
    end
  end
end
