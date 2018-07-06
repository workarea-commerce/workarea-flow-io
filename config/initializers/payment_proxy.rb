if ENV['HTTP_PROXY'].present?
  uri = URI.parse(ENV['HTTP_PROXY'])
  ActiveMerchant::Billing::FlowGateway.proxy_address = uri.host
  ActiveMerchant::Billing::FlowGateway.proxy_port = uri.port
end
