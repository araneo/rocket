module Rocket
  module Server
    class Session
    
      attr_reader :subscriptions
      attr_reader :app
      
      def initialize(app_id)
        @app = Rocket::Server::App.find(app_id)
        @subscriptions = {}
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
        subscriptions[channel => connection.signature] = sid
        sid
      end
      
      # Unsubscribes specified channel for given client.
      #
      #   unsubscribe("my-awesome-channel", connection)
      #
      def unsubscribe(channel, connection)
        if sid = subscriptions.delete(channel => connection.signature)
          Channel[app_id => channel].unsubscribe(sid)
        end
      end
      
      # Close current session and kill all active subscriptions.
      def close
        subscriptions.keys.each do |id| 
          channel, sig = id.to_a.flatten
          Channel[app_id => channel].unsubscribe(subscriptions.delete(channel => sig))
        end
      end
      
    end # Session
  end # Server
end # Rocket
