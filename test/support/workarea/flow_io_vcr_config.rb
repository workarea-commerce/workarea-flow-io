module Workarea
  module FlowIoVCRConfig
    def self.included(test)
      super
      test.setup :setup_gateway
      test.teardown :reset_gateway
    end

    def setup_gateway
      @_old_creds = Rails.application.secrets.flow_io
      Rails.application.secrets.flow_io = {
        api_token: 'G8jRexBBQveuLL2s6TQfcIi6NvCjxcB47gwnvcdl4xUNPEJzBUtgxtoPQ6FER6iJLfxmS4gx3Bqz0xTNn2VgzyWNh8SXqLtnJpcfMba7eh8r8lMA4VwlNV3mIBMe0A5r',
        organization_id: 'workarea-sandbox',
        test: true
      }
    end

    def reset_gateway
      Rails.application.secrets.flow_io = @_old_creds
    end
  end
end
