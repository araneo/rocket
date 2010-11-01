require File.expand_path("../spec_helper", __FILE__)

describe Rocket::Server::Misc do
  subject do
    Rocket::Server::Misc
  end
  
  describe ".generate_config_file" do
    context "when everything's ok" do
      it "should create default config under given path" do
        begin
          subject.generate_config_file(fname = File.expand_path("../rocket.yml", __FILE__))
          File.should be_exist(fname)
          expect { YAML.load_file(fname) }.to_not raise_error 
        ensure
          FileUtils.rm_rf(fname)
        end
      end
    end
    
    context "when error raised" do
      it "should rescue it and display, and exit program" do
        out, err = capture_output {
          File.expects(:open).raises(Errno::EACCES) 
          expect { subject.generate_config_file("rocket.yml") }.to raise_error(SystemExit)
        }
        out.should == "Permission denied\n"
      end
    end
  end
end
