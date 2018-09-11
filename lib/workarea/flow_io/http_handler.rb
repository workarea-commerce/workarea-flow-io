module Workarea
  module FlowIo
    class HttpHandler < ::Io::Flow::V0::HttpClient::DefaultHttpHandler
      attr_reader :open_timeout, :read_timeout, :logger, :options

      def initialize(open_timeout:, read_timeout:, logger:, **options)
        @open_timeout = open_timeout
        @read_timeout = read_timeout
        @logger       = logger
        @options      = options
      end

      def instance(base_uri, _path)
        HttpHandlerInstance.new(base_uri, open_timeout: open_timeout, read_timeout: read_timeout, logger: logger, **options)
      end
    end

    class HttpHandlerInstance < ::Io::Flow::V0::HttpClient::DefaultHttpHandlerInstance
      def initialize(base_uri, **options)
        super(base_uri)
        client.open_timeout = options[:open_timeout] if options[:open_timeout]
        client.read_timeout = options[:read_timeout] if options[:read_timeout]
        client.set_debug_output(options[:logger]) if options[:logger]
      end
    end
  end
end
