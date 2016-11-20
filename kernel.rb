# encoding: utf-8

module Kernel
    Version = "2.0"
    Author = "Yuanhao Sun"

    # MYSQL server ip-address
    Sqlserver = "10.0.0.5"
    #client = Mysql2::Client.new(:host => "#{Sqlserver}", :username => "lab", :password => "default", :database => "labkeychain")

    # GPIO initialization
    Gpionum = "18"
    Gpio = PiPiper::Pin.new(:pin => 18, :direction => :out)

    def keychaindb(key) # Need gem 'mysql2'
        addkey?(key)
        client = Mysql2::Client.new(:host => "#{Sqlserver}", :username => "lab", :password => "default", :database => "labkeychain")
        key = Digest::MD5.hexdigest "#{key}"
        keychain_array = client.query("SELECT * FROM user WHERE stucard='#{key}'")
        client.close
        return false if keychain_array == 0
        keychain_array.each do |row|
            if row["stucard"] == key
                open()
                inoutlog(row["stunumber"])
                return true
            end
        end
        return false
    end

    def duplicate(checkitem) #Eliminate duplicate card number
        client = Mysql2::Client.new(:host => "#{Sqlserver}", :username => "lab", :password => "default", :database => "labkeychain")
        check_array = client.query("SELECT stucard FROM mytable")
        client.close
        check_array.each do |check|
            return false if check["stucard"] == checkitem
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
            client = Mysql2::Client.new(:host => "#{Sqlserver}", :username => "lab", :password => "default", :database => "labkeychain")
            client.query("INSERT INTO mytable VALUES('#{stuname}','#{stunumber}','#{stuclass}','#{stucard}')")
            client.close
        else
            p "Card error, same card in local database"
        end
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
        sleep 3
        Gpio.off
    end

    def inoutlog(stunumber)
        client = Mysql2::Client.new(:host => "#{Sqlserver}", :username => "lab", :password => "default", :database => "labkeychain")
        client.query("INSERT INTO log (stunumber) VALUES ('#{stunumber}')")
        client.close
        return true
    end

    def addkey?(key)
        if key == "0963713742"
            p "Add key >>"
            temp = gets.chomp!
            temp = Digest::MD5.hexdigest "#{temp}"
            client = Mysql2::Client.new(:host => "#{Sqlserver}", :username => "lab", :password => "default", :database => "labkeychain")
            client.query("INSERT INTO user VALUES('','','','#{temp}')")
            client.close
            return true
        end
    end

    module_function :keychaindb
    module_function :keyinsert
    module_function :keydelete
    module_function :open
    module_function :inoutlog
    module_function :addkey?
end
