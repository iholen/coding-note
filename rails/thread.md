## 线程

### 线程基础
* 线程创建： `Thread.new/Thread.start/Thread.fork`, 需要传入一个`block`
* 线程创建完会立即执行
* `Thread.Join` 会挂起主线程，直到当前线程执行完毕, 参考下面两个程序栗子执行的结果:
```
# program 1, 主线程和子线程并行执行
Thread.new do
  puts 'begin...'
  t1 = Time.now
  t2 = nil
  thr = Thread.new do
    sleep 1
    puts 'sub thread'
    t2 = Time.now
  end
  sleep 2
  t3 = Time.now
  puts 'main thread exec: ', t2 - t1
  puts 'sub thread exec: ', t3 - t1
  puts 'end...'
end
#=> begin...
sub thread
main thread exec:
1.005393
sub thread exec:
2.003835
end...

# program 2
Thread.new do
  puts 'begin...'
  t1 = Time.now
  t2 = nil
  thr = Thread.new do
    sleep 1
    puts 'sub thread'
    t2 = Time.now
  end
  thr.join
  sleep 2
  t3 = Time.now
  puts 'main thread exec: ', t2 - t1
  puts 'sub thread exec: ', t3 - t1
  puts 'end...'
end
#=> begin...
sub thread
main thread exec:
1.001232
sub thread exec:
3.004312
end...
```

***

### 线程同步
三种实现同步的方式：Mutex、Queue类、ConditionVariable

#### Mutex
通过栗子来学习一下：

栗一：
```
def news_report(str)
  puts str
  sleep 0.5
end

threads = []
threads << Thread.new do
  5.times do
    news_report('鬼子进村了。。。')
    sleep 0.05
  end
end

threads << Thread.new do
  5.times do
    news_report('红军打死了鬼子')
    sleep 0.05
  end
end

threads << Thread.new do
  5.times do
    news_report('取得了胜利✌️')
    sleep 0.05
  end
end
threads.each(&:join)
```

栗二：
```
@mutex = Mutex.new

def news_report(name)
  @mutex.lock
  puts name
  @mutex.unlock 
end

threads = []
threads << Thread.new do
  5.times do
    news_report('鬼子进村了。。。')
    sleep 0.05
  end
end

threads << Thread.new do
  5.times do
    news_report('红军打死了鬼子')
    sleep 0.05
  end
end

threads << Thread.new do
  5.times do
    news_report('取得了胜利✌️')
    sleep 0.05
  end
end

threads.each(&:join)
```

通过比较两者在`irb`中运行的结果得知：

* 栗一中会同时输出“鬼子进村了。。。”、“红军打死了鬼子”、“取得了胜利✌️”
* 栗二中则只会是其中一个线程调用`news_report`方法

> 注： `synchronize` 和 `try_lock` 也可锁定变量
>> * `synchronize` 接受一个block
>> * `try_lock` 用于条件判断

#### Queue类

#### ConditionVariable
