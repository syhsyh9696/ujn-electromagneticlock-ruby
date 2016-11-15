# 408实验室电磁锁树莓派实现Ruby相关
---

## 1.依赖相关
```bash
# Raspberry PI with Raspbian
# Raspbian with toilet
# Ruby on Raspbian
# Ruby gems pi_piper mysql2

# Toilet
sudo apt-get install toilet

# Ruby on Raspbian
# Check whether install ruby or not
ruby --version
sudo apte-get install ruby
# or use rvm
rvm install 1.9.2 || rvm install 2.2.0

# pi_piper需要的相关依赖
sudo apt-get install ruby ruby-1.9.1-dev libssl-dev
sudo gem install pi_piper mysql2
```
## 2.函数定义
```ruby
# Module::Kernel function
Kernel::keychain # 用于从keychain.txt读入数据(已废弃)
Kernel::getInfo # 获取读入信息(已废弃)
Kernel::keychaindb # 获取数据库信息并比较信息
Kernel::duplicate # 检查学生卡号并去除重复
Kernel::keyinsert # 插入数据库学生信息
Kernel::keydelete # 删除学生数据库相关信息
Kernel::open # 控制Gpio口输出高电平
Kernel::inoutlog # 向数据库 DATABASE:labkeychain.log 内写入出入门等信息
Kernel::judged
Kernel::keyupdate
```

## 3.数据库设计
```
DATABASE: labkeychain
Tables： mytable, log

mytable:
    stuname VARCHAR[20]
    stunumber VARCHAR[11]
    stuclass VARCHAR[20]
    stucard VARCHAR[11]

log:
    stuname VARCHAR[20]
    stunumber VARCHAR[11]
    stuclass VARCHAR[20]
    stucard VARCHAR[11]
    time VARCHAR[25] # UTC TIME
```


## 4.实现过程
```
1. 刷卡器从校园卡内获得数字字符串
2. 数字字符串和远端的mysql进行比对
3. 如果存在该用户，调用Kernel::open函数向GPIO口输出一个高电平
4. 向数据库内写入一条出入记录
5. 延时3秒后GPIO停止输出高电平
```
