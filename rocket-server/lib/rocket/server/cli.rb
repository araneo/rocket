require "optitron"

module Rocket
  module Server
    class CLI < Optitron::CLI
      
      include Helpers
      
      desc "Show used version of Rocket server"
      def version
        puts "Rocket Server v#{Rocket.version}"
      end
      
      desc "Start Rocket server on given host and port"
      opt "config",  :short_name => "c", :desc => "Path to configuration file" 
      opt "host",    :short_name => "h", :desc => "Specify server host"
      opt "port",    :short_name => "p", :desc => "Specify server port"
      opt "plugins", :short_name => "r", :desc => "Require ruby extensions at runtime"
      opt "secure",  :short_name => "s", :desc => "Switch between wss/ws modes"
      opt "verbose", :short_name => "v", :desc => "Increase verbosity"
      opt "quiet",   :short_name => "q", :desc => "Decrease verbosity"
      opt "debug",   :short_name => "D", :desc => "Run server in debug mode"
      opt "daemon",  :short_name => "d", :desc => "Run server as a daemon"
      opt "pid",     :short_name => "P", :desc => "Path to PID file (only when daemonized)"
      opt "log",     :short_name => "l", :desc => "Path to log file"
      def start
        config_file = params.delete('config') || '/etc/rocket/default.yml'
        Rocket::Server.load_settings(config_file, symbolize_keys(params))
        Rocket::Server::Runner.new(Rocket::Server.settings).start!
      end
      
      desc "Stop daemonized instance of Rocket server"
      opt "config",  :short_name => "c", :desc => "Path to configuration file" 
      opt "pid",     :short_name => "P", :desc => "Path to PID file (only when daemonized)"
      def stop
        Rocket::Server.load_settings(params.delete('config'), symbolize_keys(params))
        
        if pid = Rocket::Server::Runner.new(Rocket::Server.settings).kill!
          puts "Rocket server killed (PID: #{pid})"
        else
          puts "No processes were killed!"
        end
      end
      
      desc "Generate configuration file"
      def configure(file="rocket.yml")
        Rocket::Server::Misc.generate_config_file(file)
        puts "Created Rocket's server configuration: #{file}"
      end
      
    end # CLI
  end # Server
end # Rocket
