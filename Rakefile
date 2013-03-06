require "bundler/gem_tasks"

require 'socket'
require 'ipaddress'
require 'phire'
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
  
  my_ip = IPAddress.parse(local_ip + "/24")
  puts "Searching for Hue Hub on network #{my_ip}:"
  
  hub_address = my_ip.detect do |address|
    print "."
    Phire::Hub.new(address).available?
  end
  puts
  
  hub = Phire::Hub.new(hub_address)
  puts "Philips Hue Hub found at #{hub.location}. Software version: #{hub.version}"
end


