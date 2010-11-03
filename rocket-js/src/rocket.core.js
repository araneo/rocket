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
      Rocket.log("Rocket : can't establish connection")
      this.connection = {};
      this.onclose();
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
   * Trying reconnect to socket after specified time.
   *
   * @param {integer} delay
   * @return self 
   */
  reconnect: function(delay) {
    var self = this;
    setTimeout(function(){ self.connect(); }, delay);
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
   * Subscribes specified channel and returns it.
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
   * Unsubscribes specified channel.
   *
   *   myChannel = rocket.subscribe('my-channel');
   *   myChannel.bind('unsubscribe', function(data) {
   *     rocket.unsubscribe('my-channel');
   *   });
   *
   * @param {string} channelName
   * @return self
   */
  unsubscribe: function(channelName) {
    this.channels.remove(channelName);
    this.trigger('rocket:unsubscribe', { channel: channelName });
    return this;
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
  
  /**
   * Callback invoked when conneciton is closed.
   *
   * @return void
   */ 
  onclose: function() {
    Rocket.log("Rocket : socket closed");
    this.globalChannel.dispatch('rocket:close', null);
    var time = Rocket.reconnectDelay;
    
    if (!(this.isConnected)) {
      this.globalChannel.dispatch("rocket:disconnected", {});
      
      if (Rocket.allowReconnect) {
        Rocket.log('Pusher : reconnecting in 5 seconds...');
        this.reconnect(time);
      }
    } else {
      this.globalChannel("rocket:connection_failed", {});
      
      if (this.retryCounter == 0){
        time = 100;
      }
      this.retryCounter = this.retryCounter + 1
      this.reconnect(time);
    }
    this.connected = false;
  },
  
  /**
   * Callback invoked when connection is established. 
   *
   * @return void
   */
  onopen: function() {
    this.globalChannel.dispatch('rocket:open', null);
  },
  
  /**
   * Callback invoked when message is received. 
   *
   * @param {string} msg
   * @return void
   */
  onmessage: function(msg) {
    Rocket.log("Rocket : received message : " + msg.data)
    var params = JSON.parse(msg.data);
    var channel = params.channel ? this.channel(params.channel) : this.globalChannel;
    channel.dispatch(params.event, params.data);
  },
};
