module Workarea
  module Admin
    class FlowImportsController < Admin::ApplicationController
      def index
        @flow_imports = FlowImportsViewModel.new(nil, view_model_options)
      end
    end
  end
end
