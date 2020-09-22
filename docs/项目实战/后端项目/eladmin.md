

## eladmin

### 登录模块

#### 验证码逻辑

> 使用的是 gitee 上面提供的验证码 https://gitee.com/whvse/EasyCaptcha
>
> 1.首先，刷新页面，或者点击验证码图片(这个地方需要限流，同一个ip10s内，只能刷新10次，如果次数不正常就拉黑ip，防止恶意攻击)
>
> 2.然后后台AuthorizationController的getCode接收到获取验证码的请求，然后获取验证码生产类LoginProperties.getCaptcha，依据配置信息生产验证码，返回一个Captcha对象(这个对象是easy-captcha 这个jar包提供的，源码放在gitee上面)；
>
> 3.生成uuid，作为redis的key，Captcha的text 作为Redis的value
>
> 并设置过期时间
>
> 4.将验证码的信息的图片Captcha对象使用Base64加密后作为value，key= img放入map里面去，uuid也放入map里面
>
> 5.返回一个ResponseEntity对象(这个Spring Web jar包提供的)(以前都是自己定义的返回对象)



#### 登录逻辑

> 前端发一个Post请求，请求体中有username password code uuid rememberMe这五个属性， 第一次登录时，会进行认证授权操作
>
> 1、后端AuthorizationController 接收到请求，通过RsaUtils这个工具类，对加密后的密码进行解密
>
> 2、通过uuid 去redis 里面取验证码的信息，这个是页面刷新的时候存入redis的，如果登录界面刷新十次，redis会存10个验证码，过期时间设置为2分钟





#### 退出逻辑

> 点击退出按钮，前端发送退出请求，后端Controller接收请求
>
> 1.获取header里面的token信息，拼接登录时存入redis的token信息
>
> 2.调用redisUtils 删除key
>
> 







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





### 关于 重构的一些想法

