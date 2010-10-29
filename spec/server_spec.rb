require File.expand_path("../spec_helper", __FILE__)

describe Rocket::Server do
  subject do
    Rocket::Server
  end
  
  describe "#initialize" do
    it "should set options" do
      subject.new(1=>2).options.should == {1=>2}
    end
    
    context "when host and port given" do
      it "should set it properly" do
        serv = subject.new(:host => 'test.host', :port => 999)
        serv.host.should == 'test.host'
        serv.port.should == 999
      end
    end
    
    context "when no host or port given" do
      it "should set default values for it" do
        serv = subject.new
        serv.host.should == 'localhost'
        serv.port.should == 9772
      end
    end
  end
  
  describe "#stop!" do
    it "should stop EventMachine reactor" do
      EM.expects(:stop)
      subject.new.stop!
    end
  end
  
  describe "#start!" do
    it "should start server on given host and port" do
      EM.expects(:start_server).with("test.host", 9992, Rocket::Connection, instance_of(Hash))
      t = Thread.new { subject.new(:host => "test.host", :port => 9992).start! }
      t.kill
    end
  end
end
