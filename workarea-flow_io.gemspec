$:.push File.expand_path("lib", __dir__)

require "workarea/flow_io/version"

Gem::Specification.new do |s|
  s.name        = "workarea-flow_io"
  s.version     = Workarea::FlowIo::VERSION
  s.authors     = ["Eric Pigeon"]
  s.email       = ["epigeon@weblinc.com"]
  s.homepage    = ""
  s.summary     = "Flow Commerce integration for Workarea"
  s.description = "Integration Flow Commerce internationl checkout"

  s.files = `git ls-files`.split("\n")

  s.add_dependency 'workarea', '~> 3.x', ">= 3.3.0", "< 3.4.0"
  s.add_dependency 'flowcommerce', ">= 0.2.69"
  s.add_dependency 'flowcommerce-activemerchant', ">= 0.1.3"
end
