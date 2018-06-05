$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "workarea/flow_io/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "workarea-flow_io"
  s.version     = Workarea::FlowIo::VERSION
  s.authors     = ["Eric Pigeon"]
  s.email       = ["epigeon@weblinc.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of FlowIo."
  s.description = "TODO: Description of FlowIo."
  
  s.files = `git ls-files`.split("\n")

  s.add_dependency 'workarea', '~> 3.x'
end
