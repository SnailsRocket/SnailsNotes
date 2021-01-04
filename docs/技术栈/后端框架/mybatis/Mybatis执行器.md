## Mybatis 之执行器

### 执行器是什么

在企业开发中，对数据库的批量操作，是一个非常常见的操作，Mybatis提供了批量执行器，来支持批量操作。



两大类执行器

BaseExecutor (非缓存执行器) defaultExecutorType=SIMPLE

> SimpleExecutor (default)
>
> BatchExecutor
>
> ReuseExecutor



### SimpleExecutor

**默认的执行器, 对每条sql进行预编译->设置参数->执行等操作**

> Mybatis 默认使用这个执行器，每执行一条插入语句都会执行编译、设置参数、执行sql操作
>
> 

```java
[2019-06-13 11:30:38:812][main][DEBUG][o.z.l.m.l.mapper.StudentMapper.save]- ==>  Preparing: insert into t_student values (null , ?, ?, ?, ?) 
[2019-06-13 11:30:38:819][main][DEBUG][o.z.l.m.l.mapper.StudentMapper.save]- ==> Parameters: zhangsan_0(String), 20(Integer), M(String), 2019-06-13(Date)
[2019-06-13 11:30:38:824][main][DEBUG][o.z.l.m.l.mapper.StudentMapper.save]- <==    Updates: 1

[2019-06-13 11:30:38:827][main][DEBUG][o.z.l.m.l.mapper.StudentMapper.save]- ==>  Preparing: insert into t_student values (null , ?, ?, ?, ?) 
[2019-06-13 11:30:38:828][main][DEBUG][o.z.l.m.l.mapper.StudentMapper.save]- ==> Parameters: zhangsan_1(String), 21(Integer), M(String), 2019-06-13(Date)
[2019-06-13 11:30:38:832][main][DEBUG][o.z.l.m.l.mapper.StudentMapper.save]- <==    Updates: 1

[2019-06-13 11:30:38:833][main][DEBUG][o.z.l.m.l.mapper.StudentMapper.save]- ==>  Preparing: insert into t_student values (null , ?, ?, ?, ?) 
[2019-06-13 11:30:38:839][main][DEBUG][o.z.l.m.l.mapper.StudentMapper.save]- ==> Parameters: zhangsan_2(String), 22(Integer), M(String), 2019-06-13(Date)
[2019-06-13 11:30:38:841][main][DEBUG][o.z.l.m.l.mapper.StudentMapper.save]- <==    Updates: 1
...
耗时:21575 ms!
```





### BatchExecutor

**批量执行器, 对相同sql进行一次预编译, 然后设置参数, 最后统一执行操作**

> 从执行日志可以看出, 只对第一次插入操作执行了sql编译操作, 对其它插入操作仅执行了设置参数操作, 最后统一执行.

```java
[2019-06-13 11:31:29:270][main][DEBUG][o.z.l.m.l.mapper.StudentMapper.save]- ==>  Preparing: insert into t_student values (null , ?, ?, ?, ?) 
[2019-06-13 11:31:29:276][main][DEBUG][o.z.l.m.l.mapper.StudentMapper.save]- ==> Parameters: zhangsan_0(String), 20(Integer), M(String), 2019-06-13(Date)
[2019-06-13 11:31:29:277][main][DEBUG][o.z.l.m.l.mapper.StudentMapper.save]- ==> Parameters: zhangsan_1(String), 21(Integer), M(String), 2019-06-13(Date)
[2019-06-13 11:31:29:277][main][DEBUG][o.z.l.m.l.mapper.StudentMapper.save]- ==> Parameters: zhangsan_2(String), 22(Integer), M(String), 2019-06-13(Date)
...
耗时:835 ms!
```





### ReuseExecutor

**REUSE 执行器会重用预处理语句（prepared statements)**

> 从执行日志可以看出, 只有第一次插入操作, 执行了sql编译步骤, 对其它插入操作执行了设置参数, 执行sql的操作.

```java
[2019-06-13 11:31:11:752][main][DEBUG][o.z.l.m.l.mapper.StudentMapper.save]- ==>  Preparing: insert into t_student values (null , ?, ?, ?, ?) 

[2019-06-13 11:31:11:757][main][DEBUG][o.z.l.m.l.mapper.StudentMapper.save]- ==> Parameters: zhangsan_0(String), 20(Integer), M(String), 2019-06-13(Date)
[2019-06-13 11:31:11:759][main][DEBUG][o.z.l.m.l.mapper.StudentMapper.save]- <==    Updates: 1

[2019-06-13 11:31:11:761][main][DEBUG][o.z.l.m.l.mapper.StudentMapper.save]- ==> Parameters: zhangsan_1(String), 21(Integer), M(String), 2019-06-13(Date)
[2019-06-13 11:31:11:764][main][DEBUG][o.z.l.m.l.mapper.StudentMapper.save]- <==    Updates: 1

[2019-06-13 11:31:11:776][main][DEBUG][o.z.l.m.l.mapper.StudentMapper.save]- ==> Parameters: zhangsan_2(String), 22(Integer), M(String), 2019-06-13(Date)
[2019-06-13 11:31:11:778][main][DEBUG][o.z.l.m.l.mapper.StudentMapper.save]- <==    Updates: 1
...
耗时:19322 ms!
```





CachingExecutor (缓存执行器) cacheEnabled=true

> 



参考 ： https://blog.csdn.net/zongf0504/article/details/100104029

https://blog.csdn.net/wagcy/article/details/32963235?utm_medium=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-1.control&depth_1-utm_source=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-1.control

https://blog.csdn.net/qingtian211/article/details/81838042

https://www.cnblogs.com/jxxblogs/p/12150432.html

















