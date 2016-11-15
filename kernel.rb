# encoding: utf-8

require 'pi_piper'

module Kernel
    Version = "1.0"
    Author = "Yuanhao Sun"

    # MYSQL server ip-address
    Sqlserver = "10.0.0.5"

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

    def keychaindb(key) #need require mysql2
        client = Mysql2::Client.new(:host => "#{Sqlserver}", :username => "lab", :password => "default", :database => "labkeychain")
        keychain_array = client.query("SELECT * FROM mytable")
        #p keychain_array.count
        keychain_array.each do |row|
            #p row["stuname"]
            #p row["stunumber"]
            #p row["stuclass"]
            #p row["stucard"]
            if row["stucard"] == key
                p row["stuname"]
                open()
                inoutlog(row["stuname"], row["stunumber"], row["stuclass"], row["stucard"])
                return true
            end
            if row["dne"]
                puts row["dne"]
            end
        end
        client.close
        #Method: Mysql2::Client#close
        #Immediately disconnect from the server
        #normally the garbage collector will disconnect automatically when a connection is no longer needed.
        #Explicitly closing this will free up server resources sooner than waiting for the garbage collector.
        return false
    end

    def duplicate(checkitem) #Eliminate duplicate card number
        client = Mysql2::Client.new(:host => "#{Sqlserver}", :username => "lab", :password => "default", :database => "labkeychain")
        check_array = client.query("SELECT stucard FROM mytable")
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
        client = Mysql2::Client.new(:host => "#{Sqlserver}", :username => "lab", :password => "default", :database => "labkeychain")
        if duplicate(stucard)
            client.query("INSERT INTO mytable VALUES('#{stuname}','#{stunumber}','#{stuclass}','#{stucard}')")
        else
            p "Card error, same card in local database"
        end
        client.close
    end

    def keyupdate
        #Todo
        return false
    end

    def keydelete
        p ">> Please put the card you want to delete on card reader"
        stucard = gets.chomp!
        client = Mysql2::Client.new(:host => "#{Sqlserver}", :username => "lab", :password => "default", :database => "labkeychain")
        client.query("DELETE FROM mytable where stucard = #{stucard}")
        client.close
    end

    def open
        Gpio.on
        p "Door open!"
        sleep 3
        Gpio.off
    end

    def inoutlog(stuname, stunumber, stuclass, stucard)
        client = Mysql2::Client.new(:host => "#{Sqlserver}", :username => "lab", :password => "default", :database => "labkeychain")
        client.query("INSERT INTO log VALUES('#{stuname}','#{stunumber}','#{stuclass}','#{stucard}','#{Time.now.to_s}')")
        return true
    end

    def judged
        if File.directory?'/sys/class/gpio/gpio18'
            system("echo 18 > /sys/class/gpio/unexport")
            return false
        else
            return true
        end
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
