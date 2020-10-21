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

#### 自定义一个RedisConfig

> 自定义一个RedisConfig 配置类
>
> 重写序列化器 StringRedisSerializer/FastJsonRedisSerializer  implements  RedisSerializer<T> 接口
>
> 

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

**排查Bug**



##### 问题2 解决方案

> 重新看了一下eladmin的整个模块，发现在eladmin-common 里面有配置StringRedisSerializer 重写了redis String类型的序列化器



### Object  byte[]  互转

Object 转 byte[]

> 使用阿里巴巴的 FastJson Stringstring =   JSON.toJSONString(Object) 
>
>然后将'\' 换成 ''
>
>最后 byte[] bytes =   string.getBytes("UTF-8");



byte[] 转成 Object

> (bytes == null) ? null : new String(bytes,StandardCharsets.UTF-8)



### SpringSecurity 登录失败

**异常信息**

> 前端异常：(后端逻辑还没跑完，前端就弹出来了)当前登录信息已过期，请重新登录
>
> 后端异常 ： debug 到  onlineService.save  这个地方 catch 到 InvocationTargetException

