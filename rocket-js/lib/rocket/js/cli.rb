require 'optitron'

module Rocket
  module JS
    class CLI < Optitron::CLI
      
      desc "Show version of used javascript library"
      def version
        puts "Rocket javascript library v#{Rocket.version}"
      end
      
      desc "Generate Rocket's javascript toolkit in given directory"
      opt "unminified", :short_name => "u", :default => false, :desc => "Generate unminified javascripts (not reccomendend for production)"
      def generate(dest="./")
        Rocket::JS::Builder.new(dest, !params[:unminified]).generate
        puts "Newly generated Rocket files has been placed in #{dest}"
      rescue => ex
        puts ex.to_s
        exit(1)
      end
      
    end # CLI
  end # JS
end # Rocket
