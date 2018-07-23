module Workarea
  class Payment
    class Tender
      class FlowPayment < Tender
        field :details, type: Hash
        field :payment_type, type: String
        field :description, type: String

        def slug
          :flow_payment
        end
      end
    end
  end
end
