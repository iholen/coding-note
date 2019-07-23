# 函数式接口（Functional Interface）
所谓的函数式接口，当然首先是一个接口，然后就是在这个接口里面 **只能有一个抽象方法**。<br>
这种类型的接口也称为`SAM`接口，即`Single Abstract Method interfaces`。
# 函数式接口用途
主要用在`Lambda`表达式和方法引用。<br>
可以使用`Lambda`表达式来表示该接口的一个实现。<br>
示例:
```java
@FunctionalInterface
interface GreetingService
{
    void sayMessage(String message);
}

GreetingService greetService1 = message -> System.out.println("Hello " + message);
```
# `@FunctionalInterface`注解
Java 8为函数式接口引入了一个新注解`@FunctionalInterface`，主要用于编译级错误检查，加上该注解，当你写的接口不符合函数式接口定义的时候，编译器会报错

# JDK中的函数式接口举例
1. java.lang.Runnable
2. java.awt.event.ActionListener 
3. java.util.Comparator
4. java.util.concurrent.Callable
5. java.util.function包下的接口，如Consumer、Predicate、Supplier等
### 注：
1. 函数式接口允许定义默认方法
2. 函数式接口允许定义静态方法
3. 函数式接口允许定义java.lang.Object里的public方法