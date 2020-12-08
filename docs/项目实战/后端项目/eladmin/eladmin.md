

## eladmin

### 登录模块   AuthorizationController

#### 验证码逻辑

> 使用的是 gitee 上面提供的验证码 https://gitee.com/whvse/EasyCaptcha
>
> 1.首先，刷新页面，或者点击验证码图片(这个地方需要限流，同一个ip10s内，只能刷新10次，如果次数不正常就拉黑ip，防止恶意攻击)
>
> 2.然后后台AuthorizationController的getCode接收到获取验证码的请求，然后获取验证码生产类LoginProperties.getCaptcha，依据配置信息生产验证码，返回一个Captcha对象(这个对象是easy-captcha 这个jar包提供的，源码放在gitee上面)(SpringBoot项目启动的时候，Spring容器初始化，配置类以及里面的Bean都会被注入到容器里面如下图)(这个是一个常识，就是启动项目后，Config类)；
>
> 3.生成uuid，作为redis的key，Captcha的text 作为Redis的value(这个text 就是计算出来的结果)
>
> 并设置过期时间 为 2分钟
>
> 4.将验证码的信息的图片Captcha对象使用Base64加密后作为value，key= img放入map里面去，uuid也放入map里面，然后前端直接将加密后的数据填入<img src="Captcha.toBase64()"> ，显示验证码
>
> 5.返回一个ResponseEntity对象(这个Spring Web jar包提供的)(以前都是自己定义的返回对象)



![](D:\gitproject\github\SnailsNotes\docs\项目实战\后端项目\eladmin\eladminboot.PNG))



#### 验证码 存储 到redis 

> Spring 集成了 redis 模块 ，Spring-data-redis 提供缓存功能，



**这个里面有个坑，就是如果不配置序列化器,往redis里面存String类型的数据，会存成Sorted Set，而且key会乱码，往redis里面存取都需要先将String、Object 类型的数据序列化成 byte[] 类型的字节码，反序列化也是需要将字节码转换成String、Object**



##### 疑惑

1.[解决]LoginProperties、SecurityProperties这两个个类为什么在生成验证码的时候就存在了，是不是之前有设置拦截(使用AOP)

解疑：

> 在ConfigBeanConfiguration这个配置类里面初始化了LoginProperties、SecurityProperties这两个实体类，并且使用@ConfigurationProperties这个注解将application-dev.yml配置文件中 login jwt 的一些信息，引入到实体类里面去，然后又来了下一个疑问，这个ConfigBeanConfiguration配置类又是怎么触发的？
>
> [这个ConfigBeanConfiguration配置类又是怎么触发的？]
>
> 在项目启动的时候，就会初始化Spring容器，此时会把所有的用@Configuration  @Bean 修饰的类注入到Spring容器里面去。(基本特性全忘了)



#### 登录逻辑

> 前端发一个Post请求，请求体中有username password code uuid rememberMe这五个属性， 第一次登录时，会进行认证授权操作
>
> 1、后端AuthorizationController 接收到请求，通过RsaUtils这个工具类，对在前端加密的密码进行解密
>
> 2、通过uuid 去redis 里面取验证码的信息，这个是获取验证码(页面刷新)的时候存入redis的，如果登录界面刷新十次，redis会存10个验证码，过期时间设置为2分钟(这个设置也是在配置文件里面设置的)
>
> 3、验证验证码是否过期，或者前端传送过来的与redis中是否一致
>
> 4、将username和password 封装到UsernamePasswordAuthenticationToken 类里面
>
> 5、使用authenticationManagerBuilder 获取到 Authentication这个类
>
> 6、将authentication 放入 SecurityContextHolder
>
> 7、tokenProvider创建 token
>
> 8、authentication 获取 jwtUserDto
>
> 9、调用onlineUserService 将用户的信息save到redis
>
> 10、创建map封装返回值 properties 、jwtUserDto
>
> 11、踢掉之前已经登录的token



有一个有意思的现象，如果你每天在CSDN里面活跃，你可以连续一个月不用登录，这个是怎么实现的，如果你连续三天不活跃，就删除redis里面的token信息(Redis 必须弄集群)

**CSDN的登录信息是存在cookies里面的，每次登录获取浏览器的cookies，但是如果用户的cookies被黑客窃取了，那么可以模拟用户登录**



#### 退出逻辑

> 点击退出按钮，前端发送退出请求，后端Controller接收请求
>
> 1.获取header里面的token信息，拼接登录时存入redis的token信息
>
> 2.调用redisUtils 删除key
>
> 



### 在线用户模块  OnlineController

**这个模块的实现页面是系统监控模块下在线用户页面，在用户登录的逻辑中，会调用onlineUserService将jwtUserDto、token、request存入redis里面(过期时间为2小时)，在用户点退出登录或者在在线用户界面点击强退，都会删除redis里面的onlineUser的信息**





### 注解的处理

> 是对单个的Method使用 @Transactional注解 还是写一个配置类做统一的注解处理



### redis





### 自定义注解

```java
@Target(value = {ElementType.METHOD}) //该注解的位置应该在方法定义上方
@Retention(RententionPolicy.RUNTIME) //限定注解的生命周期，详解看注解的生命周期
@Documented
@Inherited
```

注解可以给属性设置默认值

```java
@Retention(RetentionPolicy.RUNTIME)
@Target(value = {ElementType.METHOD})
@Documented
public @interface CherryAnnotation {
    String name();
    int age() default 18;
    int[] score();
}
```

```java
@AnonymousAccess
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
@Documented
@RequestMapping(method = RequestMethod.GET)
public @interface AnonymousGetMapping {

    /**
     * Alias for {@link RequestMapping#name}.
     */
    @AliasFor(annotation = RequestMapping.class)
    String name() default "";

    /**
     * Alias for {@link RequestMapping#value}.
     */
    @AliasFor(annotation = RequestMapping.class)
    String[] value() default {};

    /**
     * Alias for {@link RequestMapping#path}.
     */
    @AliasFor(annotation = RequestMapping.class)
    String[] path() default {};

    /**
     * Alias for {@link RequestMapping#params}.
     */
    @AliasFor(annotation = RequestMapping.class)
    String[] params() default {};

    /**
     * Alias for {@link RequestMapping#headers}.
     */
    @AliasFor(annotation = RequestMapping.class)
    String[] headers() default {};

    /**
     * Alias for {@link RequestMapping#consumes}.
     *
     * @since 4.3.5
     */
    @AliasFor(annotation = RequestMapping.class)
    String[] consumes() default {};

    /**
     * Alias for {@link RequestMapping#produces}.
     */
    @AliasFor(annotation = RequestMapping.class)
    String[] produces() default {};

}
```



[CSDN自定义注解](https://blog.csdn.net/xsp_happyboy/article/details/80987484)

自定义注解步骤

1、自定义注解类 Annotation 类型的

2、处理注解的工具类

3、后面还需要一个注解处理器类  利用反射解析注解



#### 注解的生命周期

> 1.Java源文件阶段
>
> 2.编译到class文件阶段
>
> 3.运行期阶段

1.如果一个注解RetentionPolicy.SOURCE ，则它将被限定在Java源文件中，那么这个注解不会参加编译，也不会再运行期起任何作用，只能被阅读Java文件的人看见，eg:@Override

2.如果一个注解被定义为RetentionPolicy.CLASS，则它将被编译到Class文件中，那么编译器可以在编译时根据注解做一些处理动作，但是运行时JVM（Java虚拟机）会忽略它，我们在运行期也不能读取到

3.如果一个注解被定义为RetentionPolicy.RUNTIME，那么这个注解可以在运行期的加载阶段被加载到Class对象中。那么在程序运行阶段，我们可以通过反射得到这个注解，并通过判断是否有这个注解或这个注解中属性的值，从而执行不同的程序代码段。**我们实际开发中的自定义注解几乎都是使用的RetentionPolicy.RUNTIME**

4.在默认的情况下，自定义注解是使用的RetentionPolicy.CLASS



### 实体类

#### Entity

> 基本上属性跟数据库字段一样



#### bo  Business object

> 业务对象，bo就是把业务逻辑封装成一个对象，这个bo对象里的属性，可能会设计到多个Entity



#### VO   View Object

> 前端界面需要的对象



#### PO  persistent object

> 持久层对象 数据库表在java对象中的显示，最形象的理解就是一个 po对应 一条数据表的一行



#### DTO

> 代表数据传输对象，用来封装对数据的访问，注意是数据的访问，不是数据库的访问。





#### DAO

> 数据访问对象











### 关于 重构的一些想法



