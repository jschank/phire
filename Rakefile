require "bundler/gem_tasks"

require 'socket'
require 'ipaddress'
require 'httparty'
desc "Find the Hue ip address on the local network"
task :find_hue do
  def local_ip
    orig, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true  # turn off reverse DNS resolution temporarily

    UDPSocket.open do |s|
      s.connect '64.233.187.99', 1
      s.addr.last
    end
  ensure
    Socket.do_not_reverse_lookup = orig
  end
  
  def probe(ip)
    begin
      response = HTTParty.get("http://" + ip.to_s + "/api/0/config", :timeout => 3)
    rescue
      response = nil
    end
    response
  end

  my_ip = IPAddress.parse(local_ip + "/24")
  puts "Searching for Hue Hub on network #{my_ip}:"
  
  sw_version = "Not Found"
  hub_ip = my_ip.detect do |address|    
    print "."
    response = probe(address)
    sw_version = response.parsed_response["swversion"] if response && response.code == 200 && response.parsed_response["name"] == "Philips hue"
  end
  puts
  puts "Philips Hue Hub found at #{hub_ip}. Software version: #{sw_version}"
end


