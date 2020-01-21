module Workarea
  module FlowIo
    class BogusClient
      class Webhooks
        def post(org_id, form)
          puts 'WARNING: Bogus Client in use. Your webhooks were not created.'
        end
      end
    end
  end
end
