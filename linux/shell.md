## 常用命令

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

### grep命令
* grep -C 5 keyword file_path  显示file文件中匹配foo字串那行以及上下5行
* grep -B 5 keyword file_path  显示foo及前5行
* grep -A 5 keyword file_path  显示foo及后5行