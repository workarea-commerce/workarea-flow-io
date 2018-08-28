module Workarea
  module FlowIo
    class HttpHandler < ::Io::Flow::V0::HttpClient::DefaultHttpHandler
      attr_reader :open_timeout, :read_timeout

      def initialize(open_timeout:, read_timeout:)
        @open_timeout = open_timeout
        @read_timeout = read_timeout
      end

      def instance(base_uri, _path)
        HttpHandlerInstance.new(base_uri, open_timeout: open_timeout, read_timeout: read_timeout)
      end
    end

    class HttpHandlerInstance < ::Io::Flow::V0::HttpClient::DefaultHttpHandlerInstance
      def initialize(base_uri, **options)
        super(base_uri)
        client.open_timeout = options[:open_timeout] if options[:open_timeout]
        client.read_timeout = options[:read_timeout] if options[:read_timeout]
      end
    end
  end
end
