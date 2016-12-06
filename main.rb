# encoding: utf-8

system("echo 18 > /sys/class/gpio/unexport")
system("clear")

require 'mysql2'
require 'pi_piper'
require 'digest'
require 'socket'
require_relative 'kernel'

system("toilet --filter metal 'CENTER408'") # Script logo

t1 = Thread.new do
    while true
        key = gets.chomp!
        keychaindb(key)
    end
end

t2 = Thread.new do
    tcpserver
end

t1.join
t2.join
