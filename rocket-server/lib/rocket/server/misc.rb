module Rocket
  module Server
    module Misc
    
      # Generates example config file for Rocket server. 
      def self.generate_config_file(fname)
        File.open(fname, "w+") do |f| 
          f.write(File.read(File.expand_path("../templates/config.yml.tpl", __FILE__))) 
        end
      rescue => e
        puts e.to_s
        exit 1
      end
      
    end # Misc
  end # Server
end # Rocket
