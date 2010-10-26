module OpenAudit
  module WebSocket
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
            logger.debug "New message received: #{msg}" 
            channel.push msg
          }
          logger.debug "Connecting subscriber ##{@sessid}"
        end
      end
      
      def channel
        OpenAudit::WebSocket.channel
      end
      
      def logger
        OpenAudit::WebSocket.logger
      end
      
    end # Connection
  end # WebSocket
end # OpenAudit
