# -*- ruby -*-
$:.unshift(File.expand_path('../lib', __FILE__))
$:.unshift(File.expand_path('../../rocket/lib', __FILE__))
require 'rocket/version'

Gem::Specification.new do |s|
  s.name               = 'rocket-core'
  s.version            = Rocket.version
  s.homepage           = 'http://github.com/araneo/rocket'
  s.email              = ['chris@nu7hat.ch']
  s.authors            = ['Araneo Ltd.', 'Chris Kowalik']
  s.summary            = %q{Rocket core package.}
  s.description        = %q{Core utils used by various Rocket components.}
  s.files              = `git ls-files`.split("\n")
  s.test_files         = `git ls-files -- {spec}/*`.split("\n")
  s.require_paths      = %w[lib]
  s.extra_rdoc_files   = %w[LICENSE README.md]

  s.add_runtime_dependency     'json',           ['>= 1.4']
  s.add_development_dependency 'rspec',          ["~> 2.0"]
  s.add_development_dependency 'mocha',          [">= 0.9"]
end
