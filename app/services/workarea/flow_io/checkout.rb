module Workarea
  module FlowIo
    class Checkout
      include Workarea::ApplicationHelper

      attr_reader :order, :flow_order

      # @param ::Io::Flow::V0::Models::Order,
      # @param  ::Workarea::Order
      def initialize(flow_order, order)
        @order = order
        @flow_order = flow_order
      end

      def build
        checkout = Workarea::Checkout.new(order)

        # apply the shipping price adjustments to the shipping model
        shipping.set_flow_shipping!(shipping_service, flow_shipping_prices)

        checkout.update(
          flow_order: true,
          email: customer.email,
          shipping_address: shipping_address_params(flow_order.destination),
          billing_address: billing_address_params(flow_payments.first.address),
          shipping_service: shipping_service
        )

        # Out of the box the payments will be authed and captured by flow
        # at the time of purchase, these tenders are generated to
        # keep the order modeling intact.
        flow_payments.each do |flow_payment|
          checkout.payment.build_flow_payment(
            details: flow_payment.to_hash,
            payment_type: flow_payment.type,
            description: flow_payment.description,
            amount: Money.from_amount(flow_payment.total.base.amount, flow_payments.first.total.base.currency),
            flow_amount: Money.from_amount(flow_payment.total.amount, flow_payments.first.total.currency)
          )
        end

        # update the order and shipping totals with the
        # new price adjusments
        total_order
        checkout.payment.save!

        checkout
      end

      private

        def shipping_address_params(address)
          country = Country.find_country_by_alpha3(address.country)
          region = get_region_by_name(country, address.province)

          {
            first_name: address.contact.name.first,
            last_name: address.contact.name.last,
            street: address.streets.first,
            street_2: address.streets.second,
            city: address.city,
            region: region,
            postal_code: address.postal,
            country: country,
            phone_number: address.contact.phone,
            flow: true
          }
        end

        def billing_address_params(address)
          country = Country.find_country_by_alpha3(address.country)
          region = get_region_by_name(country, address.province)
          {
            first_name: customer.name.first,
            last_name: customer.name.last,
            street: address.streets.first,
            street_2: address.streets.second,
            city: address.city,
            region: region,
            postal_code: address.postal,
            country: country,
            flow: true
          }
        end

        def flow_payments
          flow_order.payments
        end

        def customer
          @customer ||= flow_order.customer
        end

        def get_region_by_name(country, region_name)
          reg, _reg_struct = country.subdivisions.detect { |k, v| v.name == region_name }
          reg
        end

        def flow_shipping_method_ids
          @flow_shipping_method_ids ||= flow_order.selections
        end

        # @return ::Io::Flow::V0::Models::DeliveryOption
        def flow_shipping_method
          method_id = flow_shipping_method_ids.first

          delivery = flow_order.deliveries.detect do |d|
            d.options.detect do  |o|
              o.id == method_id
            end
          end

          delivery.options.detect { |o|  o.id == method_id }
        end

        # @return String
        def shipping_service
          flow_shipping_method.tier.name
        end

        def payment
          @payment ||= Payment.find_or_create_by(id: order.id)
        end

        def shipping
          @shippipng ||= Shipping.find_or_create_by(order_id: order.id)
        end

        # @return [::Io::Flow::V0::Models::OrderPriceDetail]
        def flow_shipping_prices
          flow_order.prices.reject { |p| p.name == 'Item subtotal' }
        end

        def total_order
          Pricing::ShippingTotals.new(shipping).total
          Pricing::OrderTotals.new(order, [shipping]).total

          order.save!
          shipping.save!
        end
    end
  end
end
