require File.expand_path("../spec_helper", __FILE__)

describe Rocket::Connection do
  subject do
    Rocket::Connection
  end

  before do
    Rocket.instance_variable_set("@apps", {"test-app" => {"secret" => "my-secret"}})
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
    
    context "when valid app specified in request" do
      it "should start new session for it" do
        conn = subject.new({})
        conn.request.expects(:"[]").with("Path").returns("/app/test-app")
        conn.onopen
        session = conn.session
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
        conn.session.expects(:close)
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
  
  describe "#onerror" do
    it "should log given error" do
      conn = Rocket::Connection.new(1)
      conn.request.expects(:"[]").with("Path").returns("/app/test-app")
      conn.onopen
      Rocket.log.expects(:error).with("Socket error (test-app): test error here")
      conn.onerror("test error here")
    end
  end
  
  describe "#onmessage" do
    subject do 
      conn = Rocket::Connection.new(1)
      conn.request.expects(:"[]").with("Path").returns("/app/test-app")
      conn.onopen
      conn
    end
  
    context "when given message is valid JSON" do
      context "for rocket:subscribe message" do
        it "should process it" do
          conn = subject
          message = {"event" => "rocket:subscribe", "channel" => "my-test-one"}
          conn.expects(:subscribe!).with(instance_of(Hash))
          conn.onmessage(message.to_json)
        end
      end
      
      context "for rocket:unsubscribe message" do
        it "should process it" do
          conn = subject
          message = {"event" => "rocket:unsubscribe", "channel" => "my-test-one"}
          conn.expects(:unsubscribe!).with(instance_of(Hash))
          conn.onmessage(message.to_json)
        end
      end
      
      context "for other message" do
        it "should process it" do
          conn = subject
          message = {"channel" => "my-test-chan", "event" => "my-test-even", "data" => {"foo" => "bar"}}
          conn.expects(:trigger!).with(instance_of(Hash))
          conn.onmessage(message.to_json)
        end
      end
    end
    
    context "when given message is invalid JSON" do
      it "should log proper error" do
        conn = subject
        Rocket.log.expects(:error).with("Invalid event data (test-app): \"{invalid JSON here}\"")
        conn.onmessage("{invalid JSON here}")
      end
    end
  end
  
  describe "#session?" do
    context "when current session exists" do
      it "should be true" do
        conn = subject.new(1)
        conn.request.expects(:"[]").with("Path").returns("/app/test-app")
        conn.onopen
        conn.should be_session
      end
    end
    
    context "when there is no session" do
      it "should be false" do
        conn = subject.new(1)
        conn.should_not be_session   
      end
    end
  end
  
  describe "#subscribe!" do
    before do
      @conn = subject.new(1)
      @conn.request.expects(:"[]").with("Path").returns("/app/test-app")
      @conn.onopen
    end
    
    context "when given valid event data" do
      it "should subscribe channel" do
        @conn.subscribe!({"channel" => "test-channel"}).should be
        @conn.session.subscriptions.should have(1).item
      end
    end
    
    context "when no valid event data given" do
      it "should return false" do
        @conn.subscribe!({"channello" => "test-channel"}).should be_false
      end
    end
  end
  
  describe "#unsubscribe!" do
    before do
      @conn = subject.new(1)
      @conn.request.expects(:"[]").with("Path").returns("/app/test-app")
      @conn.onopen
    end
    
    context "when given valid event data" do
      it "should unsubscribe channel" do
        @conn.unsubscribe!({"channel" => "test-channel"}) 
      end
    end
    
    context "when no valid event data given" do
      it "should return false" do
        @conn.unsubscribe!({"channello" => "test-channel"}).should be_false
      end
    end
  end
end
