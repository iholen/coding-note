# 使用docker运行rails项目
基本使用
### 相关命令
```
# 拉取 ruby 镜像,版本为 2.5-alpine
docker pull ruby:2.5-alpine

# 查看所有镜像
docker images

# 删除镜像
docker rmi <image_name>:<image_version>

# -it 运行镜像并进入命令行模式
docker run -it ruby:2.5-alpine sh

# 加上 --rm 参数时，在容器内的命令行执行完 exit 命令后, 容器会一起删除
docker run -it --rm ruby:2.5-alpine sh

# -d 以守护进程运行
docker run -d ruby:2.5-alpine

# -v 设置数据卷
docker run -it -v <local_path>:<container_path> ruby:2.5-alpine sh

# -e 添加环境变量
docker run -d -e MYSQL_ALLOW_EMPTY_PASSWORD=true mysql:5.7

# --name 设置别名
docker run --name test -d -e MYSQL_ALLOW_EMPTY_PASSWORD=true mysql:5.7

# 查看运行中容器的日志
docker logs container_id

# exec 容器中执行
docker exec -it <container_id> sh

# 数据卷查看
docker volume ls

# 数据卷删除
docker volume rm <volume_name>

# 数据卷创建
docker volume create <volume_name>

# --link 容器通信
docker run --name test -d -e MYSQL_ALLOW_EMPTY_PASSWORD=true mysql:5.7
docker run -it --rm --link test:db1 alpine sh
```
### Dockerfile
使用Dockerfile构建镜像。

##### Dockerfile示例
```
FROM ruby:2.5-alpine

# 设置apk源
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories
# 更新apk并安装软件
RUN apk update && apk add build-base tzdata mariadb-client mariadb-dev

# 修改bundle源
RUN bundle config mirror.https://rubygems.org https://gems.ruby-china.com
# 修改gem源
RUN gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/

# 创建目录
RUN mkdir -p /usr/src/app
# 镜像运行之后的工作目录
WORKDIR /usr/src/app
```

##### 相关命令
```
# 构建镜像, version 不指定时默认为 latest
docker build . -t <name>(:<version>)
```

### docker-compose
##### docker-compose.yml示例
```
version: '3'
# 此处的 volumes 定义会在 build 之后在主机上创建两个 volumes
# 可通过 docker volume ls 查看
volumes:
  db:
  gems:
services:
  db:
    image: mysql:5.7
    volumes:
      - db:/var/lib/mysql
    environment:
      - MYSQL_ALLOW_EMPTY_PASSWORD=true
    ports:
      - "3307:3306"
  app:
    build: .
    command: bundle exec rails s -b 0.0.0.0
    tty: true
    stdin_open: true
    ports:
      - "3000:3000"
    depends_on:
      - db
    volumes:
      - .:/usr/src/app:cached
      - gems:/usr/local/bundle
```
##### 相关命令
```
# 构建镜像
docker-compose build

# 启动构建的镜像
docker-compose up

# 启动yml文件中具体的service
docker-compose run app sh

# 创建数据库
docker-compose run --rm app rails db:create

# 运行迁移
docker-compose run --rm app rails db:migrate

# rails断点调试时
docker attach container_id(ctrl+p+q)
```

