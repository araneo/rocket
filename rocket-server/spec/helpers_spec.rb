require File.expand_path("../spec_helper", __FILE__)

class HelpersPoweredClass
  include Rocket::Server::Helpers
end

describe Rocket::Server::Helpers do
  subject do
    HelpersPoweredClass.new
  end
  
  it "#log should be proxy to Rocket::Server.logger" do
    subject.log.should == Rocket::Server.logger
  end
  
  it "should respond to all log level-specific methods" do
    subject.should respond_to(:log_info)
    subject.should respond_to(:log_debug)
    subject.should respond_to(:log_warn)
    subject.should respond_to(:log_error)
    subject.should respond_to(:log_fatal)
  end
end
