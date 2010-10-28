module Rocket
  class Connection < EM::WebSocket::Connection
    # Only connections to path matching this pattern will be accepted.
    APP_PATH_PATTERN = /^\/app\/(.*)(\?|\/)?.*/
    
    def initialize(options={})
      super(options)
      @onopen = method(:onopen)
      @onclose = method(:onclose)
      @onmessage = method(:onmessage)
      @onerror = method(:onerror)
    end
    
    # Starts new session for application specified in request path.
    def onopen
      request["Path"] =~ APP_PATH_PATTERN
      @session = Session.new($1)
    rescue Rocket::App::NotFoundError
      close_connection
    end
    
    # Closes current session. 
    def onclose
      @session.close and true if session?
    end
    
    # Handler websocket's of runtime errors. 
    def onerror(reason)
      
    end
    
    # Dispatches the received message.
    def onmessage(message)
      if session? and message = JSON.parse(message)
        case message["event"]
          when "rocket:subscribe"   then subscribe!(message)
          when "rocket:unsubscribe" then unsubscribe!(message)
        else
          publish_event!(message)
        end
      end
    rescue JSON::ParserError
      # INVALID MESSAGE FORMAT!
    end
    
    # Returns true if session is open. 
    def session?
      !!@session
    end
    
    def subscribe!(data)
      data["channel"] ? @session.subscribe(data["channel"], self) : false
    end
    
    def unsubscribe!(data)
      data["channel"] ? @session.unsubscribe(data["channel"], self) : false
    end
    
    def publish_event!(data)
      if session? and session.authenticated?
        channel, event = data.values_at("channel", "event")
        # XXX: check subscriptions here
        Channel[session.app_id => channel].push(data.to_json)
      else
        # UNAUTHORIZED!
      end
    end
  end # Connection
end # Rocket
