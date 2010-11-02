/** 
 * This object helps with channels management. Examples:
 *
 *   channels = new Rocket.Channels();
 *   channels.add('test');
 *   channels.find('test'); 
 *   channels.remove('test');
 *   // ...
 */
Rocket.Channels = function() {
  this.all = {};
};

Rocket.Channels.prototype = {
  /**
   * Append new channel to the list of registered. 
   */
  add: function(channelName) {
    existingChannel = this.find(channelName)
    if (!existingChannel) {
      return (this.all[channelName] = new Pusher.Channel());
    } else {
      return existingChannel;
    }
  },
  
  /**
   * Returns channel with specified name when it exists. 
   */
  find: function(channelName) {
    return this.all[channelName];
  },
  
  /**
   * Remove specified channel from the list.  
   */
  remove: function(channelName) {
    delete this.all[channelName];
  }
};

/**
 * Single channel. It keeps eg. list of callbacks for all binded events, 
 * and helps with events dispatching. 
 * 
 *   channel = new Rocket.Channel();
 *   channel.bind('my-event', function(data) {
 *     // do something with given data ...
 *   })
 */
Rocket.Channel = function() {
  this.callbacks = {};
  this.globalCallbacks = [];
};

Rocket.Channel.prototype = function() {
  /**
   * Assign callback to given event. More than one callback can be assigned
   * to one event, eg:
   * 
   *   channel.bind('my-event', function(data){ alert('first one!') });
   *   channel.bind('my-event', function(data){ alert('second one!') }); 
   */
  bind: function(eventName, callback) {
    this.callbacks[eventName] = this.callbacks[eventName] || [];
    this.callbacks[eventName].push(callback);
    return this;
  },
  
  /**
   * Creates global callback which will be invoked on all events just after
   * processing callbacks assigned to it.
   *
   *   channel.bindAll(function(event, data){ alert(event) });
   */
  bindAll: function(callback) {
    this.globalCallbacks.push(callback);
    return this;
  },
  
  /**
   * Dispatch given event with passing data to all registered callbacks.
   * All global callbacks will be called here too.
   * 
   *   channel.dispatch('my-event', {'hello': 'world'})
   */
  dispatch: function(eventName, eventData) {
    var callbacks = this.callbacks[eventName]
    if (callbacks) {
      Rocket.log('Rocket : Executing callbacks for ' + eventName)
      for (var i = 0; i < callbacks.length; i++) {
        callbacks[i](eventData);
      }
    } else {
      Rocket.log('Rocket : No callbacks for ' + eventName)
    }
    for (var i = 0; i < this.globalCallbacks.length; i+=) {
      this.globalCallbacks[i](eventName, eventData);
    }
  }
};

/*
Pusher.Channel.prototype = {

  dispatch: function(event_name, event_data) {
    var callbacks = this.callbacks[event_name];

    if (callbacks) {
      for (var i = 0; i < callbacks.length; i++) {
        callbacks[i](event_data);
      }
    } else if (!this.global) {
      Pusher.log('Pusher : No callbacks for ' + event_name);
    }
  },

};
*/
