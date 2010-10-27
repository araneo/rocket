require "json"

module Rocket
  class Connection < EM::WebSocket::Connection
    def initialize(options)
      super(options)
      onopen(&method(:start_session))
      onclose(&method(:close_session))
      onmessage(&method(:process_message!))
    end
    
    def channels
      @channels ||= Channels.new(self)
    end
    
    def process_message!(msg)
      if msg = JSON.parse(msg) and @session
        if data = msg["subscribe"]
          puts "subscribbing channel #{data["channel"]}"
          @session.subscribe(data["channel"])
        elsif data = msg["publish"]
          publish_event!(data)
        else
          puts "unknown message: #{msg.inspect}"
        end
      end
    rescue JSON::ParserError
      puts "bad message"
    end
    
    def publish_event!(data)
      if @session.authenticated?
        puts "publishing event #{data["name"]}"
        channel_name, *_ = data.values_at("channel", "event")
        channels[channel_name].push(data.to_json)
      else
        puts "unauthorized to publish"
      end
    end
    
    def start_session
      puts "starting new session"
      @session = Session.new(self)
    end
    
    def close_session
      puts "session closed"
      @session.close if @sessions 
    end
  end # Connection
end # Rocket
