// The web-socket-js default configuration.
 
// Where your WebSocketMain.swf is located?
var WEB_SOCKET_SWF_LOCATION = 'WebSocketMain.swf';
// Run web socket in debug mode?
var WEB_SOCKET_DEBUG = false;

// Rocket defaults. 
 
/**
 * Default logger. You can replace it with your own, eg. 
 *
 *   Rocket.log = function(msg) { console.log(msg) };
 *
 * @param {string} msg
 * @return void 
 */
Rocket.log = function(msg) {
  // nothing to do...
};

/**
 * Default data parser. By default received data is treated as JSON. You 
 * can change this behaviour by replacing this parser.
 *
 * @param {string} data
 * @return Object or string
 */
Rocket.parser = function(data) {
  try {
    return JSON.parse(data);
  } catch(e) {
    Pusher.log("Rocket : data attribute not valid JSON - you may wish to implement your own Rocket.parser");
    return data;
  }
};
