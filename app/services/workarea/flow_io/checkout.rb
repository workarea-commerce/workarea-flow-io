module Workarea
  module FlowIo
    class Checkout
      include Workarea::ApplicationHelper

      attr_reader :order, :flow_order

      def initialize(flow_order, order)

        @order = order
        @flow_order = flow_order
      end

      def build
        checkout = Workarea::Checkout.new(order)

        # apply the shipping price adjustments to the shipping model
        shipping.set_flow_shipping!(shipping_service, shipping_amount)

        # re run priing to get the new adjustments
        Pricing.perform(order, shipping)

        checkout.update(
          flow_order: true,
          email: customer.email,
          shipping_address: shipping_address_params(flow_order.order.destination),
          billing_address: billing_address_params(flow_payments.first.address),
          shipping_service: shipping_service
        )

        # Out of the box the payments will be authed and captured by flow
        # at the time of purchase, these tenders are generated to
        # keep the order modeling intact.
        flow_payments.each do |flow_payment|
          checkout.payment.build_flow_payment(
            details: flow_payment.to_hash,
            payment_type: flow_payment. type,
            description: flow_payment.description,
            amount: flow_payment.total.amount)
        end

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
            phone_number: address.contact.phone
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
            country: country
          }
        end

        def flow_payments
          flow_order.order.payments
        end

        def customer
          @customer ||= flow_order.order.customer
        end

        def get_region_by_name(country, region_name)
          reg, _reg_struct = country.subdivisions.detect { |k,v| v.name == region_name }
          reg
        end

        def flow_shipping_method_ids
          @flow_shipping_method_ids ||= flow_order.order.selections
        end

        def flow_shipping_method
          method_id = flow_shipping_method_ids.first

          delivery = flow_order.order.deliveries.detect do |d|
            d.options.detect do  |o|
              o.id == method_id
            end
          end

          delivery.options.detect { |o|  o.id == method_id }
        end

        def shipping_service
          flow_shipping_method.tier.name
        end

        def shipping_amount
          flow_shipping_method.cost.amount
        end

        def payment
          @payment ||= Payment.find_or_create_by(id: order.id)
        end

        def shipping
          @shippipng ||=  Shipping.find_or_create_by(order_id: order.id)
        end
    end
  end
end