require 'test_helper'

module Workarea
  module Admin
    class FlowImportsIntegrationTest < Workarea::IntegrationTest
      include Admin::IntegrationTest

      def test_updates_data
        file = FlowIo::Engine.root.join(
          'test', 'fixtures', 'files', 'example.csv'
        )
        FlowIo::Import.create!(name: file.basename, file: file.open)

        get admin.flow_imports_path

        assert_includes(response.body, 'example.csv')
      end
    end
  end
end
