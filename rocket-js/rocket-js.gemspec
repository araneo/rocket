# -*- ruby -*-
$:.unshift(File.expand_path('../lib', __FILE__))
$:.unshift(File.expand_path('../../rocket/lib', __FILE__))
require 'rocket/version'

Gem::Specification.new do |s|
  s.name               = 'rocket-js'
  s.version            = Rocket.version
  s.homepage           = 'http://github.com/araneo/rocket'
  s.email              = ['chris@nu7hat.ch']
  s.authors            = ['Araneo Ltd.', 'Chris Kowalik']
  s.summary            = %q{JavaScript client library for Rocket server.}
  s.description        = %q{This library is client that allows JavaScript clients to connect to the Rocket web socket server.}
  s.files              = `git ls-files`.split("\n") + Dir["src/vendor/web-socket-js/**/*"]
  s.test_files         = `git ls-files -- {spec}/*`.split("\n")
  s.require_paths      = %w[lib]
  s.extra_rdoc_files   = %w[LICENSE README.md]
  s.executables        = %w[rocket-js]
  s.default_executable = 'rocket-js'

  s.add_runtime_dependency     'rocket-core',    [Rocket.version]
  s.add_runtime_dependency     'json',           ['>= 1.4']
  s.add_runtime_dependency     'yui-compressor', ['~> 0.9'] 
  s.add_development_dependency 'rspec',          ["~> 2.0"]
  s.add_development_dependency 'mocha',          [">= 0.9"]
  s.add_development_dependency 'jasmine',        ["~> 1.0"]
end
