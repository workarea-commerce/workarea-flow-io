class Rack::Attack
  safelist('allow flow webhooks') do |req|
    auth = Rack::Auth::Basic::Request.new(req.env)

    auth.provided? && auth.credentials == [
      Workarea::FlowIo.webhook_username,
      Workarea::FlowIo.webhook_password
    ]
  end
end
