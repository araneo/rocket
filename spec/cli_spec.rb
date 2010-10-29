require File.expand_path("../spec_helper", __FILE__)

describe Rocket::CLI do
  subject do
    Rocket::CLI
  end

  describe "#start" do
    it "should properly start server" do
      pending
    end
  end
  
  describe "#version" do
    it "should display current version of Rocket server" do
      STDOUT.stubs(:write)
      subject.dispatch(%[version])
    end
  end
  
  describe "#configure" do
    context "when no file name given" do
      it "should create rocket.yml file in current directory" do
        begin
          fname = File.join(Dir.pwd, "rocket.yml")
          subject.dispatch(%[configure])
          File.should be_exist(fname)
        ensure
          FileUtils.rm_rf(fname)
        end
      end
    end
    
    context "when file name given" do
      it "should create it" do
        
      end
    end
  end
end
