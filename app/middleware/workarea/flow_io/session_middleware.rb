module Workarea
  module FlowIo
    class SessionMiddleware
      include Rack::Utils

      def initialize(app)
        @app = app
      end

      def call(env)
        flow_session = FlowIo::Session.new(env)

        env['Vary'] = 'X-Requested-With, X-Flash-Messages'
        begin
          env['HTTP_X_FLOW_EXPERIENCE'] = flow_session.experience&.key
          env['flow.io.experience'] = flow_session.experience
          env['flow.io.country'] = flow_session.flow_country
        rescue => error
          capture_exception error
          return @app.call env
        end

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

          if flow_session.set_flow_country_cookie?
            set_cookie_header!(headers, "flow_country", flow_session.flow_country)
          end
        end

        [status, headers, body]
      end

      private

        def capture_exception(exception)
          if defined?(::Raven)
            Raven.capture_exception(exception)
          else
            Rails.logger.warn "Error in FlowIo::SessionMiddleware: #{exception}"
          end
        end
    end
  end
end
