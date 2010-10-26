require 'redis'

module Rocket
  module Transports
    class Redis < Base
    
      def initialize(ws, options={})
        super(ws)
        @redis = ::Redis.new(options.merge(:thread_safe => true, :timeout => 0))
      end
      
      def subscribe(channels)
        channels.each do |chan|
          EM.defer do
            @redis.subscribe(chan) {|on|
              on.subscribe do |channel, subscriptions|
                @ws.logger.debug "Subscribing #{channel}(#{subscriptions}) Redis' pubsub channel"
              end 
              on.message do |c,msg|
                @ws.logger.info "Message received from #{chan} Redis' channel: #{msg}" 
                @ws.channel.push msg
              end
            }
          end
        end
      end
      
    end # Redis
  end # Transports
end # Rocket
