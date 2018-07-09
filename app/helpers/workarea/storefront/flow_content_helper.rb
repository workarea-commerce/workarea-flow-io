module Workarea
  module Storefront
    module FlowContentHelper
      def render_content_blocks(blocks)
        if current_user.try(:admin?)
          render_content_blocks_without_cache(blocks)
        else
          cache_key = [
            flow_experience&.key,
            blocks.map(&:cache_key).join('/')
          ].compact.join('/')

          Rails.cache.fetch(
            cache_key,
            expires_in: Workarea.config.cache_expirations.render_content_blocks
          ) { render_content_blocks_without_cache(blocks) }
        end
      end
    end
  end
end
