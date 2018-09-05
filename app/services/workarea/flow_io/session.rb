module Workarea
  module FlowIo
    class Session
      attr_reader :request

      def initialize(env)
        @request = ActionDispatch::Request.new(env)
      end

      def experience
        if cookies.key?("flow_experience")
          experience_from_cookies
        else
          session.experience
        end
      end

      def id
        cookies['_f60_session'] || session.id
      end

      def session
        @session ||=
          if cookies['_f60_session'].blank?
            create_session!
          else
            FlowIo.client.sessions.get_by_session(cookies['_f60_session'])
          end
      end

      def set_f60_session_cookie?
        !cookies.key?('_f60_session')
      end

      def set_flow_experience_cookie?
        !cookies.key?('flow_experience')
      end

      private

        delegate :params, to: :request

        def create_session!
          Workarea::FlowIo.client.sessions.post_organizations_by_organization(
            Workarea::FlowIo.organization_id,
            { ip: request.remote_ip, country: country }.compact
          )
        end

        def experience_from_cookies
          return unless cookies["flow_experience"].present?

          ::Io::Flow::V0::Models::ExperienceGeo.new(JSON.parse(cookies[:flow_experience]))
        rescue
          nil
        end

        def country
          request.env['HTTP_GEOIP_CITY_COUNTRY_CODE3']
        end

        def cookies
          request.cookie_jar
        end
    end
  end
end
