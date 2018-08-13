require 'test_helper'

module Workarea
  module FlowIo
    class ExperiencesTest < Workarea::TestCase
      def test_all_currencies
        currencies = Experiences.all_currencies

        assert_includes(currencies, "CAD")
        assert_includes(currencies, "EUR")
      end
    end
  end
end
