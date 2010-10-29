require File.expand_path("../spec_helper", __FILE__)

describe Rocket::Misc do
  subject do
    Rocket::Misc
  end
  
  it ".generate_config_file should create default config under given path" do
    begin
      subject.generate_config_file(fname = File.expand_path("../rocket.yml", __FILE__))
      File.should be_exist(fname)
      expect { YAML.load_file(fname) }.to_not raise_error 
    ensure
      FileUtils.rm_rf(fname)
    end
  end
end
