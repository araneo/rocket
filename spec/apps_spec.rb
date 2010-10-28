require File.expand_path("../spec_helper", __FILE__)

describe Rocket::App do
  subject do 
    Rocket.expects(:static_apps).returns({"test-app" => {"secret" => "my-secret"}})
    Rocket::App
  end
  
  describe ".all" do
    it "should return list of all registered apps" do
      all = subject.all
      all.should have(1).item
      all.first.id.should == "test-app"
    end
  end
  
  describe ".find" do
    context "when there is app with given id" do
      it "should return it" do
        app = subject.find("test-app")
        app.should be
        app.id.should == "test-app"
      end
    end
    
    context "when there is no app with given id" do
      it "should raise error" do
        expect { subject.find("no-such-app") }.to raise_error(Rocket::App::NotFoundError)
      end
    end
  end
  
  describe "instance" do
    subject do
      Rocket::App.new(@attrs = {"id" => "test", "secret" => "my-secret"})
    end

    describe "#id" do
      it "should return app identifier" do
        subject.id.should == "test"
      end
    end
    
    describe "#initialize" do
      it "should set given attributes" do
        subject.attributes.should == @attrs
      end
    end
    
    it "should redirect missing methods to attibutes" do
      subject.secret.should == "my-secret"
    end
  end
end
