# -*- ruby -*-
$:.unshift(File.expand_path('../lib', __FILE__))
$:.unshift(File.expand_path('../../rocket/lib', __FILE__))
require 'rocket/version'

Gem::Specification.new do |s|
  s.name               = 'rocket'
  s.version            = Rocket.version
  s.homepage           = 'http://github.com/araneo/rocket'
  s.email              = ['chris@nu7hat.ch']
  s.authors            = ['Araneo Ltd.', 'Chris Kowalik']
  s.summary            = %q{Event-oriented WebSockets server and toolkit.}
  s.description        = %q{Rocket is a very fast and reliable web socket server built upon em-websockets library. Rocket provides also JavaScript toolkit to serve up instructions to clients, and ruby library which handles events triggering. This Project was strongly inspired by awesome PusherApp.}
  s.files              = `git ls-files`.split("\n")
  s.test_files         = `git ls-files -- {spec}/*`.split("\n")
  s.require_paths      = %w[lib]
  s.extra_rdoc_files   = %w[LICENSE README.md]

  s.add_runtime_dependency     'rocket-core',   [Rocket.version]
  s.add_runtime_dependency     'rocket-js',     [Rocket.version]
  s.add_runtime_dependency     'rocket-server', [Rocket.version]
  s.add_development_dependency 'rspec',         ["~> 2.0"]
  s.add_development_dependency 'mocha',         [">= 0.9"]
end
