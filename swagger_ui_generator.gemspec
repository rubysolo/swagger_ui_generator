# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'swagger_ui_generator/version'

Gem::Specification.new do |spec|
  spec.name          = "swagger_ui_generator"
  spec.version       = SwaggerUiGenerator::VERSION
  spec.authors       = ["Solomon White"]
  spec.email         = ["rubysolo@gmail.com"]
  spec.summary       = %q{Swagger UI Generator}
  spec.description   = %q{Rails generator to build Swagger UI API doc viewer}
  spec.homepage      = "http://github.com/rubysolo/swagger_ui_generator"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "nokogiri"
  spec.add_development_dependency "pry-nav"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rails", ">= 3.1"

  spec.add_runtime_dependency "railties", ">= 3.1"
end
