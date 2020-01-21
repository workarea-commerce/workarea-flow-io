module Workarea
  module Admin
    class FlowImportsViewModel < ApplicationViewModel
      def results
        @results ||= PagedArray.from(
          models,
          page,
          per_page,
          models.total_count
        )
      end

      def models
        @models ||= FlowIo::Import
          .all
          .page(page)
          .per(per_page)
          .order(created_at: :desc)
      end

      def ttl
        Workarea.config.data_file_operation_ttl
      end

      private

        def per_page
          Workarea.config.per_page
        end

        def page
          options[:page] || 1
        end
    end
  end
end
