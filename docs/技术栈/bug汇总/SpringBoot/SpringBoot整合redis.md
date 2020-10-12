### spring boot 集成使用spring data时key出现 \xac\xed\x00\x05t\x00)

#### 背景

**最近在研究redis，在跑eladmin这个项目的时候，发现存储验证码的时候，把uuid当做key，captcha的text为value，存储成String类型的数据**



#### Bug(异常)

**操作成功后去redis控制台 输入 keys * 的时候，发现一个奇怪的现象，发现key前面多了一串\xac\xed\x00\x05t\x00**

![redis key存储异常](D:\gitproject\github\SnailsNotes\docs\技术栈\bug汇总\SpringBoot\redis_String_serializa.PNG)



#### 排查问题

**我这里使用的是Spring Data 集成的redis，Spring操作redis是基于Jedis客户端的，而Jedis客户端与redis交互的时候协议中定义是用byte类型交互，jedis中提供了String类型转换成byte[]类型，但是在Spring data中存储String类型的时候K V 是泛型，所以有了RedisTemplate里面的代码，在没有特殊定义的情况下，Spring默认采用defaultSerializer对key、value序列化，接下来查看JdkSerializationRedisSerializer的代码发现(见下)**



**分析 SpringData 中的 RedisTemplate 代码，发现**

```java
this.defaultSerializer = new JdkSerializationRedisSerializer(this.classLoader != null ? this.classLoader : this.getClass().getClassLoader());
```



**JdkSerializationRedisSerializer源码**

```java
private Converter<Object, byte[]> serializer = new SerializingConverter();
public byte[] serialize(Object object) {
	if (object == null) {
		return SerializationUtils.EMPTY_ARRAY;
	}
	try {
		return serializer.convert(object);
	} catch (Exception ex) {
		throw new SerializationException("Cannot serialize", ex);
	}
}
```



**序列化支持的是Object对象，调用了SerializingConverter类下的convert方法转换对象，转换对象的方法是：**

```java
private final Serializer<Object> serializer;
/**
* Serializes the source object and returns the byte array result.
*/
public byte[] convert(Object source) {
	ByteArrayOutputStream byteStream = new ByteArrayOutputStream(128);
	try  {
		this.serializer.serialize(source, byteStream);
		return byteStream.toByteArray();
	}
	catch (Throwable ex) {
		throw new SerializationFailedException("Failed to serialize object using " +
	}
}
```



原因其实就出现在这里，解决的办法就是手动定义序列化的方法，spring-data-redis中还提供了一个序列化的类专门针对string类型的序列化org.springframework.data.redis.serializer.StringRedisSerializer这个类,我们在带有@Configuration注解的类中覆盖自动配置的RedisTemplate<Object,Object>，如下：

```java
@Bean
    public RedisTemplate<Object,Object> redisTemplate(RedisConnectionFactory redisConnectionFactory){
        RedisTemplate<Object,Object> redisTemplate = new RedisTemplate<>();
        // 设置redis连接
        redisTemplate.setConnectionFactory(redisConnectionFactory);
        // 使用Jackson2JsonRedisSerialize 替换默认序列化
        Jackson2JsonRedisSerializer jackson2JsonRedisSerializer = new Jackson2JsonRedisSerializer(Object.class);
        ObjectMapper objectMapper = new ObjectMapper();
        objectMapper.setVisibility(PropertyAccessor.ALL, JsonAutoDetect.Visibility.ANY);
        objectMapper.enableDefaultTyping(ObjectMapper.DefaultTyping.NON_FINAL);
        jackson2JsonRedisSerializer.setObjectMapper(objectMapper);

        // 设置value的序列化规则和 key的序列化规则
        redisTemplate.setHashValueSerializer(jackson2JsonRedisSerializer);
        redisTemplate.setValueSerializer(jackson2JsonRedisSerializer);
        // 将redisTemplate的序列化方式更改为StringRedisSerializer
        redisTemplate.setHashKeySerializer(new StringRedisSerializer());
        redisTemplate.setKeySerializer(new StringRedisSerializer());
        redisTemplate.afterPropertiesSet();
        return redisTemplate;
    }
```



**如果是Spring mvc项目则可以在xml中指定：**

```java
	<bean id="redisTemplate" class="org.springframework.data.redis.core.RedisTemplate"
		p:connection-factory-ref="jedisConnectionFactory">
		<property name="keySerializer">
			<bean class="org.springframework.data.redis.serializer.StringRedisSerializer" />
		</property>
		<property name="valueSerializer">
			<bean class="org.springframework.data.redis.serializer.StringRedisSerializer" />
		</property>
		<property name="hashKeySerializer">
			<bean class="org.springframework.data.redis.serializer.StringRedisSerializer" />
		</property>
		<property name="hashValueSerializer">
			<bean class="org.springframework.data.redis.serializer.StringRedisSerializer" />
		</property>
	</bean>
```



原文参考：

> https://blog.csdn.net/yunhaibin/article/details/9001198
> 其实redis在使用中，必须要提前考虑的就是内存的占用问题（博客中另外一篇文章很经典，阐述了一个外国人做的测试，同样的存储可以节约几十G的内存：
> https://blog.csdn.net/yunhaibin/article/details/8999429
> 在设计的时候使用hash可以节约很多的内存，而存储的时候如果每条数据就放一堆\xac\xed\x00\x05t\x00\tb这个东西，肯定是无法直视的。
>
> https://blog.csdn.net/wwrzyy/article/details/85089463
>
> spring boot集成使用spring data时key值出现\xac\xed\x00\x05t\x00\tb