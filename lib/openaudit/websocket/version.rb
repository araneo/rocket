module OpenAudit
  module WebSocket
    module Version # :nodoc:
      MAJOR  = 0
      MINOR  = 0
      TINY   = 1
      STRING = [MAJOR, MINOR, TINY].join(".")
    end
    
    def self.version # :nodoc:
      Version::STRING
    end # Version
  end # WebSocket
end # OpenAudit
