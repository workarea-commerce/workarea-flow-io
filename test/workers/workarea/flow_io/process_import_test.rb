require 'test_helper'

module Workarea
  module FlowIo
    class ProcessImportTest < TestCase
      def test_process_stored_csv
        file = FlowIo::Engine.root.join(
          'test', 'fixtures', 'files', 'example.csv'
        )

        assert_difference -> { Pricing::Sku.count }, 3 do
          Sidekiq::Callbacks.enable ProcessImport do
            Import.create!(name: file.basename, file: file.open)
          end
        end

        import = Import.last

        refute_nil(import.started_at)
        refute_nil(import.completed_at)
      end
    end
  end
end
