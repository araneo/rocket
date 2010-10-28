module Rocket
  class Channel < EM::Channel
    # Get specfied channel for given app or create it if doesn't exist.
    #
    #   Channel["my-app" => "testing-channel"] # => #<Rocket::Channel>
    #   Channel["my-another-app" => "next-one"]
    def self.[](id)
      app, name = id.to_a.flatten
      channels[[app, name]] ||= new
    end
    
    # Returns list of registered channels.
    def self.channels
      @channels ||= {}
    end
  end # Channels
end # Rocket
