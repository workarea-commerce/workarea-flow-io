# This throws an *absurd* amount of deprecation warnings when running
# tests, making it pretty impossible to see what you're doing. It's due
# to the gem running in Ruby 2.6, which deprecated `BigDecimal.new` and
# replaced it with the `BigDecimal()` method. Every time
# `Helper.to_big_decimal` is called by the FlowCommerce gem, we get a
# big old deprecation warning in the console. This should silence those
# warnings until https://github.com/flowcommerce/ruby-sdk/issues/25 is
# resolved.
module Io
  module Flow
    module V0
      module HttpClient
        module Helper
          def Helper.to_big_decimal(value)
            return unless value.present?

            BigDecimal(value.to_s)
          end
        end
      end
    end
  end
end
