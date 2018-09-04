## Fiber基础

### 简介
Fiber是一种非抢占式的多线程模型，非抢占式就是当一个协程运行的时候，你不能在外部终止它，而只能等待这个协程主动（一般是`yield`）让出执行权给其他协程,通过协作来达到多任务并发的目的。协程的优点在于由于全部都是用户空间内的操作，因此它是非常轻量级的，占用的资源很小，并且context的切换效率也非常高效，在编程模型上能简化对阻塞操作或者异步调用的使用，使得涉及到此类操作的代码变的非常直观和优雅；缺点在于容错和健壮性上需要做更多工作，如果某个协程阻塞了，可能导致整个系统挂住，无法充分利用多核优势，有一定的学习使用曲线

### 创建
通过`Fiber#new`创建一个Fiber，Fiber#new接受一个`block`
```
# 栗子1
f = Fiber.new do |arg|
  a = Fiber.yield arg - 1
  p arg, a
  b = Fiber.yield arg
  p arg, b
end

f.resume(10)
=> 9
f.resume(100)
=> 10
=> 100
f.resume(1000)
=> 10
=> 1000
```

### 一些方法
Fiber其实是内置于语言，并不需要引入额外的库，fiber库对Fiber的功能做了增强
`require 'fiber'`

方法 | 描述
---- | ----
`Fiber#resume` | 启动Fiber，当一个Fiber终止后，如果你再次调用resume将抛出异常
`Fiber#current` | 返回当前协程
`Fiber#alive?` | 判断Fiber是否存活
`Fiber#transfer` | 方法做了resume/yield两个方法所做的事情

```
# transfer栗子
require 'fiber'

f1=Fiber.new do |other|
  print "hello"
  other.transfer
end

f2=Fiber.new do
  print " world\n"
end

f1.resume(f2)
```

### 参数传递
Fiber实例第一次调用`resume`时，传入的参数即`block`的参数，之后再调用`resume`，传递的参数将被作为`yield`的返回结果使用

参考栗子1：

* 第一次resume传递参数 10，所以 arg 值为 10
* 执行到 `Fiber.yield arg - 1` 返回了 `arg - 1` 的结果 9
* 第二次resume传递参数100，赋值给了变量 a, 所以输出了 10 和 100
* 同理推断出来 第三次调用resume的结果

### 注意
Ruby Fiber的调用不能跨线程，只能在同一个thread内进行切换