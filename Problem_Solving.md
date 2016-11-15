# 实验室电磁锁开发遇到的问题
---

## pi_piper的安装
```bash
sudo apt-get install ruby ruby-1.9.1-dev libssl-dev
# 首先切换gem源到ruby-china.org源
# 执行
sudo gem install pi_piper

```
## Windows下的mysql开启远程连接
```
mysql>GRANT ALL PRIVILEGES ON *.* TO 'jack'@'10.0.0.2' IDENTIFIED BY '654321' WITH GRANT OPTION;
mysql>FLUSH RIVILEGES
```
## 脚本logo相关
```bash
# 安装toilet
sudo apt-get install toilet
# 打印logo
toilet --filter metal 'CENTER408'
```
