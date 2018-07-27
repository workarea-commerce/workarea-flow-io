require 'test_helper'

module Workarea
  module Admin
    class FlowOrderIntegrationTest < Workarea::IntegrationTest
      include Admin::IntegrationTest
      include Workarea::FlowIo::FlowFixtures

      def test_returns_flow_order_details
        order = create_placed_canadian_flow_order

        get admin.order_path(order)

        assert(response.body.include?("Flow Payment: VISA ending with 1111"))
        assert(response.body.include?("ord-7d170417473c43c99d7ea88f938bfebb"))

        assert(response.body.include?(I18n.t('workarea.admin.orders.view_flow_order')))
      end
    end
  end
end
