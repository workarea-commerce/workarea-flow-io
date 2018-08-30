class Rack::Attack
  safelist('allow flow webhooks') do |req|
    request_signature = req.env['HTTP_X_FLOW_SIGNATURE']

    next false unless request_signature.present?

    body = req.body.read
    req.body.rewind

    Workarea::FlowIo::WebhookRequestSignature.valid?(
      request_signature: request_signature,
      request_body: body
    )
  end
end
