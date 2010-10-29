module Rocket
  class Server
    
    include Helpers
    
    LOG_MESSAGES = {
      :starting_server => "Rocket server started listening at %s:%s (CTRL+C to stop)",
      :stopping_server => "Stopping Rocket server..."
    }
    
    attr_reader :options
    attr_reader :host
    attr_reader :port
    attr_reader :pidfile
    attr_reader :daemon
    
    def initialize(options={})
      @host    = options[:host] || 'localhost'
      @port    = options[:port] || 9772
      @pidfile = options.delete(:pid) || "/var/run/rocket/server.pid"
      @daemon  = options.delete(:daemon)
      @options = options
    end
  
    def start!(&blk)
      if daemon
        daemonize!(&blok)
      else
        EM.epoll
        EM.run do
          trap("TERM") { stop! }
          trap("INT")  { stop! }
          
          info(:starting_server, host, port.to_s)
          EM::start_server(host, port, Connection, options, &blk)
        end
      end
    end
    
    def stop!
      puts
      info(:stopping_server)
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
      puts e
    end
    
    def daemonize!(&blk)
      fork do
        Process.setsid
        exit if fork
        save_pid
        File.umask 0000
        STDIN.reopen "/dev/null"
        STDOUT.reopen "/dev/null", "a"
        STDERR.reopen STDOUT
        start!(&blk)
      end
    end
    
    def save_pid
      FileUtils.mkdir_p(File.dirname(pidfile))
      File.open(pidfile, "w+"){|f| f.write("#{Process.pid}\n")}
    rescue => e
      puts e.to_s
      exit 1
    end
    
  end # Server
end # Rocket
