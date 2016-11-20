# encoding: utf-8

system("echo 18 > /sys/class/gpio/unexport")
system("clear")

require 'mysql2'
require 'pi_piper'
require 'digest'
require_relative 'kernel'

system("toilet --filter metal 'CENTER408'") # Script logo

while true
    # puts "Please put your card on card reader"
    key = gets.chomp!
    addkey?(key)
    keychaindb(key)
end
