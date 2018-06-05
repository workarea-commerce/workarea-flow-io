Workarea.configure do |config|
  config.flow_io ||= ActiveSupport::Configurable::Configuration.new

  config.flow_io.image_sizes = [:small_thumb, :detail]

  # The locale in which the content of the catalog is written.
  config.flow_io.original_locale = "en_US"
end
