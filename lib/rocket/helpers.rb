module Rocket
  module Helpers
    
    def symbolize_keys(hash)
      return hash unless hash.is_a?(Hash)
      hash.inject({}) do |options, (key, value)|
        options[(key.to_sym if key.respond_to?(:to_sym)) || key] = value
        options
      end
    end
    
    def log
      Rocket.logger
    end
    
    %w[ info debug warn error fatal ].each do |level|
      define_method(level) do |*args|
        message = args.shift
        message = self.class::LOG_MESSAGES[message] if message.is_a?(Symbol)
        log.send(level).call(message % args) unless ENV['ROCKET_ENV'] == 'test'
      end
    end
    
  end # Helpers
end # Rocket
