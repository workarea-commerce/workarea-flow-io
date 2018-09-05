module Workarea
  module FlowIo
    class SessionMiddleware
      include Rack::Utils

      def initialize(app)
        @app = app
      end

      def call(env)
        flow_session = FlowIo::Session.new(env)

        env['Vary'] = 'X-Requested-With, X-Flash-Messages, X-Flow-Experience'
        env['HTTP_X_FLOW_EXPERIENCE'] = flow_session.experience&.key

        status, headers, body = @app.call env

        if %r{text/html}.match? headers['Content-Type']
          if flow_session.set_f60_session_cookie?
            set_cookie_header!(headers, "_f60_session", {
              value: flow_session.id,
              path: "/",
              expires: 1.year.from_now
            })
          end

          if flow_session.set_flow_experience_cookie?
            experince_cookie_value =
              if flow_session.experience.present?
                JSON.generate(flow_session.experience.to_hash)
              else
                ""
              end

            set_cookie_header!(headers, "flow_experience", {
              value: experince_cookie_value,
              path: "/",
              expires: 1.year.from_now
            })
          end
        end

        [status, headers, body]
      end
    end
  end
end
