require File.expand_path("../spec_helper", __FILE__)

describe Rocket do
  subject do
    Rocket
  end
  
  it "#version should be valid" do
    subject.version.should =~ /\d+(.\d+){1,2}.*/
  end
  
  describe "#log" do
    subject do
      Rocket.log
    end
    
    it "should respond to all logger-specific methods" do
      subject.should respond_to(:debug)
      subject.should respond_to(:info)
      subject.should respond_to(:error)
      subject.should respond_to(:warn)
      subject.should respond_to(:fatal)
    end
  end
end
