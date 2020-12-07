## notes

### 2020.12.5

> 写一个判断 String 的工具类
>
> ==  equals 的区别  Integer.valueOf(2) 
>
> ArrayList 底层源码 数据结构 默认容量 扩容机制
>
> Synchronized 关键字
>
> Set 底层结构 
>
> list去重
>
> sql优化
>
> 多表查询
>
> 手写单例模式  懒汉 饿汉 double-check
>
> SpringBoot  Bean的生命周期
>
> 项目模块介绍  打卡模块 购物车模块 使用了那些技术点，提升了多少性能
>
> 语言表达 逻辑清晰



### 补充(重点)

> Spring框架 
>
> SpringMVC
>
> Mybatis
>
> SpringSecurity
>
> SpringBoot
>
> AOP
>
> IOC/DI
>
> 事务管理器
>
> 多线程
>
> 分布式
>
> SpringCloud
>
> nacos
>
> redis
>
> RabbitMQ/ RocketMQ /Kafka
>
> Storm 实时流处理， 大数据方向



### 反思

> 平常使用自己敲完，很少有独立思考的。
>
> 经常使用IDEA，导致很多方法记不住
>
> 英语属实有点差



### answer

#### String 判断空 工具类

```java
// 我写的是第一种方法，特别冗余，问题也多
public boolean judgeNull(String str) {
        if(str == null || "".equals(str)) {
            System.out.println("str is null ");
            return false;
        }
        char[] chars = str.toCharArray();
        if(chars.length > 0) {
            System.out.println("str is a String");
            return true;
        }
        return false;
    }

// 使用 com.google.common.base 提供的 Strings工具类
public boolean judgeNull1(String str) {
        if(Strings.isNullOrEmpty(str)) {
            System.out.println("str is nulls");
            return false;
        }
        return true;
    }

// 使用String 这个类Empty 方法，想要看见的应该是这个答案
public boolean judgeNull2(String str) {
        if(str == null || str.isEmpty()) {
            System.out.println("直接使用String底层源码，false");
            return false;
        }
        System.out.println("true，str is not null");
        return true;
    }
```



#### == 与 equals 的区别

> == 比较的地址值
>
> equals 如果重写了Object的equals 方法，比较的就是value(String 就重写了Object)

```java
Integer i1 = new Integer.ValueOf(5);
Integer i2 = new Integer.valueOf(5);
System.out.println(i1 == i2); // true
```



#### ArrayList 底层源码 初始容量 扩容机制

**ArrayList 底层的数据结构是 Object[] 数组 ,这个才可以指定存储任意类型的数据**



```java
 /**
     * Default initial capacity.
     */
private static final int DEFAULT_CAPACITY = 10;
private static final Object[] EMPTY_ELEMENTDATA = {};
private static final Object[] DEFAULTCAPACITY_EMPTY_ELEMENTDATA = {};
transient Object[] elementData;

private void grow(int minCapacity) {
        // overflow-conscious code
        int oldCapacity = elementData.length;
        int newCapacity = oldCapacity + (oldCapacity >> 1); // 向右边偏移1位 原来的1/2 新容量是原来的1.5倍
        if (newCapacity - minCapacity < 0)
            newCapacity = minCapacity;
        if (newCapacity - MAX_ARRAY_SIZE > 0)
            newCapacity = hugeCapacity(minCapacity);
        // minCapacity is usually close to size, so this is a win:
        elementData = Arrays.copyOf(elementData, newCapacity);
    }
```



