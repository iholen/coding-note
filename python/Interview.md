## Interview

* 假设有如下两个 list：a = ['a', 'b', 'c', 'd', 'e']，b = [1, 2, 3, 4, 5]，将 a 中的元素作为 key，b 中元素作为 value，将 a，b 合并为字典。
  
  ```
  dict(zip(a, b))
  ```

* alist=['apple', 'banana', 'apple', 'tomato', 'orange', 'apple', 'banana', 'watermeton'] 统计单词出现次数。
  
  ```
  alist.count('apple')
  ```

* 给列表中的字典排序：假设有如下 list 对象
alist=[{"name":"a", "age":20}, {"name":"b", "age":30}, {"name":"c", "age":25}]
将 alist 中的元素按照 age 从大到小排序。

```
def by_age(dc):
  return dc['age']

alist.sort(key=by_age, reverse=True)
```