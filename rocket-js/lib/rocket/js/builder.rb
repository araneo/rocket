require 'yui/compressor'
require 'fileutils'
require 'yaml'

module Rocket
  module JS
    class Builder
      
      CONTENTS = [
        "rocket.license.js", 
      ]
      
      SCRIPTS = [
        "vendor/json/json2.js",
        "vendor/web-socket-js/swfobject.js",
        "vendor/web-socket-js/FABridge.js",
        "vendor/web-socket-js/web_socket.js",
        "rocket.core.js",
        "rocket.channels.js", 
        "rocket.defaults.js",
      ]

      ASSETS = [
        "vendor/web-socket-js/WebSocketMain.swf",
        "vendor/web-socket-js/WebSocketMainInsecure.zip",
      ]
      
      attr_reader :dest
      attr_reader :minified
      
      def initialize(dest, minified=true)
        @dest     = dest
        @minified = minified
      end
      
      def generate
        generate_script
        copy_assets
      end
      
      def generate_script
        FileUtils.mkdir_p(dest)
        source = bundle
        source = minify(source) if minified
        save_script(source)
      end
      
      def bundle
        SCRIPTS.map {|script|
          source = "/* #{File.basename(script)} */\n"
          source += File.read(File.expand_path("../../../../src/#{script}", __FILE__))
          source
        }.join("\n\n")
      end
      
      def minify(src)
        compressor = YUI::JavaScriptCompressor.new(:munge => true)
        compressor.compress(src)
      end
      
      def save_script(source)
        scriptname = "rocket-#{Rocket::JS.version}#{'.min' if minified}.js"
        File.open(File.expand_path(scriptname, dest), 'w+') {|f|
          contents = CONTENTS.map {|content|
            File.read(File.expand_path("../../../../src/#{content}", __FILE__))
          }.join("\n\n").sub(/<%= VERSION %>/, Rocket::JS.version)

          f.write(contents)
          f.write("\n\n")
          f.write(source)
        }
      end
      
      def copy_assets
        ASSETS.each {|asset|
          src  = File.expand_path("../../../../src/#{asset}", __FILE__)
          FileUtils.cp(src, dest)
        }
      end
      
    end # Builder
  end # JS
end # Rocket
