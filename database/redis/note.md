### redis
* redis 和 memcached 区别
    * redis支持更多的数据类型，memcached只支持简单的数据类string
    * redis支持持久化，可以将内存中的数据保存在磁盘上，重启的时候会再次加载到内存中，而memcached把数据都存在内存中。
    * redis有原生的集群模式
    * memcached是多线程，非阻塞IO复用的网络模型；redis使用单线程的多路IO复用模型。