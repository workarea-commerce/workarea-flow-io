class Io::Flow::V0::Models::Price
  def to_m
    Money.from_amount(amount, currency)
  end
end

class Io::Flow::V0::Models::LocalizedItemPrice
  def to_m
    Money.from_amount(amount, currency)
  end
end

class Io::Flow::V0::Models::LocalizedLineItemDiscount
  def to_m
    Money.from_amount(amount, currency)
  end
end

class ::Io::Flow::V0::Models::OrderPriceDetail
  def to_m
    Money.from_amount(amount, currency)
  end
end

class ::Io::Flow::V0::Models::PriceWithBase
  def to_m
    Money.from_amount(amount, currency)
  end
end

class ::Io::Flow::V0::Models::CardAuthorization
  delegate :to_bson, to: :to_hash

  def bson_type
    to_hash.bson_type
  end
end

class ::Io::Flow::V0::Models::Capture
  delegate :to_bson, to: :to_hash

  def bson_type
    to_hash.bson_type
  end
end

class ::Io::Flow::V0::Models::Refund
  delegate :to_bson, to: :to_hash

  def bson_type
    to_hash.bson_type
  end
end

# This throws an *absurd* amount of deprecation warnings when running
# tests, making it pretty impossible to see what you're doing. It's due
# to the gem running in Ruby 2.6, which deprecated `BigDecimal.new` and
# replaced it with the `BigDecimal()` method. Every time
# `Helper.to_big_decimal` is called by the FlowCommerce gem, we get a
# big ol' deprecation warning in the console. This should silence those
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
