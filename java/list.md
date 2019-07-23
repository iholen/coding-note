### ArrayList
数组结构。线程不安全，效率高。查询快。增删慢。
JDK1.8版本扩容为1.5倍
```
int newCapacity = oldCapacity + (oldCapacity >> 1);
```
### LinkedList
双向链表。线程不安全，效率高。查询慢。增删快。
### Vector
数组结构。线程安全，效率慢。查询快。增删慢。
扩容为自定义或2倍
```
int newCapacity = oldCapacity + ((capacityIncrement > 0) ?
                                         capacityIncrement : oldCapacity);
```
### transient关键字
在对 对象做序列化或反序列化 时，被此关键字修饰的变量会被丢弃掉