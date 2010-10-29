require "optitron"

module Rocket
  class CLI < Optitron::CLI
    
    include Helpers
    
    desc "Show current Rocket version"
    def version
      puts "Rocket v#{Rocket.version}"
    end
    
    desc "Start Rocket server on given host and port"
    opt "config",  :short_name => "c", :default => "/etc/rocket/default.yml",    :desc => "Path to configuration file" 
    opt "host",    :short_name => "h", :default => "localhost",                  :desc => "Specify server host"
    opt "port",    :short_name => "p", :default => 9772,                         :desc => "Specify server port"
    opt "plugins", :short_name => "r", :default => [],                           :desc => "Require ruby extensions at runtime"
    opt "secure",  :short_name => "s", :default => false,                        :desc => "Switch between wss/ws modes"
    opt "debug",   :short_name => "D", :default => false,                        :desc => "Run in debug mode"
    opt "quiet",   :short_name => "Q", :default => false,                        :desc => "Show only fatal errors"
    opt "daemon",  :short_name => "d", :default => false,                        :desc => "Run server as a daemon"
    opt "pid",     :short_name => "P", :default => "/var/run/rocket/server.pid", :desc => "Path to PID file (only when daemonized)"
    opt "log",     :short_name => "l", :default => nil,                          :desc => "Path to log file"
    def start
      Rocket.load_settings(params.delete('config'), symbolize_keys(params))
      Rocket::Server.new(Rocket.settings).start!
    end
    
    desc "Stop daemonized instance of Rocket server"
    opt "config",  :short_name => "c", :default => "/etc/rocket/default.yml",    :desc => "Path to configuration file" 
    opt "pid",     :short_name => "P", :default => "/var/run/rocket/server.pid", :desc => "Path to PID file (only when daemonized)"
    def stop
      Rocket.load_settings(params.delete('config'), symbolize_keys(params))
      
      if pid = Rocket::Server.new(Rocket.settings).kill!
        puts "Rocket server killed (PID: #{pid})"
      else
        puts "No processes were killed!"
      end
    end
    
    desc "Generate configuration file"
    def configure(file="rocket.yml")
      Rocket::Misc.generate_config_file(file)
      puts "Created Rocket's server configuration: #{file}"
    end
    
  end # CLI
end # Rocket
