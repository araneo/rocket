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

  class << self
    def static_apps
      @apps
    end
  
    def log
      unless @log
        @log = Logging.logger["Rocket"]
        @log.add_appenders(Logging.appenders.stdout)
        @log.level = :debug
      end
      @log
    end
  end # << self
  
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

