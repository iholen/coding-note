## 柯里化
1. 实现一个add方法
```
add(1)(2)(3)(4) => fn 10
add(1, 2)(3)(4) => fn 10
add(1, 2, 3)(4) => fn 10
add(1, 2, 3, 4) => fn 10
```

```
function add(){
  var _args = [].slice.call(arguments)
  
  var adder = function() {
    _adder = function() {
      _args.push(...arguments)

      return _adder
    }

    _adder.toString = function(){
      return _args.reduce(function(a, b){
        return a + b
      })
    }

    return _adder
  }

  return adder()
}
```
