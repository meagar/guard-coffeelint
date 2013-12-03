# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'guard/coffee_lint'

Gem::Specification.new do |spec|
  spec.name          = "guard-coffeelint"
  spec.version       = Guard::CoffeeLint::VERSION
  spec.authors       = ["Matthew Eagar"]
  spec.email         = ["me@meagar.net"]
  spec.description   = %q{Guard plugin for CoffeeLint}
  spec.summary       = %q{Guard plugin for CoffeeLint}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'guard', '~> 2.2.0'
  spec.add_dependency 'coffeelint', '~> 0.1.0'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
