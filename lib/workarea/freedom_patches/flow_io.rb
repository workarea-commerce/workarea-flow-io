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
