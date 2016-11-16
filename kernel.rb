# encoding: utf-8

module Kernel
    Version = "1.5"
    Author = "Yuanhao Sun"

    # MYSQL server ip-address
    Sqlserver = "10.0.0.5"
    Client = Mysql2::Client.new(:host => "#{Sqlserver}", :username => "lab", :password => "default", :database => "labkeychain")

    # GPIO initialization
    Gpionum = "18"
    Gpio = PiPiper::Pin.new(:pin => 18, :direction => :out)

    def keychain
        keychain_array = Array.new
        File.open("keychain.txt", "r") do |io|
            while line = io.gets
                line.chomp!
                keychain_array << line
            end
        end
        return keychain_array
    end

    def getInfo(keychain)
        puts ">> Please put your card on card reader"
        key = gets.chomp!
        keychain.each do |io|
            io = io.split()
            if key == io[0]
                p "Welcome, #{io[1]} #{Time.now}"
                return true
            end
        end
        return false
    end

    def keychaindb(key) # Need gem 'mysql2'
        key = Digest::MD5.hexdigest "#{key}"
        keychain_array = Client.query("SELECT * FROM user WHERE stucard='#{key}'")
        if keychain_array == 0
            return false
        else
            keychain_array.each do |row|
                if row["stucard"] == key
                    p row["stuname"]
                    open()
                    inoutlog(row["stunumber"])
                    return true
                end
            end
        end
        return false
    end

    def duplicate(checkitem) #Eliminate duplicate card number
        check_array = Client.query("SELECT stucard FROM mytable")
        check_array.each do |check|
            if check["stucard"] == checkitem
                return false
            end
        end
        return true
    end

    def keyinsert
        p ">> Please enter the student name $"
        stuname = gets.chomp!
        p ">> Please enter the student number $"
        stunumber = gets.chomp!
        p ">> Please enter the student class $"
        stuclass = gets.chomp!
        p ">> Please put the card on card reader $"
        stucard = gets.chomp!

        if duplicate(stucard)
            Client.query("INSERT INTO mytable VALUES('#{stuname}','#{stunumber}','#{stuclass}','#{stucard}')")
        else
            p "Card error, same card in local database"
        end
    end

    def keyupdate
        #Todo
        return false
    end

    def keydelete
        p ">> Please put the card you want to delete on card reader"
        stucard = gets.chomp!
        Client.query("DELETE FROM mytable where stucard = #{stucard}")
    end

    def open
        Gpio.on
        p "Door open!"
        sleep 3
        Gpio.off
    end

    def inoutlog(stunumber)
        Client.query("INSERT INTO inoutlog VALUES('#{stunumber}','#{Time.now.to_s}')")
        return true
    end

    def judged
        if system("echo 18 > /sys/class/gpio/unexport")
            return true
        end
    end

    def addkey?(key)
        #Todo
    end

    module_function :keychain
    module_function :getInfo
    module_function :keychaindb
    module_function :keyinsert
    module_function :keyupdate
    module_function :keydelete
    module_function :open
    module_function :inoutlog
    module_function :judged
end
