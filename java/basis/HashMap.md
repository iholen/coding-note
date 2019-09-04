# HashMap Source Code(Java8)
解读HashMap源码

## 常量
```
/**
 * aka(also known as)
 * 初始化容量 16
 * 必须是 2 的幂(%运算效率过低，故采用位运算，为了保证在位运算的情况下均匀分布)
 */
static final int DEFAULT_INITIAL_CAPACITY = 1 << 4; // aka 16
// 最大容量(当其任何一个带容量大小参数的构造函数指定了更大的值时，会使用到) 
static final int MAXIMUM_CAPACITY = 1 << 30;
// 默认的加载因子
static final float DEFAULT_LOAD_FACTOR = 0.75f;
// 树化阈值(当桶中元素的数量超过该值且桶数大于等于64时。链表转为红黑树)
static final int TREEIFY_THRESHOLD = 8;
// 非树化阈值
static final int UNTREEIFY_THRESHOLD = 6;
// 树化的最小容量
static final int MIN_TREEIFY_CAPACITY = 64;
```  