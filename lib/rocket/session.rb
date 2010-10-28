module Rocket
  class Session
    attr_reader :subscriptions
    
    def initialize(connection)
      @connection = connection
      @subscriptions = {}
      authenticate!(*@connection.request["Query"].values_at('app_id', 'app_secret'))
    end
    
    def authenticated?
      !!@authenticated
    end
    
    def authenticate!(id, secret)
      puts "authenticated session for: #{id}"
      @authenticated = (Rocket.available_apps[id] == secret)
    end
    
    def subscribe(channel)
      sid = Channel[{connection => channel}].subscribe {|msg| connection.send(msg) }
      subscriptions[sid] = channel
      sid
    end
    
    def close
      subscriptions.each {|sid, channel| Channel[{connection => channel}].unsubscribe(sid) }
    end
  end # Session
end # Rocket
