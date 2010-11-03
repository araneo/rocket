# Launch your web Rocket!

Rocket is very fast and reliable WebSockets server built upon em-websockets library.
Rocket provides also JavaScript toolkit to serve up instructions to clients, and
ruby library which handles events triggering. This Project was strongly inspired 
by awesome PusherApp.

## Installation

All Rockets' components (server, ruby client, javascript library), can be installed 
easily with rubygems (via `rocket` meta package):

    $ gem install rocket
    
... or directly from source:

    $ git clone git://github.com/araneo/rocket
    $ cd rocket/rocket
    $ rake install
    
## Server
 
The main Rocket's feature is powerfull, event-oriented server. Here's simple
scenario of usage:

1. Generate configuration and customize it:

    $ rocket-server configure /etc/rocket/rocket.yml

2. Run server:

    $ rocket-server start
    $ rocket-server start -c my-config.yml      # with other configuration
    $ rocket-server start -h myhost.com -p 8080 # custom host and port
    $ rocket-server start -D -v                 # verbose and debug mode
    $ rocket-server start -d -P my.pid          # daemonized
    ...
    
3. Play with it!

## Ruby client

Ruby client library serves to triggering events. Playing with it is very simple:

    require 'rocket'
    
    rocket = Rocket::Client.new('ws://localhost:9772', 'test_app', 'my-secret-key')
    rocket['my-channel'].trigger('my-event', {:foo => :bar});

## JavaScript library

JavaScript toolkit provided by Rocket is very similar to this from PusherApp.
It allows to serve up instructions to clients using events. Take a look for
example usage:

    $ rocket-js generate /path/to/website/public
    
Command above will generate all necessary javascript and swf files in your
public directory. Now you can use it in your app:

    <script type="text/javascript">
      // The web-socket-js configuration.
      WEB_SOCKET_SWF_LOCATION = 'rocket/WebSocketMain.swf';
      WEB_SOCKET_DEBUG = false;
  
      rocket = new Rocket('ws://localhost:9772', 'test_app');
      myChannel = rocket.subscribe('my-channel');
      myChannel.bind('my-event', function(data) {
        // play with data object
      });
    </script>

## Note on Patches/Pull Requests
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2010 Araneo Ltd. See LICENSE for details.
