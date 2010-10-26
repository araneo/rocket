module Rocket
  module Transports
  
    class NoTransportError < ArgumentError; end
    class InvalidTransportError < NameError; end
  
    autoload :Redis, "rocket/transports/redis"
    #autoload :XMPP,  "rocket/transports/xmpp"
    #autoload :AMQP,  "rocket/transports/amqp"
  
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
end # Rocket
