var Rocket = function(url, appID, channelName) {
  this.socketId;
  
  this.url = url + '/app/' + appID;
  this.appID = appID;
  this.channels = new Rocket.Channels();
  this.globalChannel = new Pusher.Channel();
  this.globalChannel.global = true;
  this.connected = false;
  this.retryCounter = 0;
  this.allowReconnect = false;
  
  this.connect();

  if (channel_name) {
    this.subscribe(channelName);
  }

  var self = this;

  //this.bind('pusher:connection_established', function(data) {
  //  self.connected = true;
  //  self.retry_counter = 0;
  //  self.socket_id = data.socket_id;
  //  self.subscribeAll();
  //});

  //this.bind('pusher:error', function(data) {
  //  Pusher.log("Pusher : error : " + data.message);
  //});
};

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
