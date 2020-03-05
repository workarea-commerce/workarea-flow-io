module Workarea
  module FlowIo
    class LocalizedPrice
      include ApplicationDocument

      field :min_quantity, type: Integer, default: 1

      embeds_one :regular, class_name: "Workarea::FlowIo::PriceWithBase"
      embeds_one :sale, class_name: "Workarea::FlowIo::PriceWithBase"

      embedded_in :local_item, class_name: "Workarea::FlowIo::LocalItem"

      validates_presence_of :regular

       # Creates a Pricing::Price from this local item
       # used in Pricing::Sku#find_price
       #
       # @return [Workarea::Pricing::Price]
       #
       def to_price
         Workarea::Pricing::Price.new(
           min_quantity: min_quantity,
           regular: regular.price,
           sale: sale&.price
         )
       end
    end
  end
end
