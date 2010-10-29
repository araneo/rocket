require "konfigurator"
require 'eventmachine'
require 'em-websocket'
require 'logging'
require 'fileutils'
require 'json'
require 'yaml'

module Rocket
  autoload :CLI,        "rocket/cli"
  autoload :Server,     "rocket/server"
  autoload :Connection, "rocket/connection"
  autoload :Channel,    "rocket/channel"
  autoload :Session,    "rocket/session"
  autoload :App,        "rocket/app"
  autoload :Helpers,    "rocket/helpers"
  autoload :Misc,       "rocket/misc"

  include Konfigurator::Simple

  class << self
  
    def apps
      @apps ||= {}
    end
  
    def logger
      @logger ||= default_logger
    end
    
    def logger=(logger)
      @logger = logger
    end
    
    alias :konfigurator_load_settings :load_settings
    
    def load_settings(file, overwrites={})
      konfigurator_load_settings(settings, false)
      settings.merge!(overwrites)
      configure_logger
      require_plugins
      true
    rescue => ex
      puts ex
      exit 1
    end
    
    private
    
    def require_plugins
      plugins = settings.delete(:plugins).to_a
      plugins.each {|plugin| require plugin }
    end
    
    def configure_logger
      logfile  = settings.delete(:log)
      debug    = settings.delete(:debug)
      quiet    = settings.delete(:quiet)
      
      logger.add_appenders(Logging.adapters.file(logfile)) if logfile
      logger.level = :debug if debug
      logger.level = :fatal if !debug and quiet
      
      true
    end
    
    def default_logger
      logger = Logging.logger["Rocket"]
      logger.add_appenders(Logging.appenders.stdout)
      logger.level = :debug
      logger
    end
  end # << self 
end # Rocket

require 'rocket/version'

