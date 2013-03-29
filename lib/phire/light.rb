module Phire
  
  class Light 
    
    attr_reader :id
        
    def initialize(hub, id, attributes = {})
      @attributes = attributes
      @hub = hub
      @id = id
    end
        
    def method_missing(name, *args)
      method_name = name.to_s
      if method_name.end_with?("=")
        key = method_name.chop
        raise ArgumentError, "Property #{key} is read-only" if %w(modelid pointsymbol swversion type reachable).include? key
        return @attributes[key] = args[0] if @attributes.key? key
        return @attributes["state"][key] = args[0] if @attributes["state"].key? key
      else
        return @attributes[method_name] if @attributes.key? method_name
        return @attributes["state"][method_name] if @attributes["state"].key? method_name
      end
      super
    end
    
    def update
      @hub.update_light(self)
    end
            
  end
  
end