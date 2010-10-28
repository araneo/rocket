module Rocket
  class Connection < EM::WebSocket::Connection

    MESSAGES = {
      :OPENING_CONNECTION  => "(%s, %d) Opening new connection...",
      :CLOSING_CONNECTION  => "(%s, %d) Closing connection...",
      :AUTH_SUCCESS        => "(%s, %d) Session authenticated successfully!",
      :AUTH_ERROR          => "(%s, %d) Authentication error! Invalid secret key.",
      :APP_NOT_FOUND_ERROR => "(%s, %d) %s",
      :WEB_SOCKET_ERROR    => "(%s, %d) Web socket error: %s",
      :EVENT_DATA_ERROR    => "(%s, %d) Invalid event's data! This is not valid JSON: %s",
      :SUBSCRIBE_CHANNEL   => "(%s, %d) Subscribing the '%s' channel.",
      :UNSUBSCRIBE_CHANNEL => "(%s, %d) Unsubscribing the '%s' channel.",
      :TRIGGER_DATA_ERROR  => "(%s, %d) Invalid event's data! No channel or name specified: %s",
      :TRIGGER_AUTH_ERROR  => "(%s, %d) Can't trigger event, access denied!",
      :TRIGGER_SUCCESS     => "(%s, %d) Triggering '%s' on '%s' channel: %s",
    }
  
    # Only connections to path matching this pattern will be accepted.
    APP_PATH_PATTERN = /^\/app\/(.*)(\?|\/)?.*/
    
    attr_reader :session
    
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
      if @session = Session.new($1) 
        Rocket.log.debug(MESSAGES[:OPENING_CONNECTION] % [app_id, signature])
        
        if secret = request["Query"]["secret"]
          if @session.authenticate!(secret)
            Rocket.log.debug(MESSAGES[:AUTH_SUCCESS] % [app_id, signature])
          else
            Rocket.log.error(MESSAGES[:AUTH_ERROR] % [app_id, signature])
          end
        end
      end
    rescue Rocket::App::NotFoundError => ex
      Rocket.log.error(MESSAGES[:APP_NOT_FOUND_ERROR] % [app_id, signature, ex.to_s])
      close_connection
    end
    
    # Closes current session. 
    def onclose
      Rocket.log.debug(MESSAGES[:CLOSING_CONNECTION] % [app_id, signature])
      @session.close and true if session?
    end
    
    # Handler websocket's of runtime errors. 
    def onerror(reason)
      Rocket.log.debug(MESSAGES[:WEB_SOCKET_ERROR] % [app_id, signature, reason])
    end
    
    # Dispatches the received message.
    def onmessage(message)
      if session? and data = JSON.parse(message)
        case data["event"]
          when "rocket:subscribe"   then subscribe!(data)
          when "rocket:unsubscribe" then unsubscribe!(data)
        else
          trigger!(data)
        end
      end
    rescue JSON::ParserError
      Rocket.log.error(MESSAGES[:EVENT_DATA_ERROR] % [app_id, signature, message.inspect])
    end
    
    # Returns true if session is open. 
    def session?
      !!@session
    end
    
    # Handles subscription event. 
    def subscribe!(data)
      if channel = data["channel"]
        Rocket.log.debug(MESSAGES[:SUBSCRIBE_CHANNEL] % [app_id, signature, channel])
        @session.subscribe(channel, self)
      end
    end
    
    # Handles unsubscribe event.
    def unsubscribe!(data)
      if channel = data["channel"]
        Rocket.log.debug(MESSAGES[:UNSUBSCRIBE_CHANNEL] % [app_id, signature, channel])
        @session.unsubscribe(channel, self)
      end
    end
    
    # Publishes given message. 
    def trigger!(data)
      if session? and session.authenticated?
        channel, event = data.values_at("channel", "event")
        if channel and event
          Channel[session.app_id => channel].push(data.to_json)
          Rocket.log.info(MESSAGES[:TRIGGER_SUCCESS] % [app_id, signature, event, channel, data.inspect])
        else
          Rocket.log.info(MESSAGES[:TRIGGER_DATA_ERROR] % [app_id, signature, data.inspect])
        end
      else
        Rocket.log.info(MESSAGES[:TRIGGER_AUTH_ERROR] % [app_id, signature, data.inspect])
      end
    end
    
    def app_id
      session? ? session.app_id : "unknown"
    end
  end # Connection
end # Rocket
