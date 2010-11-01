require File.expand_path("../spec_helper", __FILE__)

describe Rocket do
  subject do
    Rocket
  end
  
  it ".version should be valid" do
    subject.version.should =~ /\d+(.\d+){1,2}.*/
  end
  
  describe ".logger=" do
    it "should set given logger" do
      subject.logger = :testing
      subject.instance_variable_get("@logger").should == :testing
    end
  end
  
  describe ".logger" do
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
  
  describe ".default_logger" do
    before do
      @logger = subject.default_logger
    end
    
    it "should return logger with default configuration" do
      @logger.should be_kind_of(Logging::Logger)
    end
    
    it "should set it verbosity level to :info" do
      @logger.level.should == 1
    end
    
    it "should add stdout appender" do
      @logger.instance_variable_get("@appenders").should include(Logging.appenders.stdout)
    end
  end
  
  describe ".configure_logger" do
    before :each do 
      subject.logger = nil
    end
    
    after :each do
      subject.logger.appenders = nil
    end
    
    context "when logfile specified" do
      it "should set appender for it" do
        begin
          subject.set :log, "test.log"
          subject.configure_logger
          subject.logger.instance_variable_get("@appenders").last.name.should == "test.log"
        ensure
          FileUtils.rm("test.log")
        end
      end
    end
    
    context "when no logfile specified" do
      it "shouldn't modify appenders" do
        subject.set :log, nil
        subject.configure_logger
        subject.logger.instance_variable_get("@appenders").should have(1).item
      end
    end
    
    context "when verbose mode" do
      it "should set log level to :debug" do
        subject.enable :verbose
        subject.configure_logger
        subject.logger.level.should == 0
      end
    end
    
    context "when no verbose mode" do
      context "and quiet mode" do
        it "should set log level to :error" do
          subject.disable :verbose
          subject.enable :quiet
          subject.configure_logger
          subject.logger.level.should == 3
        end
      end
    end
  end
  
  describe ".load_settings" do
    context "when error raised" do
      it "should rescue it and display, and exit program" do
        out, err = capture_output {
          subject.expects(:load_settings_without_setup).raises(Errno::EACCES) 
          expect { subject.load_settings("test.yml") }.to raise_error(SystemExit)
        }
        out.should == "Permission denied\n"
      end
    end
    
    context "when everything's ok" do
      before do
        subject.expects(:load_settings_without_setup).returns(true)
      end
       
      it "should merge settings with given locals" do
        subject.settings.expects(:merge!).with(:test => true)
        subject.load_settings("test.yml", :test => true)
      end

      it "should configure logger" do
        subject.expects(:configure_logger).returns(true)
        subject.load_settings("test.yml")
      end
      
      it "should require specified plugins" do
        subject.expects(:require_plugins).returns(true)
        subject.load_settings("test.yml")
      end
    end
  end
  
  describe ".require_plugins" do
    it "should require all specified extensions" do
      begin
        subject.set :plugins, %w[test/plugin]
        subject.expects(:require).with("test/plugin").returns(true)
        subject.require_plugins
      ensure
        subject.set :plugins, []
      end
    end
  end
end
