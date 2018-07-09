module Workarea
  module FlowIo
    class SessionMiddleware
      def initialize(app)
        @app = app
      end

      def call(env)
        request = ActionDispatch::Request.new(env)
        cookies = request.cookie_jar

        if FlowIo::Session.needs_sync?(request)
          env["rack-cache.force-pass"] = true
        else
          flow_session = ::Io::Flow::V0::Models::Session.from_json(JSON.parse(cookies[:flow_io]))
          env["flow.io.session"] = flow_session
          env['Vary'] = 'X-Requested-With, X-Flash-Messages, X-Flow-Experience'
          env['X-Flow-Experience'] = flow_session&.experience&.key
        end

        @app.call env
      end
    end
  end
end
