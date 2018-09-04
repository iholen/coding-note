### Nginx的基本配置和参数说明

```config
#运行用户,如果不设置会默认显示为nobody
#user nobody;
#启动进程,通常设置成和cpu的数量相等,可通过 cat /proc/cpuinfo | grep name | cut -f2 -d: | uniq -c 查看cpu信息
worker_processes  4;
 
#设置错误日志文件存放位置,可指定参数
#error_log  logs/error.log [notice,info]; 
#设置PID文件
#pid logs/nginx.pid;
 
#工作模式及连接数上限
events {
    #epoll是多路复用IO(I/O Multiplexing)中的一种方式,
    #仅用于linux2.6以上内核,可以大大提高nginx的性能
    use epoll; 
 
    #单个后台worker process进程的最大并发链接数    
    worker_connections  1024;
 
    # 并发总数是 worker_processes 和 worker_connections 的乘积
    # 即max_clients = worker_processes * worker_connections
    # 在设置了反向代理的情况下，max_clients = worker_processes * worker_connections / 4
    # 上面反向代理要除以的4是一个经验值
    # 反向代理设置：
    # server {
    #   listen 80;
    #   location / {
    #       proxy_pass http://192.168.0.112:8080; #应用服务器HTTP地址
    #   }
    # }
}

http {
    #设定mime类型,类型由mime.type文件定义
    include    mime.types;
    default_type  application/octet-stream;
    
    charset utf-8;  
    
    #设定日志格式
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';
 
    access_log  logs/access.log  main;
 
    #sendfile 指令指定 nginx 是否调用 sendfile 函数（zero copy 方式）来输出文件，
    #对于普通应用，必须设为 on,
    #如果用来进行下载的应用和磁盘IO重负载的应用，可设置为 off，
    #以平衡磁盘与网络I/O处理速度，降低系统的uptime.
    sendfile     on;
    tcp_nopush     on;
 
    #连接超时时间
    #keepalive_timeout  0;
    keepalive_timeout  65;
    tcp_nodelay     on;
 
    #开启gzip压缩
    gzip  on;
    gzip_disable "MSIE [1-6].";
 
    #设定请求缓冲
    client_header_buffer_size    128k;
    large_client_header_buffers  4 128k;
 
 
    # ===== App Server  
    upstream app_server{  
        server unix:/var/tmp/.unicorn.sock fail_timeout=0;  
    }
    #设定虚拟主机配置
    server {
        set $app_root /home/lucien/study/b2c/shopping;
        #侦听80端口
        listen  80;
        #定义使用localhost访问
        server_name localhost;
 
        #定义服务器的默认网站根目录位置
	       root $app_root/public;
 
        #设定本虚拟主机的访问日志
	       access_log  logs/nginx_access.log;
        error_log   logs/nginx_error.log; 

        rewrite_log     on;  
 
        try_files $uri/index.html $uri.html $uri @app_server; 
        
        location @app_server {
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header Host $host;
          proxy_set_header X-Forwarded-Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          
          proxy_buffering  on;
          proxy_redirect   off;
          proxy_pass http://localhost:3000;
        }
        
        #配置错误页面
        location =/500.html {
             root $app_root/public;
        }
        
        #禁止访问 .htxxx 文件
        location ~ /.ht {
            deny all;
        }
    }
}
```
----------
作者 [@holen](https://github.com/holen)

2017 年 09月 22日
