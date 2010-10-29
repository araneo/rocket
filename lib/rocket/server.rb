module Rocket
  class Server
    
    include Helpers
    
    LOG_MESSAGES = {
      :server_start => "Rocket server started listening at %s:%s (CTRL+C to stop)",
      :server_stop  => "Stopping Rocket setver..."
    }
    
    attr_reader :options
    attr_reader :host
    attr_reader :port
    
    def initialize(options={})
      @options = options
      @host = options.delete(:host) || 'localhost'
      @port = options.delete(:port) || 9772
    end
  
    def start(&blk)
      EM.epoll
      EM.run do
        trap("TERM") { stop }
        trap("INT")  { stop }
        
        debug(:server_start, host, port.to_s)
        EM::start_server(host, port, Connection, options, &blk)
      end
    end
    
    def stop
      debug(:server_stop)
      EM.stop
    end
    
  end # Server
end # Rocket
