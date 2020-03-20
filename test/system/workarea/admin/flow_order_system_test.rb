require 'test_helper'

module Workarea
  module Admin
    class FlowOrderSystemTest < SystemTest
      include IntegrationTest
      include FlowIo::FlowFixtures

      setup :setup_order

      def setup_order
        @order = create_placed_canadian_flow_order
      end

      def test_flow_order_attributes
        visit admin.order_path(@order)

        assert_text('Flow Payment: VISA ending with 1111')
        assert_text(I18n.t('workarea.admin.orders.view_flow_order'))
      end

      def test_flow_order_details
        visit admin.flow_order_path(@order)

        assert_text(@order.total_price.to_s)
        assert_text(@order.flow_total_price.to_s)

        assert_text(@order.tax_total.to_s)
        assert_text(@order.flow_tax_total.to_s)

        assert_text(@order.shipping_total.to_s)
        assert_text(@order.flow_shipping_total.to_s)

        assert_text(@order.items.first.total_price.to_s)
        assert_text(@order.items.first.flow_total_price.to_s)
      end
    end
  end
end
