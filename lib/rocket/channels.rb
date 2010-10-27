module Rocket
  class Channels < Hash
    def initialize(connection, *args)
      @connection = connection
      super(*args)
    end
    
    def [](name)
      unless key?(name)
        self[name] = EM::Channel.new
        self[name].subscribe {|msg| @connection.send(msg) }
      end
      super(name)
    end
  end # Channels
end # Rocket
