## 闭包
闭包简单的理解就是"定义在一个函数内部的函数"。在本质上，闭包就是将函数内部和函数外部连接起来的一座桥梁。
```
var add = (function () {
  var counter = 0;
    return function() {return counter += 1}
})()

add() // 1
add() // 2
add() // 3
```