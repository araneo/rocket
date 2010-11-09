require File.expand_path("../spec_helper", __FILE__)

class HelpersPoweredClass
  include Rocket::Helpers
end

describe Rocket::Helpers do
  subject do
    HelpersPoweredClass.new
  end
  
  describe "#symbolize_keys" do
    it "should return given object when it's not a Hash" do
      subject.symbolize_keys(obj = Object.new).should == obj
    end
    
    it "should symbolize given hash keys" do
      subject.symbolize_keys({"hello" => "world"}).should == {:hello => "world"}
    end
  end
end
