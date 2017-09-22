## Nginx安装

### 安装包列表

+ `ssl`功能需要[openssl](https://www.openssl.org/)库
+ `gzip`模块需要[zlib](http://www.zlib.net/)库
+ `rewrite`模块需要[pcre](http://www.pcre.org/)库

### 安装顺序

依赖包安装顺序依次为:openssl、zlib、pcre, 最后安装Nginx包。

### 安装包下载

```shell
wget https://www.openssl.org/source/openssl-fips-2.0.16.tar.gz
wget http://www.zlib.net/zlib-1.2.11.tar.gz
wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.38.tar.gz
wget http://nginx.org/download/nginx-1.13.5.tar.gz
```

### **依次**编译安装

```shell
tar -zxvf openssl-fips-2.0.16.tar.gz && cd openssl-fips-2.0.16
./config 
make && make install
```

```shell
tar -zxvf zlib-1.2.11.tar.gz && cd zlib-1.2.11
./configure
make && make install
```

```shell
tar -zxvf pcre-8.38.tar.gz && cd pcre-8.38
./configure
make && make install
```

```shell
tar -zxvf nginx-1.13.5.tar.gz && cd nginx-1.13.5
./configure --with-pcre=../pcre-8.38 --with-zlib=../zlib-1.2.11 --with-openssl=../openssl-fips-2.0.16
make && make install
```

### 检测是否安装成功
```shell
cd  /usr/local/nginx/sbin
./nginx -t
```

出现如下图的提示表示安装成功

![Nginx_install_success](nginx_install_success.jpg)

**至此Nginx的安装完成!**

**注：按照以上步骤安装完后，nginx相关文件的位置**
```shell
  nginx path prefix: "/usr/local/nginx"
  nginx binary file: "/usr/local/nginx/sbin/nginx"
  nginx modules path: "/usr/local/nginx/modules"
  nginx configuration prefix: "/usr/local/nginx/conf"
  nginx configuration file: "/usr/local/nginx/conf/nginx.conf"
  nginx pid file: "/usr/local/nginx/logs/nginx.pid"
  nginx error log file: "/usr/local/nginx/logs/error.log"
  nginx http access log file: "/usr/local/nginx/logs/access.log"
  nginx http client request body temporary files: "client_body_temp"
  nginx http proxy temporary files: "proxy_temp"
  nginx http fastcgi temporary files: "fastcgi_temp"
  nginx http uwsgi temporary files: "uwsgi_temp"
  nginx http scgi temporary files: "scgi_temp"
```

------
作者 [@GLucien](https://github.com/GLucien)

2017 年 09月 21日
