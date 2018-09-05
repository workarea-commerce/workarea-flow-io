module Workarea
  module FlowBogusClientSupport
    def self.included(test)
      super
      test.setup :reset_bogus_client_requests
      test.teardown :stop_storing_requests
    end

    def reset_bogus_client_requests
      Workarea::FlowIo::BogusClient.store_requests = true
      Workarea::FlowIo::BogusClient.reset_requests!
    end

    def stop_storing_requests
      Workarea::FlowIo::BogusClient.store_requests = false
    end
  end
end
