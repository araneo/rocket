require File.expand_path("../spec_helper", __FILE__)

class HelpersPoweredClass
  include Rocket::Helpers
end

describe Rocket::Helpers do
  subject do
    HelpersPoweredClass.new
  end
  
  it "#log should be proxy to Rocket.logger" do
    subject.log.should == Rocket.logger
  end
  
  it "should respond to all log level-specific methods" do
    subject.should respond_to(:info)
    subject.should respond_to(:debug)
    subject.should respond_to(:warn)
    subject.should respond_to(:error)
    subject.should respond_to(:fatal)
  end
  
  describe "#symbolize_keys" do
    it "should return given object when it's not a Hash" do
      subject.symbolize_keys(obj = Object.new).should == obj
    end
    
    it "should symbolize given hash keys" do
      subject.symbolize_keys({"hello" => "world"}).should == {:hello => "world"}
    end
  end
end
