### SpringBoot启动失败

#### 异常信息

```java
Description:

Parameter 1 of constructor in com.xubo.modules.system.service.impl.DataServiceImpl required a bean of type 'com.xubo.modules.system.service.DeptService' that could not be found.


Action:

Consider defining a bean of type 'com.xubo.modules.system.service.DeptService' in your configuration.
```



**大致意思是DataServiceImpl 类这个需要DeptService这个bean**

我去查找的时候发现，DeptService 这个接口写了，但是实现类没有写(因为我们是将他的实现类注入到容器里面 使用@Service)



### NullPointException 空指针异常

**写代码的时候少写了@Resource(@Autowired) 导致没有将bean注入进来**



### 将验证码存入redis里面

**key为uuid，value为captchaValue，过期时间为两分钟**

##### 问题

> 使用的是RedisUtils 工具类 ，里面封装了RedisTemplate(构造器注入，RedisUtils构造方法里面将RedisTemplate当参数传入构造方法里面)，调用下面的方法(set())，应该是String类型，但是存储到redis里面是Sorted set类型，



##### 问题2 (这个问题很经典，面试可以拿来当经典Bug讲，从排查bug，到设计解决思路，总结避免类似问题)

> 往redis里面存储String类型的数据时，key前面会加上"\xac\xed\x00\x05t\x00)",并且存成Sorted set类型
>
> [思路分析](https://blog.csdn.net/wwrzyy/article/details/85089463)

```java
public boolean set(String key, Object value, long time, TimeUnit timeUnit) 
```

