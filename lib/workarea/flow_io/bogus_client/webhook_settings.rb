module Workarea
  module FlowIo
    class BogusClient
      class WebhookSettings
        def put(org_id, secret:)
          puts 'WARNING: Bogus Client in use. Your settings will not go to Flow'
        end
      end
    end
  end
end
