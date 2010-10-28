require 'eventmachine'
require 'em-websocket'
require 'logging'

module Rocket
  autoload :CLI,        "rocket/cli"
  autoload :Server,     "rocket/server"
  autoload :Connection, "rocket/connection"
  autoload :Channel,    "rocket/channel"
  autoload :Session,    "rocket/session"
  autoload :App,        "rocket/app"

  def self.load_apps(file)
    apps = {}
    File.read(file).split(/$/).each {|entry|
      entry
    }
  end
  
  def self.apps
    @apps
    #@apps ||= load_apps(self.config.apps_file)
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

