module Rocket
  class Session
    attr_reader :subscriptions
    attr_reader :app_id
    
    def initialize(app_id)
      @app = Rocket::App.find(app_id)
      @subscriptions = {}
    end
    
    # Returns object of current application.
    def app
      @app ||= Rocket::App.find(app_id)
    end
    
    # Returns id of current application. 
    def app_id
      @app.id
    end
    
    # Returns +true+ when current session is authenticated with secret key.
    def authenticated?
      !!@authenticated
    end
    
    # Authenticate current session with your secret key. 
    def authenticate!(secret)
      @authenticated = (app.secret == secret)
    end
    
    # Subscribes specified channel by given connected client. 
    #
    #   subscribe("my-awesome-channel", connection) # => subscription ID
    #
    def subscribe(channel, connection)
      sid = Channel[app_id => channel].subscribe {|msg| connection.send(msg) }
      subscriptions[sid] = channel
      sid
    end
    
    # Close current session and kill all active subscriptions.
    def close
      subscriptions.each {|sid, channel| Channel[app_id => channel].unsubscribe(sid) }
    end
  end # Session
end # Rocket
