require 'socket'
require 'ipaddress'
require 'httparty'

module Phire
  class Hub
    include HTTParty
    
    API_KEY = "fd474be3b40e2b37e592b21679c7d6f8"
    TIMEOUT = 3    
  
    attr_reader :location
  
    def initialize(server)
      @location = server.to_s
      self.class.base_uri @location
    end
      
    def version
      begin
        response = self.class.get("/api/0/config", :timeout => TIMEOUT)
        version = response.parsed_response["swversion"] if response && response.code == 200 && response.parsed_response["name"] == "Philips hue"
      rescue
        version = response.message
      end
    end
        
    def available?
      begin
        response = self.class.get("/api/0/config", :timeout => TIMEOUT)
        response && response.code == 200 && response.parsed_response["name"] == "Philips hue"
      rescue
        false
      end
    end
    
  end
end
