##dup & clone

### 相同点
都是浅拷贝
### 不同点
clone做了两件dup没有做的事

* 克隆了对象的单例方法

dup:

```
a = Object.new
def a.foo; :foo end
p a.foo
# => :foo
b = a.dup
p b.foo
# => undefined method `foo' for #<Object:0x007f8bc395ff00> (NoMethodError)
```

clone:

```
a = Object.new
def a.foo; :foo end
p a.foo
# => :foo
b = a.clone
p b.foo
# => :foo
```

* 维持了对象的freeze状态

```
a = Object.new
a.freeze
p a.frozen?
# => true
b = a.dup
p b.frozen?
# => false
c = a.clone
p c.frozen?
# => true
```

----------
作者 [@iholen](https://github.com/iholen)

2018 年 08月 31日