$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

ENV['ROCKET_ENV'] = "test"

require 'rubygems'
require 'mocha'
require 'rspec'
require 'fileutils'
require 'rocket'

RSpec.configure do |config|
  config.mock_with :mocha
end
