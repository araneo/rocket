require File.expand_path("../spec_helper", __FILE__)

describe Rocket::Session do
  let(:mock_app) do
    mock("Rocket::App")
  end
  
  subject do
    Rocket::App.expects(:find).with("test").returns(mock_app)
    Rocket::Session.new('test')
  end
  
  describe "#initialize" do
    context "when given app exists" do
      it "should initialize subscriptions hash" do
        subject.subscriptions.should == {}
      end
      
      it "should find given app" do
        mock_app.expects(:id).returns("test")
        subject.app_id.should == "test"
      end
    end
    
    context "when given app doesn't exist" do
      it "should raise error" do
        Rocket::App.expects(:find).with("this-app-does-not-exist").raises(Rocket::App::NotFoundError)
        expect { Rocket::Session.new("this-app-does-not-exist") }.to raise_error(Rocket::App::NotFoundError)
      end
    end
  end
  
  describe "in authentication flow" do
    describe "#authenticated?" do
      it "should be false by default" do
        subject.should_not be_authenticated
      end
    end
    
    describe "#authenticate!" do
      describe "when invalid secret given" do
        it "shouldn't authenticate current session" do
          mock_app.expects(:secret).returns("test")
          @session = subject
          @session.authenticate!("not-test").should be_false
          @session.should_not be_authenticated
        end
      end
      
      describe "when valid secret given" do
        it "should authenticate current session" do
          mock_app.expects(:secret).returns("test")
          @session = subject
          @session.authenticate!("test").should be_true
          @session.should be_authenticated
        end
      end 
    end
  end
  
  describe "#subscribe" do
    it "should subscribe given channel for given connection" do
      pending
    end
  end
  
  describe "#close" do
    it "should unsubscibe all active subscriptions" do
      pending
    end
  end
end
