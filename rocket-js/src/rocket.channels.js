/** 
 * This object helps with channels management. Examples:
 *
 *   channels = new Rocket.Channels();
 *   channels.add('test');
 *   channels.find('test'); 
 *   channels.remove('test');
 *   // ...
 *
 * @class
 * @constructor
 */
Rocket.Channels = function() {
  this.all = {};
};

Rocket.Channels.prototype = {
  /**
   * Append new channel to the list of registered. 
   *
   * @param {string} channelName
   * @return Rocket.Channel
   */
  add: function(channelName) {
    existingChannel = this.find(channelName)
    if (!existingChannel) {
      return (this.all[channelName] = new Rocket.Channel());
    } else {
      return existingChannel;
    }
  },
  
  /**
   * Returns channel with specified name when it exists.
   *
   * @param {string} channelName
   * @return Rocket.Channel 
   */
  find: function(channelName) {
    return this.all[channelName];
  },
  
  /**
   * Remove specified channel from the list.
   *
   * @param {string} channelName
   * @return void  
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
 *
 * @class
 * @constructor
 */
Rocket.Channel = function() {
  this.callbacks = {};
  this.globalCallbacks = [];
};

Rocket.Channel.prototype = {
  /**
   * Assign callback to given event. More than one callback can be assigned
   * to one event, eg:
   * 
   *   channel.bind('my-event', function(data){ alert('first one!') });
   *   channel.bind('my-event', function(data){ alert('second one!') });
   *
   * @param {string} eventName
   * @param {function} callback
   * @return self 
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
   *
   * @param {function} callback
   * @return self
   */
  bindAll: function(callback) {
    this.globalCallbacks.push(callback);
    return this;
  },
  
  /**
   * Dispatch given event with passing data to all registered callbacks.
   * All global callbacks will be called here too.
   * 
   *   channel.dispatch('my-event', {'hello': 'world'});
   *
   * @param {string} eventName
   * @param {Object} eventData
   * @return void
   */
  dispatch: function(eventName, eventData) {
    var callbacks = this.callbacks[eventName]
    if (callbacks) {
      Rocket.log('Rocket : executing callbacks for ' + eventName)
      for (var i = 0; i < callbacks.length; i++) {
        callbacks[i](eventData);
      }
    } else if (!this.isGlobal) {
      Rocket.log('Rocket : no callbacks for ' + eventName)
    }
    for (var i = 0; i < this.globalCallbacks.length; i++) {
      this.globalCallbacks[i](eventName, eventData);
    }
  }
};
