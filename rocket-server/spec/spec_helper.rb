require 'rubygems'
require 'mocha'
require 'rspec'
require 'fileutils'
require 'rocket-server'

RSpec.configure do |config|
  config.mock_with :mocha
end

Rocket::Server.logger.appenders = nil

def capture_output
  out, err = StringIO.new, StringIO.new
  begin
    $stdout, $stderr = out, err
    yield
  ensure
    $stdout, $stderr = STDOUT, STDERR
  end
  [out.string, err.string]
end
