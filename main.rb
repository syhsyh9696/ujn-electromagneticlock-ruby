# encoding: utf-8

Kernel::judged # Free 18 gpio port

require 'mysql2'
require 'pi_piper'
require 'digest'
require_relative 'kernel'

system("toilet --filter metal 'CENTER408'") # Script logo

while true
    puts "Please put your card on card reader"
    key = gets.chomp!
    if keychaindb(key)
        p "Welcome, #{Time.now}"
    end
end
