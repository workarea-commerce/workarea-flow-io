module Workarea
  class TestCase
    setup :clear_flow_bogus_client_requests

    private

      def clear_flow_bogus_client_requests
        Workarea::FlowIo::BogusClient.reset_requests!
      end
  end
end
