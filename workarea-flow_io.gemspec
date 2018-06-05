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

  s.add_dependency 'workarea', '~> 3.x'
  s.add_dependency 'flowcommerce'
end
