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
    it "should start server on given host and port" do
      EM.expects(:start_server).with("test.host", 9992, Rocket::Connection, instance_of(Hash))
      t = Thread.new { subject.start(:host => "test.host", :port => 9992) }
      sleep(1)
      t.kill
    end
    
    context "when no given host on port" do
      it "should start server on localhost:9772" do
        EM.expects(:start_server).with("localhost", 9772, Rocket::Connection, instance_of(Hash))
        t = Thread.new { subject.start }
        sleep(1)
        t.kill
      end
    end
  end
end
