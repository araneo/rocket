require 'rubygems'
require 'rake'

require File.expand_path("../lib/rocket/version", __FILE__)

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.version = Rocket.version
    gem.name = "rocket"
    gem.email = "chris@nu7hat.ch"
    gem.homepage = "https://github.com/araneo/rocket"
    gem.authors = ["Araneo", "Kriss Kowalik"]
    gem.summary = %Q{Fast and extensible websocket server for Ruby.}
    gem.description = <<-DESC
      Rocket is a very fast and reliable websocket server built upon em-websockets library.
      Rocket provides also javascript toolkit to serve up instructions to clients. 
      All Rocket's behaviors was strongly inspired by awesome PusherApp. 
    DESC
    gem.add_dependency "optitron", "~> 0.2"
    gem.add_dependency "json", "~> 1.4"
    gem.add_dependency "eventmachine", ">= 0.12"
    gem.add_dependency "em-websocket", ">= 0.1.4"
    gem.add_dependency "logging", "~> 1.4"
    gem.add_dependency "daemons", "~> 1.1"
    gem.add_dependency "konfigurator", ">= 0.1.1"
    gem.add_development_dependency "rspec", "~> 2.0"
    gem.add_development_dependency "mocha", "~> 0.9"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'spec/**/*_spec.rb'
  t.rspec_opts = %q[--colour --backtrace]
end

RSpec::Core::RakeTask.new(:rcov) do |t|
  t.rcov = true
  t.rspec_opts = %q[--colour --backtrace]
  t.rcov_opts = %q[--exclude "spec" --text-report]
end

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "Rocket #{Rocket.version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
