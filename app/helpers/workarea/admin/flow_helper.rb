module Workarea
  module Admin
    module FlowHelper
      def default_currency
        Money.default_currency
      end

      def flow_currencies
        FlowIo::Experiences.all_currencies.map { |currency| Money::Currency.new(currency) }
      end
    end
  end
end
