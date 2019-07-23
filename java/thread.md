# Java锁机制
* synchronized锁
* Lock显式锁
## synchronized
关键字synchronized取得的锁都是对象锁。
```
# 方法锁(静态和非静态)
# 1. 静态方法锁(锁的是当前class)
static synchronized void a() {}
# 2. 非静态方法锁(锁的是当前对象)
synchronized void a() {}
# 对象锁(synchronized块实现方式)
synchronized (object) {}
# 类锁(synchronized块实现方式)
synchronized (A.class) {}
```
#### 锁重入
在一个synchronized方法/块的内部调用当前锁对象的其他synchronized方法/块时，是永远可以得到锁的
#### volatile
* 作用: 解决变量在多个线程间可见，强制性从公共堆栈中进行取变量值。
* 优点: 多线程访问时不会发生阻塞，能保证数据的可见性
* 缺点: 不支持原子性，且只能修饰变量
* 注：可以使用一些原子类(AtomicInteger等)进行 i++ 操作

## Lock显式锁
#### ReentrantLock 使用
* 基本使用
```
Lock lock = new ReentrantLock();
// 获取锁
lock.lock();
...
// 释放锁
lock.unlock();
```
* Condition实现部分通知
```
Lock lock = new ReentrantLock();
Condition conditionA = lock.newCondition();
Condition conditionB = lock.newCondition();

lock.lock();
conditionA.await(); // 线程等待
conditionA.notify(); // 通知某个conditionA的线程
lock.unlock();

lock.lock();
conditionB.await(); // 线程等待
conditionB.notify(); // 通知某个conditionB的线程
lock.unlock();
```
* 公平锁和非公平锁
公平锁表示线程获取锁的顺序是按照线程加锁的顺序来分配的，即先来先得的FIFO先进先出的顺序。
非公平锁是随机获得锁的
```
// 创建公平锁
Lock fairLock = new ReentrantLock(true);
// 创建非公平锁
Lock unFairLock = new ReentrantLock(false);
```
#### ReentrantReadWriteLock 使用
读写锁表示有两个锁，一个是读操作相关的锁，也称为共享锁；另一个是写操作相关的锁，也叫排他锁。
读读不互斥，读写、写读、写写互斥
```
ReentrantReadWriteLock lock = new ReentrantReadWriteLock();
lock.readLock().lock(); // 获取读锁
lock.writeLock().lock(); // 获取写锁
```

# 线程间通信
### wait / notify
wait释放锁，notify不释放锁
### 通过管道进行线程间通信
* 字节流
```
  PipedInputStream inputStream = new PipedInputStream();
  PipedOutputStream outputStream = new PipedOutputStream();
  inputStream.connect(outputStream);
  outputStream.write("a".getBytes());

  byte[] byteArray = new byte[20];
  int readLength = inputStream.read(byteArray);
  if (readLength != -1) {
    String content = new String(byteArray, 0, readLength);
  }
```
* 字符流
```
  PipedReader inputStream = new PipedReader();
  PipedWriter outputStream = new PipedWriter();
  inputStream.connect(outputStream);
  outputStream.write("a");

  char[] charArray = new char[20];
  int readLength = inputStream.read(charArray);
  if (readLength != -1) {
    String content = new String(charArray, 0, readLength);
  }
```
  
### join
方法join后面的代码提前运行
### join 与 synchronized 区别
都具有使线程同步运行的效果。join在内部使用wait方法进行等待，synchronized 使用的是“对象监视器”原理
### join(long) and sleep(long)
由于join(long)内部使用wait(long)实现，所以方法具有释放锁的特点
sleep(long)却不释放锁
### ThreadLocal使用
* 主要解决的是每个线程绑定自己的值，可以将其比喻成全局存放数据的盒子，盒子可以存储每个线程的私有数据。
* 使用类InheritableThreadLocal可以在子线程中取得父线程继承下来的值。
* 可以继承 ThreadLocal 或 InheritableThreadLocal，重写initialValue方法 给get设置默认值。
* 继承 InheritableThreadLocal，重写childValue方法，可修改从主线程继承下来的值。需要注意的是：如果子线程在取值的同时，主线程又将值修改了，那么子线程取得的值还是旧值。

# 单例模式与多线程
### 立即加载/"饿汉模式"
```
class MyObject {
  private MyObject myObject = new MyObject();

  private MyObject() {}

  public static MyObject getInstance() {
    return myObject;
  }
}
```
### 延迟加载/"懒汉模式", 需使用DCL(Double-Check Locking)
```
class MyObject {
  private MyObject myObject;

  private MyObject() {}

  public static MyObject getInstance() {
    if (myObject == null) {
        synchronized(this) {
          if (myObject == null) {
            myObject = new MyObject();
          }
        }
    }
    return myObject;
  }
}
```
### 使用静态内置类
```
class MyObject {
  private MyObject() {}

  private static class MyObjectHandler {
    private static MyObject myObject = new MyObject();
  }

  public static MyObject getInstance() {
    return MyObjectHandler.myObject;
  }
}
```
### 序列化与反序列化的单例模式
静态内置类可以达到线程安全问题，但是如果遇到序列化对象时，使用默认的方式运行得到的结果还是多例的。解决办法就是在反序列化中使用readResolve()方法。
### 使用static代码块
静态代码块在使用类的时候就已经执行了，所以可以应用这个特性来实现单例设计模式
```
class MyObject {
  private static MyObject myObject;
  private MyObject() {}

  static {
    myObject = new MyObject();
  }

  public static MyObject getInstance() {
    return myObject;
  }
}
```
### 使用 enum 枚举数据类型
枚举 和 静态代码块的特性类似，在使用枚举类型时，构造方式会被自动调用
```
class MyObject {
    private MyObject() {}

    private enum MyEnum {
        mySingletonObject;

        private MyObject myObject;
        MyEnum() {
            myObject = new MyObject();
        }
    }

    public static MyObject getInstance() {
        return MyEnum.mySingletonObject.myObject;
    }

}
```