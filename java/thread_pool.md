# Java并发-线程池
### 优点
1. 线程复用省去了创建和销毁的消耗
2. 通过调节线程池的大小可以达到资源的充分利用

### Executor
Java中，任务执行的主要抽象不是`Thread`, 而是`Executor`, `Exxcutor`基于生产者-消费者
模式，提交任务的操作相当于生产者，执行任务的线程相当于消费者

### Executors
**Executors**是一个**Executor**工厂，有很多定义好的工厂方法。主要的工厂方法如下:
> 1. newFixedThreadPool(指定大小的线程池)
> 2. newCachedThreadPool(可缓存的线程池)
> 3. newSingleThreadPool(只有一个线程的线程池)
> 4. newScheduledThreadPool(延时或定期执行的线程池)

### 线程池构造参数
```
public ThreadPoolExecutor(int corePoolSize,
                              int maximumPoolSize,
                              long keepAliveTime,
                              TimeUnit unit,
                              BlockingQueue<Runnable> workQueue,
                              ThreadFactory threadFactory,
                              RejectedExecutionHandler handler)
```
1. `corePoolSize`: 核心线程数，新任务加入时，如果当前线程数小于此值，则会创建新的线程来执行
任务
2. `maximumPoolSize`: 最大线程数，线程池最多拥有的线程数
3. `keepAliveTime`: 空闲线程存活时间
4. `unit`: 空闲线程存活时间的单位
5. `workQueue`: 存放待执行任务的阻塞队列，当前线程数 >= 最大线程数
6. `threadFactory`: 创建新线程的工厂
7. `handler`: 拒绝策略，默认抛出异常

### 拒绝策略
1. ThreadPoolExecutor.AbortPolicy: 丢弃任务并抛出RejectedExecutionException异常
```
public void rejectedExecution(Runnable r, ThreadPoolExecutor e) {
            throw new RejectedExecutionException("Task " + r.toString() +
                                                 " rejected from " +
                                                 e.toString());
        }
```
2. ThreadPoolExecutor.DiscardPolicy: 也是丢弃任务，do nothing
```
public void rejectedExecution(Runnable r, ThreadPoolExecutor e) {
        }
```
3. ThreadPoolExecutor.DiscardOldestPolicy: 丢弃队列最前面的任务，然后重新尝试执行任务（重复此过程）
```
public void rejectedExecution(Runnable r, ThreadPoolExecutor e) {
            if (!e.isShutdown()) {
                e.getQueue().poll();
                e.execute(r);
            }
        }
```
4. ThreadPoolExecutor.CallerRunsPolicy: 直接调用线程的`run`方法
```
public void rejectedExecution(Runnable r, ThreadPoolExecutor e) {
            if (!e.isShutdown()) {
                r.run();
            }
        }
```

### 关闭线程池
1. 为什么需要关闭？
    1. 如果线程池中里的线程一直存活，而且这些线程又不是守护线程，那么会导致虚拟机无法正常退出
    2. 如果粗暴的结束，线程池中的任务可能还没执行完，业务将处于未知状态
    3. 线程中有些该释放的资源没有释放
2. 如何关闭？
    1. `shutdown`: 停止“接客”，继续提交会执行拒绝策略。会等已提交的执行完关闭线程池
    2. `shutdownNow`: 立即停止，并尝试终止正在执行的线程(通过中断)，并返回没执行的任务集合
    3. `awaitTermination`: 阻塞当前线程，直到全部任务执行完，或等待超时，或被中断。不会关闭线程池

    所以 一般是先通过`shutdown`关闭线程池，然后调用`awaitTermination`等待正在执行的线程完事

注：[参考文章](https://mp.weixin.qq.com/s/PnbIXJ6EclQSPCzWmLfD1A)
