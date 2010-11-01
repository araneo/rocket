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

  # Default settings
  set :host, "localhost"
  set :port, 9772
  disable :debug
  disable :secure
  disable :verbose
  disable :quiet
  disable :daemon
  set :pid, nil
  set :log, nil
  set :tls_options, {}
  set :apps, []
  set :plugins, []
  
  class << self
  
    def apps
      @apps ||= settings[:apps] || {}
    end
  
    def logger
      @logger ||= default_logger
    end
    
    def logger=(logger)
      @logger = logger
    end
    
    def load_settings_with_setup(file, local_settings={})
      load_settings_without_setup(file, false)
      settings.merge!(local_settings)
      configure_logger
      require_plugins
      true
    rescue => ex
      puts ex.to_s
      exit 1
    end
    alias_method :load_settings_without_setup, :load_settings
    alias_method :load_settings, :load_settings_with_setup
    
    def require_plugins
      plugins.to_a.each {|plugin| require plugin }
    end
    
    def configure_logger
      logger.add_appenders(Logging.appenders.file(settings[:log])) if log
      logger.level = :debug if verbose
      logger.level = :error if !verbose and quiet
      true
    end
    
    def default_logger
      logger = Logging.logger["Rocket"]
      logger.add_appenders(Logging.appenders.stdout)
      logger.level = :info
      logger
    end
  end # << self 
end # Rocket

require 'rocket/version'

