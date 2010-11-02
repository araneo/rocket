require 'closure-compiler'
require 'sprockets'
require 'fileutils'
require 'yaml'

module Rocket
  module JS
    class Builder
      
      CONTENTS = [
        "rocket.license.js", 
      ]
      
      SCRIPTS = [
        "vendor/web-socket-js/swfobject.js",
        "vendor/web-socket-js/FABridge.js",
        "vendor/web-socket-js/web_socket.js",
        "rocket.channels.js", 
        "rocket.core.js",
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
        FileUtils.mkdir_p(dest)
        
        # Bundle all sources
        source = bundle
        source = minify(source) if minified

        # Save scripts and copy assets to destination directory
        save_script(source)
        copy_assets
      end
      
      def bundle
        SCRIPTS.map {|script|
          source = "/* #{script} */"
          source += File.read(File.expand_path("../../../../src/#{script}", __FILE__))
          source
        }.join("\n\n")
      end
      
      def minify(src)
        compiler = Closure::Compiler.new(:compilation_level => 'ADVANCED_OPTIMIZATIONS')
        compiler.compile(src)
      end
      
      def save_script(source)
        puts dest
        File.open(File.expand_path("rocket#{'.min' if minified}.js", dest), 'w+') {|f|
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
