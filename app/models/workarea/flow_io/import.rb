module Workarea
  module FlowIo
    # Where import CSV is stored, as well as some other metadata
    # surrounding the processing of the aformentioned data.
    class Import
      include ApplicationDocument
      extend Dragonfly::Model

      field :name, type: String
      field :file_uid, type: String
      field :started_at, type: Time
      field :completed_at, type: Time

      dragonfly_accessor :file, app: :workarea

      delegate :path, to: :file, prefix: true

      validates :name, presence: true, uniqueness: true

      index({ name: 1 }, { unique: true, background: true })
      index(
        { created_at: 1 },
        { expire_after_seconds: Workarea.config.data_file_operation_ttl.seconds.to_i }
      )

      def complete?
        completed_at.present?
      end
    end
  end
end
