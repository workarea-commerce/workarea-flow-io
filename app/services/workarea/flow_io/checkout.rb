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

      def place_order
        return false unless shipping.valid?
        return false unless payment.valid?

        inventory.purchase
        return false unless inventory.captured?

        unless payment_collection.purchase
          inventory.rollback
          return false
        end

        result = order.place

        if result
          CreateFulfillment.new(order).perform
          SaveOrderAnalytics.new(order).perform
        end

        result
      end

      def build
        order.update_attributes!(
          flow: true,
          email: customer.email
        )

        FlowIo::PriceApplier.perform(order: pricing_order, flow_order: flow_order, shipping: pricing_shipping)
        shipping.update_attributes!(pricing_shipping.as_document)

        # set the shipping service.
        shipping.set_flow_shipping!(flow_shipping_method)

        # set the shipping and billing addresses
        shipping.set_address(shipping_address_params(flow_order.destination))
        payment.set_address(billing_address_params(flow_payments.first.address))


        # Out of the box the payments will be authed and captured by flow
        # at the time of purchase, these tenders are generated to
        # keep the order modeling intact.
        flow_payments.each do |flow_payment|
          payment.build_flow_payment(
            details: flow_payment.to_hash,
            payment_type: flow_payment.type,
            description: flow_payment.description,
            amount: Money.from_amount(flow_payment.total.base.amount, flow_payments.first.total.base.currency),
            flow_amount: Money.from_amount(flow_payment.total.amount, flow_payments.first.total.currency)
          )
        end
        payment.save!

        total_order

        order.update_attributes!(pricing_order.as_document.reverse_merge(items: []))
      end

      private

        # creates a clone of the persisted shipping
        def pricing_shipping
          @pricing_shipping ||=
            begin
              result = shipping.clone
              result.id = shipping.id # Ensure this isn't persisted
              result.reset_adjusted_shipping_pricing
              result
            end
        end

        def pricing_order
          @pricing_order ||=
            begin
              result = @order.clone
              result.id = @order.id # Ensure this isn't persisted

              # This exists to fix a problem with doing price_adjustments = [] on
              # an unpersisted Order::Item on MongoDB >= 2.6 (which works on 2.4).
              # On 2.4 it doesn't try to make the write so all is fine. I have no
              # idea why this is required only on that version, but it does fix
              # the problem.
              #
              result.attributes = clone_order_attributes
              result
            end
        end

        def clone_order_attributes
          attributes = @order.as_document.except('_id', 'id')

          if attributes['items'].present?
            attributes['items'].each do |item|
              item['price_adjustments'] = []
              item['flow_price_adjustments'] = []
            end
          end

          attributes
        end

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
          Pricing::OrderTotals.new(pricing_order, [shipping]).total

          order.save!
          shipping.save!
        end

        def inventory
          @inventory ||= Inventory::Transaction.from_order(
            order.id,
            order.items.inject({}) do |memo, item|
              memo[item.sku] ||= 0
              memo[item.sku] += item.quantity
              memo
            end
          )
        end

        def payment_collection
          wa_checkout = Workarea::Checkout.new(order)
          @payment_collection ||= Workarea::Checkout::CollectPayment.new(wa_checkout)
        end
    end
  end
end
