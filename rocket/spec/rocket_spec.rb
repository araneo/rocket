require File.expand_path("../spec_helper", __FILE__)

describe Rocket do
  subject do
    Rocket
  end
  
  it ".version should be valid" do
    subject.version.should =~ /\d+(.\d+){1,2}.*/
  end
end
