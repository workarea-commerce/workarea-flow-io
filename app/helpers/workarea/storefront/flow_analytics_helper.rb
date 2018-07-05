module Workarea
  module Storefront
    module FlowAnalyticsHelper
      def product_analytics_data(product)
        super.merge(
          currency_code: product.sell_min_price&.currency&.iso_code,
        ).compact
      end

      def order_item_analytics_data(item)
        super.merge(currency_code: item.current_unit_price.currency.iso_code)
      end

      def order_analytics_data(order)
        super.merge(
          total_price_currency_code: order.total_price.currency.iso_code,
          shipping_total_currency_code: order.shipping_total.currency.iso_code,
          tax_total_currency_code: order.tax_total.currency.iso_code
        )
      end
    end
  end
end
