module OpenAudit
  module WebSocket
    module Transports
    
      class NoTransportError < ArgumentError; end
      class InvalidTransportError < NameError; end
    
      autoload :Redis, "openaudit/websocket/transports/redis"
      #autoload :XMPP,  "openaudit/websocket/transports/xmpp"
      #autoload :AMQP,  "openaudit/websocket/transports/amqp"
    
      def self.get_transport(ws, options={})
        unless adapter = options.delete(:adapter)
          ws.logger.error "There is no transport specified in configuration" and false
        else
          transport = eval(adapter)
          transport.new(ws, options)
        end
      rescue NameError
        ws.logger.error "The #{adapter} transport is not supported" and false
      end
    
      class Base
        def initialize(ws)
          @ws = ws
        end
      end # Base
      
    end # Transports
  end # WebSocket
end # OpenAudit
