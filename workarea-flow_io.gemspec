$:.push File.expand_path("lib", __dir__)

require "workarea/flow_io/version"

Gem::Specification.new do |s|
  s.name        = "workarea-flow_io"
  s.version     = Workarea::FlowIo::VERSION
  s.authors     = ["Eric Pigeon"]
  s.email       = ["epigeon@weblinc.com"]
  s.homepage    = 'https://plugins.workarea.com/plugins/flow-io'
  s.summary     = 'Flow Commerce integration for the Workarea Commerce Platform'
  s.description = "Integrate Flow Commerce's international payments into the Workarea Commerce Platform"

  s.files = `git ls-files`.split("\n")

  s.add_dependency 'workarea', '~> 3.x', ">= 3.4.0"
  s.add_dependency 'flowcommerce', ">= 0.2.69"
  s.add_dependency 'flowcommerce-activemerchant', ">= 0.1.3"
  s.add_dependency 'net-sftp', '~> 2.1.2'
end
