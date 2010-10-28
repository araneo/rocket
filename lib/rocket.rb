require 'eventmachine'
require 'em-websocket'
require 'logging'

module Rocket
  autoload :Connection, "rocket/connection"
  autoload :Channel,    "rocket/channel"
  autoload :Session,    "rocket/session"
  autoload :CLI,        "rocket/cli"

  def self.start(opts, &blk)
    host = opts.delete(:host) || 'localhost'
    port = opts.delete(:port) || 9772

    EM.epoll
    EM.run do
      trap("TERM") { stop }
      trap("INT")  { stop }
      
      EM::start_server(host, port, Connection, opts, &blk)
    end
  end
  
  def self.stop
    EM.stop
  end
  
  def self.available_apps
    { 'test' => 'secret' }
  end
  
  #def self.logger
  #  @logger ||= begin
  #    logger = Logging.logger["WebSocket"]
  #    logger.add_appenders(Logging.appenders.stdout)
  #    logger.level = :debug
  #    logger
  #  end
  #end
  
  #def self.setup_logger(options)
  #  logger.add_appenders(Logging.appenders.file(options[:file])) if options[:file]
  #  logger.level = options[:log].to_sym if options[:level]
  #  true
  #rescue Object => ex
  #  logger.error ex.to_s and false
  #end
  
  #def self.load_config(file)
  #  options = YAML.load_file(file)
  #rescue Errno::ENOENT => ex
  #  logger.error ex.to_s and false
  #end
  
end # Rocket

require 'rocket/version'

