## Capistrano + Puma + Nginx 部署Rails应用
### 设置免登和权限
1. 本地 => 服务器(deploy用户)
2. 服务器(deploy用户的id_rsa.pub) => github/gitlib
3. 创建deploy_to设置的目录(/var)权限: `chmod g+w /var`
### 服务器环境安装
* [rvm](https://rvm.io/)
```
gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB

\curl -sSL https://get.rvm.io | bash -s stable

// rvm安装完后
source .bash_profile
```
* Ruby
```
sudo yum install -y autoconf automake bison libffi-devel libtool readline-devel sqlite-devel zlib-devel openssl-devel

rvm install 2.3.7
```

### 设置SECRET\_KEY\_BASE
```
// 生成secret_key_base
RAILS_ENV=production rake secret

// 将生成的code加到config/secrets.yml文件中
```

### 安装Nginx
```
yum install epel-release
yum install nginx 

systemctl start nginx #启动
systemctl enable nginx #自启动
systemctl status nginx #状态查看
systemctl stop nginx #启动
systemctl restart nginx #启动

// 对于开启了防火墙的情况
firewall-cmd --zone=public --permanent --add-service=http
firewall-cmd --zone=public --permanent --add-service=https
firewall-cmd --reload
```

### 代码部分
#### 首先`Gemfile`中加入, 并执行`bundle update`
```
group :development do
  gem "capistrano", "~> 3.10", require: false
  gem "capistrano-rails", "~> 1.4", require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano3-puma',   require: false
end
```
#### 生成配置文件
```
bundle exec cap install
```
#### Capfile放开注释
```
require "capistrano/rvm"
require "capistrano/bundler"
require "capistrano/rails/assets"
require "capistrano/rails/migrations"

# 并加入
require 'capistrano/puma'
install_plugin Capistrano::Puma
```

#### `config/deploy.rb` 文件内容
```
lock "~> 3.11.0"
set :branch, 'master'
set :rails_env, :production
set :application, "wx_server"
set :repo_url, "git@github.com:iholen/wx_server.git"
set :stages, %w(dev staging production)
set :default_stage, "dev"
set :user, "deploy"
set :rvm_type, :user
set :rvm_ruby_version, '2.3.7'
set :puma_threads,    [4, 16]
set :puma_workers,    0
set :pty, true
set :use_sudo,        false
set :deploy_via,      :remote_cache
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, false
set :puma_env, :production

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  before :start, :make_dirs
end

namespace :deploy do
  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts "WARNING: HEAD is not the same as origin/master"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end

  before :starting,     :check_revision
  after  :finishing,    :compile_assets
  after  :finishing,    :cleanup
end
```

#### `config/deploy/dev.rb` 中内容
```
server server_ip, user: "deploy", roles: %w{app web}
```

#### `nginx`相关配置。 位置: `/etc/nginx/conf.d/wx_server.conf`, 需要重启`nginx`
```
upstream puma {
  server unix:///var/www/wx_server/shared/tmp/sockets/wx_server-puma.sock;
}

server {
  listen 80 default_server deferred;
  # server_name example.com;

  root /var/www/wx_server/current/public;
  access_log /var/www/wx_server/current/log/nginx.access.log;
  error_log /var/www/wx_server/current/log/nginx.error.log;

  location ^~ /assets/ {
    gzip_static on;
    expires max;
    add_header Cache-Control public;
  }

  try_files $uri/index.html $uri @puma;
  location @puma {
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header Host $http_host;
    proxy_redirect off;

    proxy_pass http://puma;
  }

  error_page 500 502 503 504 /500.html;
  client_max_body_size 10M;
  keepalive_timeout 10;
}
```


