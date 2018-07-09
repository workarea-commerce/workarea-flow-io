module Workarea
  module I18n
    module FlowIoConstraintOverride
      def routes_constraint
        Workarea::FlowIo::RoutingContraints.new
      end
    end

    self.singleton_class.prepend FlowIoConstraintOverride
  end
end
