module Rocket
  module Server
    module Helpers
      
      include Rocket::Helpers
      
      # Proxy to Rocket's configured logger. 
      def log
        Rocket::Server.logger
      end
      
      %w[ info debug warn error fatal ].each do |level|
        define_method("log_#{level}") do |*args|
          message = args.shift
          message = self.class::LOG_MESSAGES[message] if message.is_a?(Symbol)
          log.send(level, message % args)
        end
      end
      
    end # Helpers
  end # Server
end # Rocket
