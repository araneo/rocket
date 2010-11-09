# -*- ruby -*-
$:.unshift(File.expand_path('../lib', __FILE__))
$:.unshift(File.expand_path('../../rocket/lib', __FILE__))
require 'rocket/version'

Gem::Specification.new do |s|
  s.name               = 'rocket-server'
  s.version            = Rocket.version
  s.homepage           = 'http://github.com/araneo/rocket'
  s.email              = ['chris@nu7hat.ch']
  s.authors            = ['Araneo Ltd.', 'Chris Kowalik']
  s.summary            = %q{Fast and extensible web socket server built upon em-websockets.}
  s.description        = %q{This is a fast web socket server built on awesome EventMachine with em-websockets help. It provides easy to use, event-oriented middleware for your web-socket powered applications.}
  s.files              = `git ls-files`.split("\n")
  s.test_files         = `git ls-files -- {spec}/*`.split("\n")
  s.require_paths      = %w[lib]
  s.extra_rdoc_files   = %w[LICENSE README.md]
  s.executables        = %w[rocket-server]
  s.default_executable = 'rocket-server'

  s.add_runtime_dependency     'rocket-core',    [Rocket.version]
  s.add_runtime_dependency     'json',           ['>= 1.4']
  s.add_runtime_dependency     'eventmachine',   [">= 0.12"]
  s.add_runtime_dependency     'em-websocket',   ['>= 0.1.4']
  s.add_runtime_dependency     'logging',        ['~> 1.4']
  s.add_runtime_dependency     'daemons',        ['~> 1.1']
  s.add_runtime_dependency     'konfigurator',   ['>= 0.1.1']
  s.add_runtime_dependency     'optitron',       ['>= 0.2']
  s.add_development_dependency 'rspec',          ["~> 2.0"]
  s.add_development_dependency 'mocha',          [">= 0.9"]
end
