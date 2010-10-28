require File.expand_path("../spec_helper", __FILE__)

describe Rocket::Connection do
  subject do
    Rocket::Connection
  end
  
  describe "#initialize" do
    it "should set all callbacks" do
      conn = subject.new({})
      conn.instance_variable_get("@onopen").should == conn.method(:onopen)
      conn.instance_variable_get("@onclose").should == conn.method(:onclose)
      conn.instance_variable_get("@onerror").should == conn.method(:onerror)
      conn.instance_variable_get("@onmessage").should == conn.method(:onmessage)
    end
  end
  
  describe "#onopen" do
    before do
      Rocket.instance_variable_set("@apps", {"test-app" => {"secret" => "my-secret"}})
    end
    
    context "when valid app specified in request" do
      it "should start new session for it" do
        conn = subject.new({})
        conn.request.expects(:"[]").with("Path").returns("/app/test-app")
        conn.onopen
        session = conn.instance_variable_get('@session')
        session.should be_kind_of(Rocket::Session)
        session.app_id.should == "test-app"
      end
    end
    
    context "when invalid app specified in request" do
      it "should close connection with client" do
        conn = subject.new({})
        conn.request.expects(:"[]").with("Path").returns("/app/non-existing-app")
        conn.expects(:close_connection)
        conn.onopen
      end
    end
  end
  
  describe "#onclose" do
    context "when session is active" do
      it "should close it" do
        conn = subject.new({})
        conn.request.expects(:"[]").with("Path").returns("/app/test-app")
        conn.onopen
        conn.instance_variable_get('@session').expects(:close)
        conn.onclose
      end
    end
    
    context "when session is not active" do
      it "should do nothing" do
        conn = subject.new({})
        conn.onclose.should be_nil
      end
    end
  end
  
  describe "#session?" do
    context "when current session exists" do
      it "should be true" do
        conn = subject.new({})
        conn.request.expects(:"[]").with("Path").returns("/app/test-app")
        conn.onopen
        conn.should be_session
      end
    end
    
    context "when there is no session" do
      it "should be false" do
        conn = subject.new({})
        conn.should_not be_session   
      end
    end
  end
end
