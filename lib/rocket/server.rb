module Rocket
  module Server
    
    MESSAGES = {
      :SERVER_START => "Rocket server started listening at %s:%s (CTRL+C to stop)",
      :SERVER_STOP  => "Stopping Rocket setver..."
    }
  
    def self.start(opts={}, &blk)
      host = opts.delete(:host) || 'localhost'
      port = opts.delete(:port) || 9772

      EM.epoll
      EM.run do
        trap("TERM") { stop }
        trap("INT")  { stop }
        
        Rocket.log.debug(MESSAGES[:SERVER_START] % [host, port.to_s])
        EM::start_server(host, port, Connection, opts, &blk)
      end
    end
    
    def self.stop
      Rocket.log.debug(MESSAGES[:SERVER_STOP])
      EM.stop
    end
  end # Server
end # Rocket
