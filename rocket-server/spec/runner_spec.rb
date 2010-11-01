require File.expand_path("../spec_helper", __FILE__)

describe Rocket::Server::Runner do
  subject do
    Rocket::Server::Runner
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
    
    it "should remove unnecessary options" do
      serv = subject.new(:verbose => true, :quiet => false, :log => 1, :apps => [], :plugins => [])
      serv.options.values.should be_empty
    end
    
    context "when :pid option given" do
      it "should set it" do
        serv = subject.new(:pid => "test.pid")
        serv.pidfile.should == "test.pid"
      end
    end
    
    context "when :daemon option given" do
      it "should set it" do
        serv = subject.new(:daemon => true)
        serv.daemon.should == true
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
    context "when daemon mode disabled" do
      it "should start server on given host and port" do
        EM.expects(:start_server).with("test.host", 9992, Rocket::Server::Connection, instance_of(Hash))
        t = Thread.new { subject.new(:host => "test.host", :port => 9992).start! }
        t.kill
      end
    end
    
    context "when daemon mode enabled" do
      it "should daemonize server" do
        serv = subject.new(:host => "test.host", :port => 9992, :daemon => true)
        serv.expects(:daemonize!).returns(:test)
        serv.start!.should == :test
      end
    end
  end
  
  describe "#save_pid" do
    context "when pid file given" do
      subject do
        Rocket::Server::Runner.new(:pid => "test.pid")
      end
      
      context "and everything's ok" do
        it "should save process id to this file" do
          mock_file = mock
          mock_file.expects(:write).with("#{Process.pid}\n")
          File.expects(:open).with("test.pid", "w+").yields(mock_file)
          subject.save_pid
        end
      end
      
      context "and some errors raises" do
        it "should display error and quit" do
          out, err = capture_output {
            FileUtils.expects(:mkdir_p).with(".").raises(Errno::EACCES)
            expect { subject.save_pid }.to raise_error(SystemExit)
          }
          out.should == "Permission denied\n"
        end
      end
    end
  end
  
  describe "#kill!" do
    context "when pid file given" do
      subject do
        Rocket::Server::Runner.new(:pid => "test.pid")
      end
      
      context "and it doesn't exist" do
        it "should do nothing" do
          File.expects(:exists?).with("test.pid").returns(false)
          subject.kill!.should_not be
        end
      end
      
      context "and it exists" do
        it "should remove it and kill given process" do
          File.expects(:exists?).with("test.pid").returns(true)
          File.expects(:read).with("test.pid").returns("123\n")
          FileUtils.expects(:rm).with("test.pid")
          Process.expects(:kill).with(9, 123)
          subject.kill!.should == 123
        end
      end
    end
  end
  
  describe "#daemonize!" do
    subject do
      Rocket::Server::Runner.new(:pid => "test.pid")
    end
    
    it "should switch to deamon mode and start server" do
      serv = subject
      serv.expects(:daemonize)
      serv.expects(:start!)
      serv.daemonize!
    end
  end
end
