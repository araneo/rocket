require "optitron"
require "openaudit/websocket"

module OpenAudit
  module WebSocket
    class CLI < Optitron::CLI
      desc "Show OpenAudit's WebSocket version"
      def version
        puts "OpenAudit Reporter v#{OpenAudit::WebSocket.version}"
      end
      
      desc "Start server on given host and port"
      opt "config", :shortcut => "-c", :default => "/etc/openaudit/websocket.conf"
      def start(*channels)
        EM.run do
          config = OpenAudit::WebSocket.load_config(params["config"]) or exit(1)
          OpenAudit::WebSocket.start(channels, config)
        end
      end
      
    end # CLI
  end # Reporter
end # OpenAudit
