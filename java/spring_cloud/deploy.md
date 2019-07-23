# deploy
1. 服务器环境安装
```
# 安装java环境
yum install java-1.8.0-openjdk
# 添加环境变量
vi ~/.bash_profile
export JAVA_HOME=/usr/local/java/jdk1.8.0_201
export JRE_HOME=/usr/local/java/jdk1.8.0_201/jre
PATH=$PATH:$HOME/bin:$JAVA_HOME/bin
export PATH
# 安装maven
yum install maven
```
2. mvn package
3. scp xxx.jar root@xxx.xxx.xx.x:/apps/spring_cloud
4. nohup java -jar xxx.jar > logs/xxx.log &