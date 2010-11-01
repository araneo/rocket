module Rocket
  module Server
    module Helpers
      
      include Rocket::Helpers
      
      # Proxy to Rocket's configured logger. 
      def log
        Rocket::Server.logger
      end
      
    end # Helpers
  end # Server
end # Rocket
