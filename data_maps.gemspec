# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'data_maps/version'

Gem::Specification.new do |spec|
  spec.name          = 'data_maps'
  spec.version       = DataMaps::VERSION
  spec.authors       = ['Axel Wahlen']
  spec.email         = ['axel.wahlen@mixxt.de']
  spec.summary       = %q{ Maps data to another structure through a mapping }
  spec.description   = %q{ Maps data to another structure through a mapping }
  spec.homepage      = 'https://github.com/dino115/data_maps'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 1.9.2'

  spec.add_runtime_dependency 'activesupport', '~> 3.2', '>= 3.2.21'

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.2'
  spec.add_development_dependency 'simplecov', '~> 0.9.2'
  spec.add_development_dependency 'codeclimate-test-reporter', '~> 0.4.7'
end
