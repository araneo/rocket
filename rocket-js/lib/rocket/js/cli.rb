require 'optitron'

module Rocket
  module JS
    class CLI < Optitron::CLI
      
      desc "Show version of used javascript library"
      def version
        puts "Rocket javascript library v#{Rocket::JS.version}"
      end
      
      desc "Generate Rocket's javascript toolkit in given directory"
      opt "unminified", :short_name => "u", :default => false, :desc => "Generate unminified javascripts (not reccomendend for production)"
      def generate(dest="./")
        Rocket::JS::Builder.new(dest, !params[:unminified]).generate
        puts "Rocket javascript lib saved to #{file}"
      end
      
    end # CLI
  end # JS
end # Rocket
