require 'json'

module Rocket
  # This Rocket client allows for triggering events via Rocket server. 
  # 
  #   rocket = Rocket::Client.new("ws://host.com:9772", "my-app", "my53cr37k3y")
  #   rocket['my-channel'].trigger('event', { :hello => :world })
  #
  class Client
    
    attr_reader :url
    attr_reader :app_id
    attr_reader :secret
    
    def initialize(url, app_id, secret)
      @url    = File.join(url, 'app', app_id) + '?secret=' + secret
      @app_id = app_id
    end
    
    def connection(&block)
      socket = WebSocket.new(url)
      yield(socket)
      socket.close if socket && !socket.tcp_socket.closed?
    end
    
    def [](channel)
      Channel.new(self, channel)
    end
    
  end # Client
end # Rocket
