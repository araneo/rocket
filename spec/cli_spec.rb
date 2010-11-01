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
