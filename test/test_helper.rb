require 'simplecov'

SimpleCov.start "rails" do
  add_group "View Models", "app/view_models"
  add_group "Services", "app/services"
  add_group "Decorators", %r{.decorator$}

  add_filter 'lib/workarea/flow_io/version.rb'
  add_filter 'lib/active_merchant/billing/bogus_flow_gateway.rb'
  add_filter 'lib/workarea/flow_io/bogus_client.rb'
  add_filter 'lib/workarea/flow_io/bogus_client/orders.rb'

  # ignore coverage on base bug fixes
  add_filter 'app/controllers/workarea/storefront/recent_views_controller.decorator'
  add_filter 'app/view_models/workarea/storefront/user_activity_view_model.decorator'
  add_filter 'app/view_models/workarea/storefront/content_blocks/product_insights_view_model.decorator'
  add_filter 'app/view_models/workarea/storefront/content_blocks/category_summary_view_model.decorator'
  add_filter 'app/view_models/workarea/storefront/content_blocks/product_list_view_model.decorator'
  add_filter 'app/view_models/workarea/storefront/recommendations_view_model.decorator'
end

ENV['RAILS_ENV'] = 'test'

require File.expand_path("../../test/dummy/config/environment.rb", __FILE__)
require 'rails/test_help'
require 'workarea/test_help'

Minitest.backtrace_filter = Minitest::BacktraceFilter.new
