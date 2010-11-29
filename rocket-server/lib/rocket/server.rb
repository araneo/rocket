begin
  require 'fastthread'
rescue LoadError
  puts "WARNING: You don't have fastthread gem installed. It's recommended" +
       "to use it for better performance."
  require 'thread'
end

require "konfigurator"
require 'eventmachine'
require 'em-websocket'
require 'logging'
require 'fileutils'
require 'json'
require 'yaml'

module Rocket
  module Server
  
    autoload :Helpers,    "rocket/server/helpers"
    autoload :CLI,        "rocket/server/cli"
    autoload :Runner,     "rocket/server/runner"
    autoload :Connection, "rocket/server/connection"
    autoload :Channel,    "rocket/server/channel"
    autoload :Session,    "rocket/server/session"
    autoload :App,        "rocket/server/app"
    autoload :Misc,       "rocket/server/misc"

    include Konfigurator::Simple

    # Default configuration
    set :host, "localhost"
    set :port, 9772
    disable :debug
    disable :secure
    disable :verbose
    disable :quiet
    disable :daemon
    set :pid, "/var/run/rocket/server.pid"
    set :log, "/var/log/rocket/server.log"
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
  end # Server
end # Rocket
