## 本地免密码登录服务器
### 本地
生成SSH KEY(带上用户信息最佳)

* `ssh-keygen -t rsa -C "hu.l@ikcrm.com"`
* `cat ~/.ssh/id_rsa.pub`
### 服务器
* `su deploy`
* `mkdir ~/.ssh && chmod 700 ~/.ssh`
* `touch ~/.ssh/authorized_keys`
* `chmod 600 ~/.ssh/authorized_keys`
* 将本地操作的第二步输出的结果添加到authorized_keys文件中
* [可选]禁用通过密码验证: `vi /etc/ssh/sshd_config`, 设置`PasswordAuthentication no`
* service sshd restart

## iTerm2 Scripts应用
1. cd $HOME/Library/Application\ Support/iTerm2/Scripts
2. 新建test.scpt文件
3. 
```
tell application "iTerm"
  tell current window
    create tab with default profile
  end tell

  tell first session of current tab of current window
    set name to "ik-test"
    write text "ssh jump"
    write text "ssh tt"
    write text "zsh"
    write text "itt"
    split vertically with default profile
  end tell
end tell
```
