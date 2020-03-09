module Workarea
  module FlowIo
    class Session
      attr_reader :request

      def initialize(env)
        @request = ActionDispatch::Request.new(env)
        @set_f60_session_cookie = false
      end

      def experience
        if cookies.key?("flow_experience")
          experience_from_cookies
        else
          session.experience
        end
      end

      def flow_country
        if cookies.key?("flow_country")
          cookies["flow_country"]
        else
          session&.geo&.country&.iso_3166_3&.downcase
        end
      end

      def id
        session.id
      end

      def session
        @session ||= session_from_cookies || create_session!
      end

      def set_f60_session_cookie?
        @set_f60_session_cookie || !cookies.key?('_f60_session')
      end

      def set_flow_experience_cookie?
        !cookies.key?('flow_experience')
      end

      def set_flow_country_cookie?
        !cookies.key?('flow_country')
      end

      private

        delegate :params, to: :request

        # gets session id from cookies and pulls it from Flow API
        # if the request 404s creates a new session
        def session_from_cookies
          return unless cookies['_f60_session'].present?

          FlowIo.client.sessions.get_by_session(cookies['_f60_session'])
        rescue ::Io::Flow::V0::HttpClient::ServerError => error
          if error.code == 404
            @set_f60_session_cookie = true
            return create_session!
          else
            raise error
          end
        end

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
