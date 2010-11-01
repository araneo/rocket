$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'
require 'mocha'
require 'rspec'
require 'fileutils'
require 'rocket'

Rocket.logger.appenders = nil

RSpec.configure do |config|
  config.mock_with :mocha
end

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
