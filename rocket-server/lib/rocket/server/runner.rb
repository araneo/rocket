require 'daemons'

module Rocket
  module Server
    class Runner

      include Helpers
      include Daemonize
      
      LOG_MESSAGES = {
        :starting_server => "Server is listening at %s:%s (CTRL+C to stop)",
        :stopping_server => "Stopping Rocket server..."
      }
      
      attr_reader :options
      attr_reader :host
      attr_reader :port
      attr_reader :pidfile
      attr_reader :daemon
      
      def initialize(options={})
        @options = options.dup
        @host    = @options[:host] || 'localhost'
        @port    = @options[:port] || 9772
        @pidfile = @options.delete(:pid) || "/var/run/rocket/server.pid"
        @daemon  = @options.delete(:daemon)
        
        # Remove unnecessary options. 
        @options.reject!{|k,v| [:verbose, :quiet, :log, :apps, :plugins].include?(k) }
      end
    
      def start!(&block)
        if daemon
          daemonize!(&block)
        else
          EM.epoll
          EM.run do
            trap("TERM") { stop! }
            trap("INT")  { stop! }
            
            log_info(:starting_server, host, port.to_s)
            EM::start_server(host, port, Connection, options, &block)
          end
        end
      end
      
      def stop!
        log_info(:stopping_server)
        EM.stop
      end
      
      def kill!
        if File.exists?(pidfile)
          pid = File.read(pidfile).chomp.to_i
          FileUtils.rm pidfile
          Process.kill(9, pid)
          pid
        end
      rescue => e
        # nothing to show
      end
      
      def daemonize!(&block)
        daemonize
        start!(&block)
      end
      
      def save_pid
        FileUtils.mkdir_p(File.dirname(pidfile))
        File.open(pidfile, "w+"){|f| f.write("#{Process.pid}\n")}
      rescue => e
        puts e.to_s
        exit 1
      end
    
    end # Runner
  end # Server
end # Rocket
