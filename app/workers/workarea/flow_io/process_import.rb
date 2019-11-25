module Workarea
  module FlowIo
    # Reads the CSV stored in a `Workarea::FlowIo::Import`, and
    # processes each row with `FlatFileItem.import`
    class ProcessImport
      include Sidekiq::Worker
      include Sidekiq::CallbacksWorker

      sidekiq_options \
        lock: :until_executing,
        enqueue_on: { Import => [:create] }

      def perform(id)
        import = Import.find(id)

        import.update!(started_at: Time.current)

        CSV.foreach(import.file_path, headers: true) do |row|
          ImportedItem.process(row)
        end

        import.update!(completed_at: Time.current)
      end
    end
  end
end
