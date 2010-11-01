# On which host and port server should listen for connections. 
host: localhost
port: 9772

# Run applicaiton in secured mode (wss).
#secure: true
secure: false

# Specify prefered verbosity level.
#verbose: true # Increase verbosity
#quiet: true # Decrease verbosity
verbose: true

# Run web sockets server in debug mode.
#debug: true
debug: false

# Run daemonized instance of Rocket server.
#daemon: true
daemon: false

# Specify path to server process' PID file. This option works only
# when server is daemonized.  
#pid: /var/run/rocket.pid

# Specify path to server's output log. 
#log: /var/log/rocket.log

# SSL certificates configuration.
#tls_options:
#  private_key_file: /home/ssl/private.key
#  cert_chain_file: /home/ssl/certificate

# Here you can specify all static apps allowed to run on this server. 
# Apps are kind of namespaces with separated authentication.
apps:
  test_app_key: secretkey
