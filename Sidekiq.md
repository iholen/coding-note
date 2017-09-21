## Sidekiq的安装和使用
异步组件在使用的时候需要启动Sidekiq进程，这个进程就负责处理真正的异步任务。
可以理解为web进程是异步任务的生产者，而Sidekiq异步任务组件是消费者，用来真
正执行这些异步任务的。所以两者之间需要一个通信机制，让两者可以共享和读取异
步任务被创建的地方。目前Sidekiq默认支持Redis，所以还需要启动[redis](http://www.redis.net.cn/tutorial/3501.html)的进程。
### Sidekiq安装

#### 1. 首先在Gemfile中添加Sidekiq Gem,执行`bundle`

```ruby
gem 'sidekiq'
bundle
```
#### 2. 打开`config/application.rb`加入配置项,将项目的异步组件修改为`sidekiq`

```ruby
config.active_job.queue_adapter = :sidekiq
```
#### 3. 使用rails生成器生成Job

```ruby
rails g job user_notification
```
#### 4. 在`config/`目录下添加配置文件`sidekiq.yml`,内容如下
```ruby
:concurrentcy: 5   #指定并发进程数
:pidfile: tmp/pids/sidekiq.pid
development:
    :concurrentcy: 2
production:
    :concurrentcy: 5
:queues:
    - default
    - [mailers,2] #设定mailers的消息队列以及优先级
:logfile: log/sidekiq.log
```
#### 5. 启动Sidekiq进程

```ruby
sidekiq -C config/sidekiq.yml -e development -d
```
#### 6. 向`config/routes.rb`添加Sidekiq路由可在前端查看Job执行情况
```ruby
require 'sidekiq/web'
mount Sidekiq::Web => '/sidekiq'
```
#### 7. 打开`rails c`进行调试
```ruby
user = User.find 4
UserNotificationJob.set(wait: 5.minutes).perform_later(user)
```
------
[更多...](https://github.com/mperham/sidekiq/wiki)

作者 [@GLucien](https://github.com/GLucien)

2017 年 09月 21日
