require 'eventmachine'
require 'em-websocket'
require 'logging'
require 'redis'

module OpenAudit
  module WebSocket
  
    autoload :Connection, "openaudit/websocket/connection"
    autoload :CLI,        "openaudit/websocket/cli"
  
    def self.start(options, &blk)
      host = options.delete(:host)
      port = options.delete(:port)
      redis_options = options.delete(:redis)
      
      begin
        logger.add_appenders(Logging.appenders.stdout)
        logger.add_appenders(Logging.appenders.file(options[:log])) if options[:log]
        logger.level = options[:log_level].to_sym if options[:log_level]
      rescue Object => ex
        logger.error ex.to_s
        exit(4)
      end
      
      begin
        @redis_channels = redis_options.delete(:channels) || []
        @redis = Redis.new(redis_options)
      rescue Object => ex
        logger.error ex.to_s
        exit(3)
      end
      
      EM.epoll
      EM.run do
        trap("TERM") { stop }
        trap("INT")  { stop }
        
        @redis_channels.each do |chan|
          logger.debug "Subscribing Redis' pubsub channel: #{chan}"
          EM.defer do
            @redis.subscribe(chan) {|on| on.message {|c,msg| channel.push msg } }
          end
        end

        logger.debug "Starting web socket server at #{host}:#{port}"
        EM::start_server(host, port, Connection, options, &blk)
      end
    rescue Object => ex
      logger.error ex.to_s
      exit(2)
    end
    
    def self.stop
      logger.debug "Terminating web socket server..."
      EventMachine.stop
    end
    
    def self.logger
      @logger ||= begin
        logger = Logging.logger["WebSocket"]
        logger.add_appenders(Logging.appenders.stdout)
        logger.level = :debug
        logger
      end
    end
    
    def self.channel
      @channel ||= EM::Channel.new
    end
    
    def self.load_config(file)
      options = YAML.load_file(file)
    rescue Errno::ENOENT => ex
      logger.error ex.to_s
      exit(1)
    end
    
  end # WebSocket
end # OpenAudit

require 'openaudit/websocket/version'

