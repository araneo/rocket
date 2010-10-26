require 'eventmachine'
require 'em-websocket'
require 'logging'

module Rocket
  autoload :Connection, "rocket/connection"
  autoload :Transports, "rocket/transports"
  autoload :CLI,        "rocket/cli"

  def self.start(channels, opts, &blk)
    host = opts.delete(:host)
    port = opts.delete(:port)

    setup_logger(opts.delete(:logger) || {}) or exit(4)
    
    EM.epoll
    EM.run do
      trap("TERM") { stop }
      trap("INT")  { stop }
      
      transport = Transports.get_transport(self, opts.delete(:transport) || {}) or exit(3)
      transport.subscribe(channels)
      
      logger.debug "Web socket server is listening on #{host}:#{port} (CTRL+C to stop)"
      EM::start_server(host, port, Connection, opts, &blk)
    end
  rescue Object => ex
    logger.error ex.to_s
    exit(2)
  end
  
  def self.stop
    logger.debug "Terminating web socket server..."
    EventMachine.stop
  end
  
  def self.logger
    @logger ||= begin
      logger = Logging.logger["WebSocket"]
      logger.add_appenders(Logging.appenders.stdout)
      logger.level = :debug
      logger
    end
  end
  
  def self.channel
    @channel ||= EM::Channel.new
  end
  
  def self.setup_logger(options)
    logger.add_appenders(Logging.appenders.file(options[:file])) if options[:file]
    logger.level = options[:log].to_sym if options[:level]
    true
  rescue Object => ex
    logger.error ex.to_s and false
  end
  
  def self.load_config(file)
    options = YAML.load_file(file)
  rescue Errno::ENOENT => ex
    logger.error ex.to_s and false
  end
  
end # Rocket

require 'rocket/version'

