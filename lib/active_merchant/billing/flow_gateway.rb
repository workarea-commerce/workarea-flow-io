ActiveMerchant::Billing::FlowGateway.class_eval do
  def authorize amount, payment_method, options={}
    amount = assert_currency options[:currency], amount

    token = if payment_method.is_a?(String)
      payment_method
    else
      response = get_flow_cc_token payment_method
      response.token
    end

    data = {
      token:    token,
      amount:   amount,
      currency: options[:currency],
    }.merge!(options[:customer])


    begin
      authorization_form = if options[:order_id]
        # order_number allready present at flow
        data[:order_number] = options[:order_id]
        ::Io::Flow::V0::Models::MerchantOfRecordAuthorizationForm.new data
      else
        ::Io::Flow::V0::Models::DirectAuthorizationForm.new data
      end

      response = flow_instance.authorizations.post @flow_organization, authorization_form
    rescue => exception

      return ::ActiveMerchant::Billing::ResponseResponse.new false, exception.message, { exception: exception }
    end

    # clean up response so it can be properly serialized into Mongoid.
    response_options = { response: response.to_hash }
    response_amount = response_options[:response][:amount]
    response_options[:response][:amount] = response_amount.to_i

    if response.result.status.value == 'authorized'
      store = {      key: response.key,
                  amount: response.amount.to_i,
                currency: response.currency,
        authorization_id: response.id
      }

      ::ActiveMerchant::Billing::Response.new true, 'Flow authorize - Success', response_options, { authorization: store }
    else
      ::ActiveMerchant::Billing::Response.new false, 'Flow authorize - Error', response_options
    end
  end

  def capture _money, authorization, options={}
    raise ArgumentError, 'No Authorization authorization, please authorize first' unless authorization

    begin
      capture_form = ::Io::Flow::V0::Models::CaptureForm.new authorization
      response     = flow_instance.captures.post @flow_organization, capture_form
    rescue => exception
      error_response exception
    end


    response_options = { response: response.to_hash }
    response_amount = response_options[:response][:amount]
    response_options[:response][:amount] = response_amount.to_i

    options = { response: response_options }

    if response.id
      ::ActiveMerchant::Billing::Response.new true, 'Flow capture - Success', response_options
    else
      ::ActiveMerchant::Billing::Response.new false, 'Flow capture - Error', response_options
    end
  end
end
