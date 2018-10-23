module Workarea
  module FlowIo
    class FulfillmentCancellationForm
      def self.from(id:, quantities:)
        order = Workarea::Order.find id

        new(order: order, quantities: quantities).to_flow_model
      end

      attr_reader :order, :quantities

      def initialize(order:, quantities:)
        @order = order
        @quantities = quantities
      end

      # @return ::Io::Flow::V0::Models::FulfillmentCancellationForm
      def to_flow_model
        ::Io::Flow::V0::Models::FulfillmentCancellationForm.new(
          reason: "consumer_requested",
          lines: lines
        )
      end

      private

        def lines
          @lines ||= quantities.map do |order_item_id, quantity|
            order_item = order.items.detect { |item| item.id.to_s == order_item_id.to_s }
            next unless order_item.present?

            {
              item_number: order_item.sku,
              quantity: quantity.to_i
            }
          end.compact
        end
    end
  end
end
