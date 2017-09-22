## Unicorn的安装和使用

### Unicorn安装

#### 1. 首先在Gemfile中添加Sidekiq Gem,执行`bundle`

```ruby
gem 'unicorn'
bundle
```
#### 2. 在`config/`新建`unicorn.rb`文件,并加入

```ruby
rails_root = File.expand_path(__FILE__).split('/')[0..-3].join('/')

worker_processes 4
working_directory rails_root

listen 3000, :tcp_nopush => true

timeout 180

pid "/var/tmp/unicorn.pid"

stderr_path "#{rails_root}/log/unicorn.log"
stdout_path "#{rails_root}/log/unicorn.log"

# unicorn的master会预先加载rails app环境，而且在copy_on_write_friendly的情况下，每个worker都是从master执行写时复制的（节省资源）。
# 如果是preload_app true的情况，需要在before_fork中关闭database connection;因为master不需要保持这个连接
# 但是，在after_fork后，需要为每个worker都重新连接上 database connection;
preload_app true 

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and
      ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and
      ActiveRecord::Base.establish_connection
end
```
#### 3. 在项目目录下执行,也可以指定端口启动，如:`-p 8080`

```ruby
unicorn_rails -c config/unicorn.rb #前台启动
unicorn_rails -c config/unicorn.rb -d #后台进程启动
```
#### 4. 启动完成之后浏览器访问
```ruby
localhost:3000
```
------
[更多...](https://bogomips.org/unicorn/)

作者 [@GLucien](https://github.com/GLucien)

2017 年 09月 22日
