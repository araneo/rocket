module Rocket
  module Version # :nodoc:
    MAJOR  = 0
    MINOR  = 1
    TINY   = 0
    STRING = [MAJOR, MINOR, TINY].join(".")
  end
  
  def self.version # :nodoc:
    Version::STRING
  end # Version
end # Rocket
