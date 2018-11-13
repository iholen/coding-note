## 常用命令(系统：Centos)

### 创建用户并授权
```shell
adduser deploy
passwd deploy

# 添加 sudoers 的写的权限
chmod -v u+w /etc/sudoers

vi /etc/sudoers

## Allow root to run any commands anywhere
root    ALL=(ALL)       ALL
deploy    ALL=(ALL)       ALL （添加这一行）

# 删除 sudoers 的写的权限
chmod -v u-w /etc/sudoers
```

### 