module Rocket
  class Channel < EM::Channel
    
    def self.subscribe(name, &block)
      channels[name] ||= new(&block)
    end
    
    def self.channels
      @channels ||= {}
    end
    
  end # Channel
end # Rocket
