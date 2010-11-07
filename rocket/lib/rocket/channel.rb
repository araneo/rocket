require 'json'

module Rocket
  class Channel
  
    attr_reader :client
    attr_reader :channel
  
    def initialize(client, channel)
      @client  = client
      @channel = channel
    end
    
    def trigger(event, data)
      client.connection do |socket|
        socket.send({ :event => event, :channel => channel, :data => data }.to_json)
      end
    end
    
  end # Channel
end # Rocket
