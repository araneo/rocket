module Rocket
  module Server
    class Connection < EM::WebSocket::Connection
    
      include Helpers
      
      LOG_MESSAGES = {
        :app_not_found_error   => "#%d : %s",
        :opening_connection    => "%s #%d : Opening new connection...",
        :closing_connection    => "%s #%d : Closing connection...",
        :auth_success          => "%s #%d : Session authenticated successfully!",
        :auth_error            => "%s #%d : Authentication error! Invalid secret key.",
        :web_socket_error      => "%s #%d : Web socket error: %s",
        :invalid_json_error    => "%s #%d : Invalid event's data! This is not valid JSON: %s",
        :subscribing_channel   => "%s #%d : Subscribing the '%s' channel.",
        :unsubscribing_channel => "%s #%d : Unsubscribing the '%s' channel.",
        :trigger_error         => "%s #%d : Invalid event's data! No channel or event name specified in: %s",
        :access_denied_error   => "%s #%d : Action can't be performed, access denied!",
        :trigger_success       => "%s #%d : Triggering '%s' on '%s' channel: %s",
      }
    
      # Only connections to path matching this pattern will be accepted.
      APP_PATH_PATTERN = /^\/app\/([\d\w\-\_]+)/
      
      attr_reader :session
      
      def initialize(options={})
        super(options)
        @onopen = method(:onopen)
        @onclose = method(:onclose)
        @onmessage = method(:onmessage)
        @onerror = method(:onerror)
        @debug = Rocket::Server.debug
      end
      
      # Starts new session for application specified in request path.
      def onopen
        request["Path"] =~ APP_PATH_PATTERN
        
        if @session = Session.new($1) 
          log_debug(:opening_connection, app_id, signature)
          
          if secret = request["Query"]["secret"]
            if @session.authenticate!(secret)
              log_debug(:auth_success, app_id, signature)
            else
              log_debug(:auth_error, app_id, signature)
            end
          end
        end
      rescue App::NotFoundError => ex
        log_error(:app_not_found_error, signature, ex.to_s)
        close_connection
      end
      
      # Closes current session. 
      def onclose
        log_debug(:closing_connection, app_id, signature)
        @session.close and true if session?
      end
      
      # Handler websocket's of runtime errors. 
      def onerror(reason)
        log_error(:web_socket_error, app_id, signature, reason)
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
        log_error(:invalid_json_error, app_id, signature, message.inspect)
      end
      
      # Returns true if session is open. 
      def session?
        !!@session
      end
      
      # Handles subscription event. 
      def subscribe!(data)
        if channel = data["channel"]
          log_debug(:subscribing_channel, app_id, signature, channel)
          @session.subscribe(channel, self)
        end
      end
      
      # Handles unsubscribe event.
      def unsubscribe!(data)
        if channel = data["channel"]
          log_debug(:unsubscribing_channel, app_id, signature, channel)
          @session.unsubscribe(channel, self)
        end
      end
      
      # Publishes given message. 
      def trigger!(data)
        if session? and session.authenticated?
          channel, event = data.values_at("channel", "event")
          if channel and event
            log_debug(:trigger_success, app_id, signature, event, channel, data.inspect)
            return Channel[session.app_id => channel].push(data.to_json)
          end
          log_error(:trigger_error, app_id, signature, data.inspect)
        else
          log_error(:access_denied_error, app_id, signature)
        end
      end
      
      def app_id
        session? ? session.app_id : "unknown"
      end
      
    end # Connection
  end # Server
end # Rocket
