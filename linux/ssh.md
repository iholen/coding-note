## 本地免密码登录服务器
### 本地
生成SSH KEY(带上用户信息最佳)

* `ssh-keygen -t rsa -C "hu.l@ikcrm.com"`
* `cat ~/.ssh/id_rsa.pub`
### 服务器
* `mkdir ~/.ssh`
* `touch ~/.ssh/authorized_keys`
* `chmod 600 ~/.ssh/authorized_keys`
* 将本地操作的第二步输出的结果添加到authorized_keys文件中
* service sshd restart