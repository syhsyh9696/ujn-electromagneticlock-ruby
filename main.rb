# encoding: utf-8

require 'mysql2'
require 'pi_piper'
require_relative 'kernel'

Kernel::judged # Free 18 gpio port
system("toilet --filter metal 'CENTER408'") # Script logo

while true
    puts "Please put your card on card reader"
    key = gets.chomp!
    if keychaindb(key)
        p "Welcome, #{Time.now}"
    end
end
