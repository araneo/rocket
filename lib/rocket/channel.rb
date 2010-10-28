module Rocket
  class Channel < EM::Channel
    def self.[](id)
      connection, name = id.to_a.flatten
      channels[[connection.app_id, name]] ||= EM::Channel.new
    end
    
    def self.channels
      @channels ||= {}
    end
  end # Channels
end # Rocket
