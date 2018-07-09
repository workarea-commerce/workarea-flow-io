module Workarea
  module FlowIo
    class RoutingContraints
      def matches?(request)
        request.params[:locale].blank? ||
          FlowIo::Countries.all.any? { |c| c.iso_3166_2.downcase == request.params[:locale] }
      end
    end
  end
end
