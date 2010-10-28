require File.expand_path("../spec_helper", __FILE__)

describe Rocket::Server do
  subject do
    Rocket::Server
  end
  
  describe "#stop" do
    it "should stop EventMachine reactor" do
      EM.expects(:stop)
      subject.stop
    end
  end
  
  describe "#start" do
  
  end
end
