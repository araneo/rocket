require "optitron"

module Rocket
  class CLI < Optitron::CLI
  
    desc "Show current Rocket version"
    def version
      puts "Rocket v#{Rocket.version}"
    end
    
    desc "Start server on given host and port"
    opt "config", :shortcut => "-c", :default => "/etc/rocket/default.yml"
    def start(*channels)
      EM.run do
        config = Rocket.load_config(params["config"]) or exit(1)
        Rocket.start(channels, config)
      end
    end
    
  end # CLI
end # Rocket
