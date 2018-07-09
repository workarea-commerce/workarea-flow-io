module Workarea
  module FlowIo
    module FlowFixtures
      def europe_experience
        @europe_experience ||= build_flow_io_experience_summary(
          id: "exp-f9ec9be879a341ddb8a67e9a1f34775b",
          key: "europe",
          name: "Europe",
          country: "GBR",
          currency: "EUR",
          language: "en"
        )
      end

      def canada_experience
        @canada_experience ||= build_flow_io_experience_summary(
          _id: "exp-31b66afd8ac44a71a0669b2ad81a794d",
          key: "canada",
          name: "Canada",
          country: "CA",
          currency: "CAD",
          language: "en"
        )
      end
    end
  end
end
