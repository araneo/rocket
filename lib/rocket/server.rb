module Rocket
  module Server
    def self.start(opts={}, &blk)
      host = opts.delete(:host) || 'localhost'
      port = opts.delete(:port) || 9772

      EM.epoll
      EM.run do
        trap("TERM") { stop }
        trap("INT")  { stop }
        
        Rocket.log.debug("Starting Rocket server at #{host}:#{port}")
        EM::start_server(host, port, Connection, opts, &blk)
      end
    end
    
    def self.stop
      EM.stop
    end
  end # Server
end # Rocket
