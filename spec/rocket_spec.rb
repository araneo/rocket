require File.expand_path("../spec_helper", __FILE__)

describe Rocket do
  subject do
    Rocket
  end
  
  it "#version should be valid" do
    subject.version.should =~ /\d+(.\d+){1,2}.*/
  end
  
  describe "#logger=" do
    it "should set given logger" do
      subject.logger = :testing
      subject.instance_variable_get("@logger").should == :testing
    end
  end
  
  describe "#logger" do
    before do
      subject.instance_variable_set("@logger", nil) 
    end
    
    it "should return default logger when other is not specified" do
      subject.expects(:default_logger).returns(:test)
      subject.logger.should == :test
    end
    
    it "should return specified logger" do
      subject.logger = :testing
      subject.logger.should == :testing
    end
  end
end
