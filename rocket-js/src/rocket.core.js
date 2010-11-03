/**
 * Rocket base class. Examples:
 *
 *   rocket = new Rocket('ws://host.com:8080', 'my-app'); // no trailing slash in url!
 *   rocket = new Rocket('wss://host.com:433', 'my-secured-app');
 *
 * @class
 * @constructor
 */
var Rocket = function(url, appID) {
  this.socketId;
  this.url = url + '/app/' + appID;
  this.appID = appID;
  this.channels = new Rocket.Channels();
  this.retryCounter = 0;
  this.isConnected = false;
  this.globalChannel = new Rocket.Channel();
  this.globalChannel.isGlobal = true
  this.connect();

  var self = this;
  
  this.globalChannel.bind('rocket:connected', function(data) {
    self.isConnected = true;
    self.retryCounter = 0;
    self.socketId = data.socket_id;
    self.subscribeAll();
  });

  this.globalChannel.bind('rocket:error', function(data) {
    //self.log("Rocket : error : " + data.message);
  });
};

Rocket.prototype = {
  /**
   * Establish connection with specified web socket server. 
   *
   * @return self
   */
  connect: function() {
    Rocket.log('Rocket : connecting with ' + this.url);
    this.allowReconnect = true
    var self = this;

    if (window["WebSocket"]) {
      this.connection = new WebSocket(this.url);
      this.connection.onmessage = function(msg) { self.onmessage(msg); };
      this.connection.onclose = function() { self.onclose(); };
      this.connection.onopen = function() { self.onopen(); };
    } else {
    
    }
    return this;
  },
  
  /**
   * Close connection with web socket server and cleanup configuration.
   *
   * @return self
   */
  disconnect: function() {
    Rocket.log('Rocket : disconnecting');
    this.allowReconnect = false;
    this.isConnected = false;
    this.retryCount = 0;
    this.connection.close();
    return this;
  },
  
  /**
   * Searches for given channel and return it when exists.
   *
   * @param {string} channelName
   * @return Rocket.Channel 
   */
  channel: function(channelName) {
    return this.channels.find(channelName)
  },
  
  /**
   * Trigger given event by sending specified data.
   *
   *   rocket.trigger('rocket:unsubscribe', { channel: 'my-channel' });
   *
   * @param {string} eventName
   * @param {Object} data
   * @return self
   */
  trigger: function(eventName, data) {
    if (this.isConnected) {
      var payload = JSON.stringify({ event: eventName, data: data });
      Rocket.log("Rocket : triggering event : " + payload);
      this.connection.send(payload);
    } else {
      Rocket.log("Rocket : not connected : can't trigger event " + eventName);
    }
    return this;
  },
  
  /**
   * Subscribes given channel and returns this channel object.
   *
   *   myChannel = rocket.subscribe('my-channel');
   *   myChannel.bind('my-event', function(data) {
   *     // do something with received data...
   *   });
   *
   * @param {string} channelName
   * @return Rocket.Channel
   */
  subscribe: function(channelName) {
    var channel = this.channels.add(channelName);
    this.trigger('rocket:subscribe', { channel: channelName });
    return channel;
  },
  
  /**
   * Subscribe all registered channels. It's usualy used to subscribe all 
   * registered just after open connetion (or to re-subscribe after reconnect).
   *
   * @return void 
   */
  subscribeAll: function() {
    for (var channel in this.channels.all) {
      if (this.channels.all.hasOwnProperty(channel)) {
        this.subscribe(channel);
      }
    };
  },
  
  onclose: function() {
  
  },
  
  onopen: function() {
  
  },
  
  onmessage: function(msg) {
    Rocket.log("Rocket : received message : " + msg.data)
    var channel;
    var params = JSON.parse(msg.data);
    
    if (params.channel) {
      channel = this.channel(params.channel);
    } else {
      channel = this.globalChannel;
    }
    
    channel.dispatch(params.event, params.data);
  },
};

// Rocket default configuration.

/*
Pusher.prototype = {
  channel: function(channelName) {
    return this.channels.find(channelName);
  },

  connect: function() {
    Rocket.allowReconnect = true;
    Pusher.log('Rocket : connecting : ' + Rocket.url);

    var self = this;

    if (window["WebSocket"]) {
      this.connection = new WebSocket(Rocket.url);
      this.connection.onmessage = function() {
        self.onmessage.apply(self, arguments);
      };
      this.connection.onclose = function() {
        self.onclose.apply(self, arguments);
      };
      this.connection.onopen = function() {
        self.onopen.apply(self, arguments);
      };
    } else {
      this.connection = {};
      //setTimeout(function(){
      //  self.send_local_event("pusher:connection_failed", {})
      //}, 3000)
    }
  },

  disconnect: function() {
    Pusher.log('Rocket : disconnecting');
    Pusher.allowReconnect = false;
    Pusher.retryCount = 0;
    this.connection.close();
  },

  bind: function(eventName, callback) {
    this.globalChannel.bind(eventName, callback);
    return this;
  },

  bindAll: function(callback) {
    this.globalChannel.bindAll(callback);
    return this;
  },

  subscribeAll: function() {
    for (var channel in this.channels.channels) {
      if (this.channels.channels.hasOwnProperty(channel)) {
        this.subscribe(channel);
      }
    };
  },

  subscribe: function(channelName) {
    var channel = this.channels.add(channelName);
    
    if (this.connected) {
      this.trigger('pusher:subscribe', { channel: channelName });
    }
    return channel;
  },
  
  unsubscribe: function(channelName) {
    this.channels.remove(channelName);

    if (this.connected) {
      this.trigger('pusher:unsubscribe', {
        channel: channelName
      });
    }
  },
  
  trigger: function(eventName, data) {
    var payload = JSON.stringify({ 'event' : eventName, 'data' : data });
    Pusher.log("Pusher : triggering event : ", payload);
    this.connection.send(payload);
    return this;
  },
  
  send_local_event: function(event_name, event_data, channel_name){
     if (channel_name) {
         var channel = this.channel(channel_name);
         if (channel) {
           channel.dispatch_with_all(event_name, event_data);
         }
       }

       this.global_channel.dispatch_with_all(event_name, event_data);
       Pusher.log("Pusher : event received : channel: " + channel_name +
         "; event: " + event_name, event_data);
  },
  
  onmessage: function(evt) {
    var params = JSON.parse(evt.data);
    if (params.socket_id && params.socket_id == this.socket_id) return;

    var event_name = params.event,
        event_data = Pusher.parser(params.data),
        channel_name = params.channel;

    this.send_local_event(event_name, event_data, channel_name);
  },

  wait_and_reconnect: function(perform_toggle, ms_to_wait){
    var self = this;
    setTimeout(function(){
      perform_toggle();
      self.connect();
    }, ms_to_wait)
  },

  onclose: function() {
    var self = this;
    this.global_channel.dispatch('close', null);
    Pusher.log ("Pusher: Socket closed")
    var time = 5000;
    if ( this.connected == true ) {
      this.send_local_event("pusher:connection_disconnected", {});
      if (Pusher.allow_reconnect){
        Pusher.log('Pusher : Reconnecting in 5 seconds...');
        this.wait_and_reconnect(function(){}, time)
    }
    } else {
      self.send_local_event("pusher:connection_failed", {});
      if (this.retry_counter == 0){
        time = 100;
      }
      this.retry_counter = this.retry_counter + 1
      this.wait_and_reconnect(function(){self.toggle_secure()}, time);
    }
    this.connected = false;
  },

  onopen: function() {
    this.global_channel.dispatch('open', null);
  }
};

// Pusher defaults

Pusher.host = "ws.pusherapp.com";
Pusher.ws_port = 80;
Pusher.wss_port = 443;
Pusher.channel_auth_endpoint = '/pusher/auth';
Pusher.log = function(msg){}; // e.g. function(m){console.log(m)}
Pusher.allow_reconnect = true;
Pusher.parser = function(data) {
  try {
    return JSON.parse(data);
  } catch(e) {
    Pusher.log("Pusher : data attribute not valid JSON - you may wish to implement your own Pusher.parser");
    return data;
  }
};
*/
