module Rocket
  module Server
    
    extend Helpers
    
    LOG_MESSAGES = {
      :server_start => "Rocket server started listening at %s:%s (CTRL+C to stop)",
      :server_stop  => "Stopping Rocket setver..."
    }
  
    def self.start(opts={}, &blk)
      host = opts.delete(:host) || 'localhost'
      port = opts.delete(:port) || 9772

      EM.epoll
      EM.run do
        trap("TERM") { stop }
        trap("INT")  { stop }
        
        debug(:server_start, host, port.to_s)
        EM::start_server(host, port, Connection, opts, &blk)
      end
    end
    
    def self.stop
      debug(:server_stop)
      EM.stop
    end
    
    def self.log_messages
      LOG_MESSAGES
    end
  end # Server
end # Rocket
