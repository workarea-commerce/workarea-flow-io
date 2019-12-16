require 'test_helper'

module Workarea
  module FlowIo
    class ProcessImportTest < TestCase
      def test_process_stored_csv
        file_path = FlowIo::Engine.root.join( 'test', 'fixtures', 'files', 'example.csv')
        file = file_path.open

        assert_difference -> { Pricing::Sku.count }, 3 do
          Sidekiq::Callbacks.enable ProcessImport do
            Import.create!(name: file_path.basename, file: file)
          end
        end

        import = Import.last

        refute_nil(import.started_at)
        refute_nil(import.completed_at)
      ensure
        file&.close
      end
    end
  end
end
