# String, StringBuffer及StringBuilder的区别

### 可变性
`String`类中使用`final`关键字字符数组保存字符串, `String`对象是不可变的
`StringBuffer`和`StringBuffer`都继承自`AbstractStringBuilder`类, `AbstractStringBuilder`类也是使用字符数组保存字符串,但是没有使用`final`关键字,所以都是可变的

### 线程安全性
`String`中的对象是不可变的，可以理解为常量，线程安全。
`StringBuffer`类中对字符串操作的一些方法或调用的方法加了同步锁，线程安全。
`StringBuilder`类没有对方法加同步锁。不是线程安全

### 性能
每次对`String`类型进行改变的时候，都会生成一个新的`String`对象，然后将指针指向新的`String`对象。`StringBuffer`每次都会对`StringBuffer`对象本身进行操作，而不是生成新的对象并改变对象引用。相同情况下使用`StringBuilder`相比使用`StringBuffer`仅能获得 10%~15% 左右的性能提升，但却要冒多线程不安全的风险。

### 对于三者使用的总结
1. 操作少量的数据 = String
2. 单线程操作字符串缓冲区下操作大量数据 = StringBuilder
3. 多线程操作字符串缓冲区下操作大量数据 = StringBuffer