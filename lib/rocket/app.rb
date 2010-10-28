module Rocket
  class App
    # Raised when specified app doesn't exist. 
    class NotFoundError < RuntimeError; end
    
    class << self
      # Returns list of all registered apps. 
      def all
        Rocket.static_apps.to_a.map {|id,app| new(app.merge('id' => id)) }
      end
      
      # Returns given app if such is registered.
      #
      #   Rocket::App.find("my-test-app-id")     # => #<Rocket::App>
      #   Rocket::App.find("not-registered-app") # raises Rocket::App::NotFoundError
      #
      def find(app_id)
        if app = Rocket.static_apps[app_id] 
          new(app.merge('id' => app_id))
        else 
          raise NotFoundError, "Application #{app_id.inspect} does not exist!"
        end
      end
    end # << self
    
    attr_accessor :attributes
    
    def initialize(attrs={})
      @attributes = attrs
    end
    
    def id
      attributes['id']
    end
    
    def method_missing(meth, *args, &block) # :nodoc:
      (value = attributes[meth.to_s]) ? value : super(meth, *args, &block)
    end
  end # App
end # Rocket
