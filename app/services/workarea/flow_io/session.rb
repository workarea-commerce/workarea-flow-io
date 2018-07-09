module Workarea
  module FlowIo
    class Session
      def self.needs_sync?(request)
        cookies = request.cookie_jar
        params = request.params

        cookies['_f60_session'].present? &&
          (cookies[:flow_io].blank? || params[:sync_country].present?)
      end
    end
  end
end
