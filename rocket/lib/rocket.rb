module Rocket

  autoload :Helpers,   'rocket/helpers'
  autoload :Client,    'rocket/event'
  autoload :Channel,   'rocket/channel'
  autoload :WebSocket, 'rocket/websocket'

end # Rocket

require 'rocket/version'
