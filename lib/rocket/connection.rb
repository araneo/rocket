module Rocket
  class Connection < EM::WebSocket::Connection
    attr_reader :sessid
    
    def initialize(options)
      super(options)
      onopen do
        @sessid = channel.subscribe {|msg| send msg }
        onclose {
          logger.debug "Disconnecting subscriber ##{@sessid}" 
          channel.unsubscribe(@sessionid)
        }
        onmessage {|msg|
          logger.info "Message received: #{msg}" 
          channel.push msg
        }
        logger.debug "Connecting subscriber ##{@sessid}"
      end
    end
    
    def channel
      Rocket.channel
    end
    
    def logger
      Rocket.logger
    end
    
  end # Connection
end # Rocket
