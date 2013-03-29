require 'httparty'
require 'ipaddress'

module Phire
  class Hub
    include HTTParty
    
    API_KEY = "fd474be3b40e2b37e592b21679c7d6f8"
    TIMEOUT = 3    
  
    attr_reader :location   

    def self.scan(ip)
      IPAddress.parse(ip.to_s + "/24").detect do |address|
        print "."
        begin
          @last_response = HTTParty.get("http://#{address.to_s}/api/0/config", :timeout => TIMEOUT)
          @last_response && @last_response.code == 200 && @last_response.parsed_response["name"] == "Philips hue"
        rescue
          false
        end
      end
    end
  
    def initialize(server)
      @location = server.to_s
      self.class.base_uri @location
    end
    
    def check_api_key(key = API_KEY)
      @last_response = self.class.get("/api/#{key}", :timeout => TIMEOUT)
      @last_response.code == 200 && @last_response.parsed_response.class != Array
    rescue Exception => e
        puts "Philips Hue not responding at #{location}"
        puts "Exeption: #{e.message}"
        false
    end
    
    def request(path, key = API_KEY)
      @last_response = self.class.get("/api/#{key}/#{path}", :timeout => TIMEOUT)
    end
      
    def version
      response = request("config", 0)
      version = response.parsed_response["swversion"] || "unknown"
    rescue
      report_last_response
    end    
    
    def report_last_response
      if !@last_response
        puts "Last response is empty."
        return false
      elsif @last_response && @last_response.code == 200 && @last_response.parsed_response.class != Array && @last_response.parsed_response["config"]["name"] == "Philips hue"
        puts "ok"
        return true 
      else
        puts "Error communicating with Philipps Hue"
        puts "Error code: #{@last_response.code} - #{@last_response.message}"
        if @last_response.parsed_response.class == Array
          @last_response.parsed_response.each do |resp|
            puts "Error: type #{resp["error"]["type"]} - #{resp["error"]["description"]}"
            puts "Try pressing link button on hub, and re-running script" if resp["error"]["description"] == "unauthorized user"
          end
        end
        return false
      end
    end
       
    def lights
      lights = request("lights")
      lights.keys.map do |light|
        Light.new(request("lights/#{light}").parsed_response)
      end
    end
            
  end
end
