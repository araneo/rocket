require 'eventmachine'
require 'em-websocket'
require 'logging'
require "json"

module Rocket
  autoload :CLI,        "rocket/cli"
  autoload :Server,     "rocket/server"
  autoload :Connection, "rocket/connection"
  autoload :Channel,    "rocket/channel"
  autoload :Session,    "rocket/session"
  autoload :App,        "rocket/app"
  autoload :Helpers,    "rocket/helpers"

  class << self
  
    def static_apps
      @apps
    end
  
    def logger
      @logger ||= default_logger
    end
    
    def logger=(logger)
      @logger = logger
    end
    
    private
    
    def default_logger
      logger = Logging.logger["Rocket"]
      logger.add_appenders(Logging.appenders.stdout)
      logger.level = :debug
      logger
    end
  end # << self 
end # Rocket

require 'rocket/version'

