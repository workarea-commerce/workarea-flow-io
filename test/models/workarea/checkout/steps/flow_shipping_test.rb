require 'test_helper'

module Workarea
  class Checkout
    module Steps
      class FlowShippingTest < TestCase
        setup :set_product, :set_addresses

        def set_product
          create_product(id: 'PROD')
        end

        def set_addresses
          address_params = {
            first_name:   'Ben',
            last_name:    'Crouse',
            street:       '22 S. 3rd St.',
            city:         'Philadelphia',
            region:       'PA',
            postal_code:  '19106',
            country:      'US',
            phone_number: '2159251800'
          }

          Addresses.new(checkout).update(
            shipping_address: address_params,
            billing_address: address_params
          )
        end

        def order
          @order ||= create_order(
            email: 'test@workarea.com',
            flow: true,
            items: [{ product_id: 'PROD', sku: 'SKU' }]
          )
        end

        def checkout
          @checkout ||= Checkout.new(order)
        end

       def step
          @step ||= Checkout::Steps::Shipping.new(checkout)
        end

        def test_update
          # base would throw a "NoAvailableShippingOption" error
          # if trying to set the service to a option that does not exist
          assert_nothing_raised do
            step.update(shipping_service: 'Flow Shipping Service', flow_order: true)
          end
        end
      end
    end
  end
end
