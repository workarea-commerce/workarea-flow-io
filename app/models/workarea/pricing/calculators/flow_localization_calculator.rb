module Workarea
  module Pricing
    module Calculators
      class FlowLocalizationCalculator
        include Calculator

        def adjust
          return unless order.experience.present?

          order_put_form = FlowIo::OrderPutForm.from(order: order, shippings: shippings)

          flow_order = FlowIo.client.orders.put_by_number(
            FlowIo.organization_id,
            order.id,
            order_put_form,
            experience: order.experience.key
          )

          FlowIo::PriceApplier.perform(order: order, flow_order: flow_order)
        end
      end
    end
  end
end
