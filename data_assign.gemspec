# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'data_assign/version'

Gem::Specification.new do |spec|
  spec.name          = 'data_assign'
  spec.version       = DataAssign::VERSION
  spec.authors       = ['Axel Wahlen']
  spec.email         = ['axel.wahlen@mixxt.de']
  spec.summary       = %q{ Assign data to another structure through a mapping }
  spec.description   = %q{ Assign data to another structure through a mapping }
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.2'
end
