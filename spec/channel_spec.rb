require File.expand_path("../spec_helper", __FILE__)

describe Rocket::Channel do
  subject do
    Rocket::Channel
  end
  
  describe ".[]" do
    context "when given channel doesn't exist" do
      it "should create it and return" do
        subject.channels.replace({})
        channel = subject["my-app" => "my-channel"]
        channel.should be_kind_of subject
        subject.channels[["my-app", "my-channel"]].should == channel
      end
    end
    
    context "when given channel exists" do
      it "should return it" do
        subject["my-second-app" => "my-channel"]
        subject["my-second-app" => "my-channel"].should == subject.channels[["my-second-app", "my-channel"]]
      end
    end
  end
  
  describe ".channels" do
    it "should keep list of registered channels" do
      subject.channels.should have(2).items
    end
  end
end
