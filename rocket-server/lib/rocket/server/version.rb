module Rocket
  module Server
    module Version # :nodoc:
      MAJOR  = 0
      MINOR  = 1
      TINY   = 1
      STRING = [MAJOR, MINOR, TINY].join(".")
    end
    
    def self.version # :nodoc:
      Version::STRING
    end # Version
  end # Server
end # Rocket
