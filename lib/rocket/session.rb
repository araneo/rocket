module Rocket
  class Session
    attr_reader :subscriptions
    
    def initialize(connection)
      @connection = connection
      @subscriptions = {}
      authenticate!(*@connection.request["Query"].values_at('appid', 'secret'))
    end
    
    def authenticated?
      !!@authenticated
    end
    
    def subscribe(channel_name)
      puts "subscribing channel: #{channel_name}"
      channel = Channel[channel_name]
      sessid = channel.subscribe {|msg| @connection.send(msg) }
      subscriptions[sessid] = channel
    end
    
    def authenticate!(appid, secret)
      puts "authenticated session for: #{appid}"
      @authenticated = (Rocket.available_apps[appid] == secret)
    end
    
    def close
      subscriptions.each {|sessid, channel| 
        channel.unsubscribe(sessid) if channel && sessid
      }
    end
  end # Session
end # Rocket
