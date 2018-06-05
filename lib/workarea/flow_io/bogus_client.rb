module Workarea
  module FlowIo
    class BogusClient
      def items
        @items ||= Items.new
      end

      class Items
        def put_by_number(organization, number, form); end
      end
    end
  end
end
