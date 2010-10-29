module Rocket
  module Helpers
    
    # Hash given, returns it version with symbolized keys. 
    #
    #   p symbolize_keys("hello" => "world", ["Array here"] => "yup")
    #   p symbolize_keys(:one => 1, "two" => 2)
    # will produce:
    #
    #  {:hello => "world", ["Array here"] => "yup"}
    #  {:one => 1, :two => 2}
    #
    def symbolize_keys(hash)
      return hash unless hash.is_a?(Hash)
      hash.inject({}) do |options, (key, value)|
        options[(key.to_sym if key.respond_to?(:to_sym)) || key] = value
        options
      end
    end
    
    # Proxy to Rocket's configured logger. 
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
