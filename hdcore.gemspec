# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hdcore/version'

Gem::Specification.new do |spec|
  spec.name          = "hdcore"
  spec.version       = Hdcore::VERSION
  spec.authors       = ["Ethan Pemble"]
  spec.email         = ["ethan.p@hostdime.com"]
  spec.description   = "A basic wrapper for HostDime's customer portal 'Core' API"
  spec.summary       = ""
  spec.homepage      = "https://github.com/hostdime/hdcore"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.13"
  spec.add_dependency "httparty", "~> 0.11"
end
