module Workarea
  module FlowIo
    class Webhook
      class SharedSecret
        include ApplicationDocument
        include UrlToken

        validates :token, presence: true
      end
    end
  end
end
