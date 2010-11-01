require File.expand_path("../spec_helper", __FILE__)

describe Rocket::CLI do
  subject do
    Rocket::CLI
  end

  describe "#start" do
    it "should properly start server" do
      out, err = capture_output {
        mock_server = mock(:start! => true)
        Rocket.expects(:load_settings).with('test.yml', {
          :verbose => false, :debug => false, :secure => false, :quiet => false, 
          :pid => '/var/run/rocket/server.pid', :daemon => false, :host => 'localhost', 
          :plugins => [], :port => 9772, :help => false
        }).returns(true)
        Rocket::Server.expects(:new).returns(mock_server)
        subject.dispatch(%w[start -c test.yml])
      }
    end
  end
  
  describe "#stop" do
    context "when proper pidfile given" do
      it "should kill that process" do
        out, err = capture_output {
          mock_server = mock(:kill! => 123)
          Rocket.expects(:load_settings).with('test.yml', :pid => 'test.pid', :help => false).returns(true)
          Rocket::Server.expects(:new).returns(mock_server)
          subject.dispatch(%w[stop -c test.yml -P test.pid])
        }
        out.should == "Rocket server killed (PID: 123)\n"
      end
    end
    
    context "when invalid pid given" do
      it "should do nothing" do
        out, err = capture_output {
          mock_server = mock(:kill! => false)
          Rocket.expects(:load_settings).with('test.yml', :pid => 'test.pid', :help => false).returns(true)
          Rocket::Server.expects(:new).returns(mock_server)
          subject.dispatch(%w[stop -c test.yml -P test.pid])
        }
        out.should == "No processes were killed!\n"
      end
    end
  end
  
  describe "#version" do
    it "should display current version of Rocket server" do
      capture_output { subject.dispatch(%w[version]) }
    end
  end
  
  describe "#configure" do
    context "when no file name given" do
      it "should create rocket.yml file in current directory" do
        capture_output {
          begin
            fname = File.join(Dir.pwd, "rocket.yml")
            subject.dispatch(%w[configure])
            File.should be_exist(fname)
          ensure
            FileUtils.rm_rf(fname)
          end
        }
      end
    end
    
    context "when file name given" do
      it "should create it" do
        capture_output {
          begin
            fname = File.join(Dir.pwd, "tmp/test.yml")
            FileUtils.mkdir_p(File.dirname(fname))
            subject.dispatch(%w[configure tmp/test.yml])
            File.should be_exist(fname)
          ensure
            FileUtils.rm_rf(File.dirname(fname))
          end
        }
      end
    end
  end
end
