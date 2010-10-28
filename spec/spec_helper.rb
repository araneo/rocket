$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'
require 'mocha'
require 'rspec'
require 'rocket'

RSpec.configure do |config|
  config.mock_with :mocha
end

def stub_logger
  Rocket.log.stubs(:debug)
  Rocket.log.stubs(:error)
  Rocket.log.stubs(:info)
  Rocket.log.stubs(:fatal)
  Rocket.log.stubs(:warn)
end

def capture_output
  out, err = StringIO.new, StringIO.new
  begin
    $stdout, $stderr = out, err
    yield
  rescue
    $stdout, $stderr = STDOUT, STDERR
  end
  [out.string, err.string]
end
alias :silence_output :capture_output
