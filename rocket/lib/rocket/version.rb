module Rocket
  module Version # :nodoc:
    MAJOR  = 0
    MINOR  = 0
    TINY   = 4
    STRING = [MAJOR, MINOR, TINY].join(".")
  end # Version
  
  def self.version # :nodoc:
    Version::STRING
  end
end # Rocket
