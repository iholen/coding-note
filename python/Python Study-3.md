## list & tuple
### list

```python
 classmates = ['Michael', 'Bob', 'Tracy']
 
 len(classmates)
 
 # 追加元素
 classmates.append('xiaoming')
 
 # 向指定索引位置插入元素
 classmates.insert(1, 'xiaoming')
 
 # 删除结尾元素
 classmates.pop()
 
 # 删除指定索引位置元素
 classmates.pop(1)
 
 # list相加
 new_classmates = ['xiaohong', 'xiaolong']
 all_ classmates = classmates + new_classmates
 
 # list去重
 a = [1, 2, 2, 4, 1, 2, 3, 4, 2]
 b = list(set(a))
 #>>> [1, 2, 3, 4]
 b.sort(key=a.index)
 #>>> [1, 2, 4, 3]
```

### tuple

```python
# 空元祖
a = ()

# 只有1个元素的tuple
a = (1,)
```

tuple所谓的“不变”是说，tuple的每个元素，指向永远不变。

## 条件判断
```python
if <条件判断1>:
    <执行1>
elif <条件判断2>:
    <执行2>
elif <条件判断3>:
    <执行3>
else:
    <执行4>
```