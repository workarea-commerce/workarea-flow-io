require 'test_helper'

module Workarea
  module Storefront
    class UserFlowOrdersIntegrationTest < Workarea::SystemTest
      include Workarea::FlowIo::FlowFixtures

      def test_viewing_flow_orders_in_user
        user = create_user
        order = create_placed_canadian_flow_order
        order.update_attributes(user_id: user.id)

        set_current_user(user)

        visit storefront.users_account_path

        assert page.has_text?(232.31)

        visit storefront.users_order_path(order)

        assert page.has_text?("$9.29")
      end
    end
  end
end
