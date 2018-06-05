module Workarea
  module FlowIo
    class Engine < ::Rails::Engine
      include Workarea::Plugin
      isolate_namespace Workarea::FlowIo
    end
  end
end
