# Class Loaders in Java
### Bootstrap Class Loader
主要负责加载`JDK`内部类，典型的有`rt.jar`以及其他位于`$JAVA_HOME/jre/lib`目录下的核心库。
除此之外，启动类加载器 是所有其他类加载器的父类，也是JVM核心的一部分。使用`native code`编写。
### Extension Class Loader
扩展类加载器是 启动类加载器的子类。负责加载Java标准核心类的扩展。默认加载目录`$JAVA_HOME/lib/ext`，可以指定`java.ext.dirs`系统属性进行修改加载路径
### System Class Loader
应用类加载器负责加载在classpath环境变量中文件，同时是扩展类加载器的子类