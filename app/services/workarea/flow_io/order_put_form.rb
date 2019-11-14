module Workarea
  module FlowIo
    class OrderPutForm
      # @param order [Workarea::Order]
      # @param shippings [Array<Workarea::Shipping>, nil]
      # @param discounts [Array<Workarea::Pricing::Discount>, nil]
      #
      def self.from(order:, shippings: nil, discounts: nil)
        new(order: order, shippings: shippings).to_flow_model
      end

      attr_reader :order, :shippings, :discounts

      # @param order [Workarea::Order]
      # @param shippings [Array<Workarea::Shipping>, nil]
      # @param discounts [Array<Workarea::Pricing::Discount>, nil]
      #
      def initialize(order:, shippings: nil, discounts: nil)
        @order = order
        @shippings = shippings || []
        @discounts = discounts || []
      end

      # @return [::Io::Flow::V0::Models::OrderPutForm]
      #
      def to_flow_model
        ::Io::Flow::V0::Models::OrderPutForm.new(
          {
            attributes: { number: order.id },
            customer: customer,
            items: items
          }
        )
      end

      private

        def customer
          return nil unless user.present?

          {
            email: user.email,
            name: {
              first: user.first_name,
              last: user.last_name
            },
            phone: user.default_shipping_address&.phone_number
          }
        end

        def user
          return unless order.user_id.present?

          @user ||= Workarea::User.find(order.user_id) rescue nil
        end

        def items
          order.items.map { |item| FlowIo::LineItemForm.from(order_item: item, discounts: discounts) }
        end
    end
  end
end
