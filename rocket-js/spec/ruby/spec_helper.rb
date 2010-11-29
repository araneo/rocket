require File.expand_path("../../../load_paths", __FILE__)

require 'mocha'
require 'rspec'
require 'rocket-js'

RSpec.configure do |config|
  config.mock_with :mocha
end
