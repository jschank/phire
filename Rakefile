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

  hub_address = Phire::Hub.scan(my_ip)
  puts "hub address = #{hub_address}"

  hub = Phire::Hub.new(hub_address)
  puts "Philips Hue Hub found at #{hub.location}. Software version: #{hub.version}"
end

desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -rubygems -I lib -r phire.rb"
end

desc "Open an pry session preloaded with this library"
task :debug do
  sh "pry -I lib -r phire.rb"
end
