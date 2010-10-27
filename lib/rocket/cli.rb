require "optitron"

module Rocket
  class CLI < Optitron::CLI
  
    desc "Show current Rocket version"
    def version
      puts "Rocket v#{Rocket.version}"
    end
    
    desc "Start server on given host and port"
    #opt "config", :shortcut => "-c", :default => "/etc/rocket/default.yml"
    opt "host", :shortcut => "-h", :default => "localhost"
    opt "port", :shortcut => "-p", :default => 9772
    def start
      EM.run do
        params.each {|k,v| params[k.to_sym] = v }
        Rocket.start(params)
      end
    end
    
  end # CLI
end # Rocket
