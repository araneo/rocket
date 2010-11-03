# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rocket-js}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Araneo", "Chris Kowalik"]
  s.date = %q{2010-11-03}
  s.description = %q{
This library is client that allows JavaScript clients to connect to the 
Rocket web socket server.
}
  s.email = %q{chris@nu7hat.ch}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.md"
  ]
  s.files = [
    ".gitignore",
     "LICENSE",
     "README.md",
     "Rakefile",
     "bin/rocket-js",
     "lib/rocket-js.rb",
     "lib/rocket/js.rb",
     "lib/rocket/js/builder.rb",
     "lib/rocket/js/cli.rb",
     "lib/rocket/js/version.rb",
     "rocket-0.0.1.min.js",
     "rocket-js.gemspec",
     "spec/js/app.rb",
     "spec/js/public/WebSocketMain.swf",
     "spec/js/public/favicon.ico",
     "spec/js/public/jquery-1.4.2.min.js",
     "spec/js/public/qunit.css",
     "spec/js/public/qunit.js",
     "spec/js/public/test.js",
     "spec/js/public/testing/WebSocketMain.swf",
     "spec/js/public/testing/WebSocketMainInsecure.zip",
     "spec/js/public/testing/rocket-0.0.1.js",
     "spec/js/views/index.erb",
     "spec/ruby/spec_helper.rb",
     "src/rocket.channels.js",
     "src/rocket.core.js",
     "src/rocket.defaults.js",
     "src/rocket.license.js",
     "src/vendor/json/json2.js"
  ]
  s.homepage = %q{http://github.com/araneo/rocket}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{JavaScript client library for Rocket server.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<json>, ["~> 1.4"])
      s.add_runtime_dependency(%q<yui-compressor>, ["~> 0.9"])
      s.add_development_dependency(%q<rspec>, ["~> 2.0"])
      s.add_development_dependency(%q<mocha>, ["~> 0.9"])
      s.add_development_dependency(%q<jasmine>, ["~> 1.0"])
    else
      s.add_dependency(%q<json>, ["~> 1.4"])
      s.add_dependency(%q<yui-compressor>, ["~> 0.9"])
      s.add_dependency(%q<rspec>, ["~> 2.0"])
      s.add_dependency(%q<mocha>, ["~> 0.9"])
      s.add_dependency(%q<jasmine>, ["~> 1.0"])
    end
  else
    s.add_dependency(%q<json>, ["~> 1.4"])
    s.add_dependency(%q<yui-compressor>, ["~> 0.9"])
    s.add_dependency(%q<rspec>, ["~> 2.0"])
    s.add_dependency(%q<mocha>, ["~> 0.9"])
    s.add_dependency(%q<jasmine>, ["~> 1.0"])
  end
end

