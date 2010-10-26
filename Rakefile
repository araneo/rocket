require 'rubygems'
require 'rake'

require File.expand_path("../lib/openaudit/websocket/version", __FILE__)

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.version = OpenAudit::Reporter.version
    gem.name = "openaudit-websocket"
    gem.email = "krzysztof.kowalik@araneo.pl"
    gem.homepage = "https://github.com/araneo/openaudit-websocket"
    gem.authors = ["Araneo"]
    gem.summary = %Q{OpenAudit websockets server.}
    gem.description = %Q{Websocket server for OpenAudit website.}
    gem.add_dependency "optitron", "~> 0.2"
    gem.add_dependency "json", "~> 1.4"
    gem.add_dependency "eventmachine", "~> 0.12"
    gem.add_dependency "em-websocket", ">= 0.1.4"
    gem.add_dependency "logging", "~> 1.4"
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
  rdoc.title = "OpenAudit Websocket #{OpenAudit::Websocket.version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
