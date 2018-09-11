require 'test_helper'

module Workarea
  module Admin
    class FlowOrderIntegrationTest < Workarea::IntegrationTest
      include Admin::IntegrationTest
      include Workarea::FlowIo::FlowFixtures

      def test_returns_flow_order_attributes
        order = create_placed_canadian_flow_order

        get admin.order_path(order)

        assert(response.body.include?("Flow Payment: VISA ending with 1111"))
        assert(response.body.include?(I18n.t('workarea.admin.orders.view_flow_order')))
      end

      def test_returns_flow_order_details
        order = create_placed_canadian_flow_order

        get admin.flow_order_path(order)

        assert(response.body.include?(order.total_price.to_s))
        assert(response.body.include?(order.flow_total_price.to_s))

        assert(response.body.include?(order.tax_total.to_s))
        assert(response.body.include?(order.flow_tax_total.to_s))

        assert(response.body.include?(order.shipping_total.to_s))
        assert(response.body.include?(order.flow_shipping_total.to_s))

        assert(response.body.include?(order.items.first.total_price.to_s))
        assert(response.body.include?(order.items.first.flow_total_price.to_s))
      end
    end
  end
end
