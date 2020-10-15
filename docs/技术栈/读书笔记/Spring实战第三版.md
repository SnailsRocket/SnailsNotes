# Spring实战

## Day01

### EJB2 与 Spring 框架的区别 

> EJB2 中定义一个简单的类 需要继承或者实现EJB2 的类或者接口，并且实现若干个生命周期回调方法以便参与到EJB2的生命周期内，这样代码就非常的冗余，大部分类里面都需要实现EJB2的生命周期的方法
>
> 在Spring中，则是通过依赖注入的方式来装配这些Bean



**Spring 通过应用上下文 Application Context(负责Bean的创建和组装)  装载 Bean的定义，并把他们组装起来**



### Spring框架的目的是为了简化Java的开发,降低耦合



### Spring采取的四种关键的策略

> 基于POJO的轻量级和最小侵入性编程
>
> 通过依赖注入和面向切面编程
>
> 基于切面和惯例进行声明式编程
>
> 通过切面和模块减少模板代码



### 基于切面进行声明式编程

####  AOP 确保 POJO 保持简单

#### 切面的使用

> 一般都是将 事务、日志、安全校验 放在切面上做。这样的好处是这些系统性的辅助模块可以不侵入到核心模块的代码中，减低代码的耦合。



#### 切面实现

> 声明Bean(实现日志、事务的类) 
>
> 然后在Bean 里面声明 定义切面(就是需要执行日志、事务的方法)(xml配置方 <aop:config ref="引用日志、事务Bean">  <aop:aspect > <aop:pointcut > <aop:before pointcut-ref="切入点(就是需要执行日志、事务操作的method)" > <aop:after > )
>
> 然后设置前置通知、后置通知



### Spring 容器

#### Spring自带的容器实现

BeanFactory、Application(基于BeanFactory构建)

> 应用对象生存于Spring 容器中
>
> 创建 、装配、配置、管理、销毁 Bean



#### 3种常见的应用上下文

> ClassPathXmlApplicationContext   从类路径下的xml配置文件中加载上下文定义，把应用上下文定义文件当作类资源
>
> FileSystemXmlApplicationContext   读取文件系统下的xml配置文件并加载上下文定义
>
> XmlWebApplicationContext   读取web应用下的xml配置文件并装载上下文定义



### Bean的生命周期

传统的Java应用，Bean的生命周期很简单，需要使用的时候直接Java关键字 new进行Bean的实例化，然后该Bean就可以被使用了，当该Bean不再被使用的时候，则由Java 自动内存回收机制(JVM)，对该Bean进行回收。

#### Bean的初始化与销毁

```xml
<bean init-method="bean初始化执行的method"/>
<bean destory-method="指定bean从容器移除之前执行需要调用的方法">
```





### Bean的注入 两种方式

> 构造器注入Bean  <bean> <constructor-arg ref=""/></bean>
>
> 通过工厂方法创建Bean   <bean factory-method="getInstance" scope="prototype"/>
>
> setter注入



#### socpe Bean 的作用域

> prototype   允许Bean的定义可以被实例化任意次(每次调用都会创建一个实例)
>
> singleto     在Spring容器中，一个Bean定义只允许创建一个实例
>
> request	在一个Http请求中，每个Bean定义只能创建一个实例，该作用域仅在Spring 上下文中有效
>
> session	在一次 HTTP session 中一个Bean定义只能创建一个Bean
>
> global-session	在一个全局HTTP session 中，每个Bean定义对应一个实例





#### Spring Bean生命周期  p18

> 实例化 Instantiation
>
> 属性赋值 Populate  构造器和setter方法注入两种方式
>
> 初始化 Initialization  
>
> 销毁 Destruction

1. createBeanInstance() -> 实例化
2. populateBean() -> 属性赋值
3. initializeBean() -> 初始化

只有初始化和销毁这两个阶段用户可以自定义扩展点，如果Bean实现了(BeanNameAware/BeanFactoryAware/ApplicationContextAware/BeanPostProcessor/InitializingBean/BeanPostProcessor),Spring将调用对应的方法，此时Bean已经存在上下文对象中，可以直接调用，知道上下文被销毁



### Spring 六大功能模块

#### Data access & integration

> JDBC   	数据库访问模块
>
> ORM  	Object Relational Mapping    	集成了Hibernate  Mybatis  Java Persisternce API(JPA)
>
> Transaction  	事务
>
> JMS  	 Java Message Server
>
> OXM	Java对象 映射到 xml文件



#### Web and remoting

> Web		使用最广泛的模块
>
> servlet
>
> Protlet
>
> Struts  	 



#### AOP

> AOP		面向切面编程  日志、事务、安全校验、认证授权都是在这上面操作的  解耦(将系统模块与核心业务模块分离)
>
> Aspects		切面



#### Instrumentation

> Instrument	
>
> Instrument Tomcat



#### Core Spring container

> Bean   		组件  POJO 也是核心模块
>
> Core
>
> Context			上下文 (Bean容器) 创建 装配 管理 Bean
>
> Expression		异常
>
> Context support



#### Testing

> Test		测试



### Spring 是使用反射来创建对象的



### SpringMVC



## Day02

#### SpEL表达式



#### Bean的自动装配  Autowiring

自动装配 将Spring容器里面的Bean实例 装配到指定的 Bean里面(Controller里面装配 service、Service装配 DAO，替换掉之前的new 创建对象，大大降低了代码的耦合，将class当做bean放入Spring容器里面，在项目里面的任意一个class 都可以使用@Autowired 注入Bean到指定的class里面)



##### 四种装配方式

> byName： 把与Bean的属性具有相同名字(id)的其他Bean自动装配到Bean的对应属性中。如果没有跟属性的名字相匹配的Bean，则不进行装配
>
> byType：把与Bean的的属性具有相同类型的Bean自动装配到对应的属性中，如果没有就不装配
>
> constructor：把与Bean的构造器入参具有相同类型的其他Bean装配到Bean构造器的入参中
>
> autodetect：首先尝试使用constructor进行自动装配，如果失败，再尝试byType



**使用@Autowired注入 Bean的时候，如果Bean不存在或者有多个的时候，会抛出NoSuchBeanDefinitionException异常**

@Qualifier 配合 @Autowired 使用就可以在多个Bean中指定使用哪个Bean

```java
@Autowired
@Qualifier(DruidImpl1)  // 往Controller 里面注入 DruidImple1 这个Bean
DruidService druidService;

public class DruidImpl1 implements DruidService {}

public class DruidImpl2 implements DruidService {}

public interface DruidService {}
```



#### Bean的发现 AutoDisover



```xml
<context:annotation-config>
    配置Bean
</context:annotation-config>

<context:component-scan base-package="">
    自动检测Bean和定义Bean
    <context:include-filter type="" expression="">
        定义要扫描策略
    </context:include-filter>
</context:component-scan>
注解开发 
@ComponentScan

// 下面两个注解都是用在Dao层
@Mapper // 不需要配置扫描地址,这个是通过xml里面的namespace地址，生成对应的Bean，然后注入到容器中
@Repository // 需要扫描地址，扫描Dao层，并生成相应的Bean，注入Spring容器，然后容器中才能有这个Bean
```



#### @Configuration  配置类

> 可以在配置类中定义Bean，然后每次项目启动的时候，会自动加载被Configuration标准的类，然后将该类中使用@Bean 标注的class(这个class，在其他目录下定义了，然后在配置类中new出来，并放入Spring容器里面)

class 不等于 Bean(Bean 的最早的概念是在EJB 中提出来的)



### 面向切面编程 AOP

**在一个系统里面，有一些模块是公共的，像认证授权、日志、事务管理、缓存**



术语

> 通知 advise
>
> 连接点 join point
>
> 切点 pointcut
>
> 切面  Aspect 	 通知和切点的结合
>
> 织入  weaving 将切面应用到目标对象来创建新的代理对象的过程



Spring切面可以应用的5种类型的通知

> before 
>
> after
>
> around
>
> after-returning
>
> after-throwing



#### AspectJ 切点表达式

```java
execution (* com.springinaction.springidol.Instrument.play(..))
```

Spring AOP 配置元素简化了基于 POJO切面的声明

```java
<aop:advisor>  定义AOP通知
<aop:after>	定义AOP后置通知
<aop:after-returning>	定义AOP after-returning 通知
<aop:after-throwing>    定义after-throwing 通知
<aop:around>    定义环绕通知
<aop:aspect>    定义切面
<aop:aspect-autoproxy>	启用 @AspectJ注解驱动的切面	
<aop:before>	定义AOP前置通知	
<aop:config>	顶层的AOP配置元素
<aop:declare-parents>	为被通知的对象引入额外的接口，并透明的实现
<aop:pointcut>    定义切点
```



@Around  标注在方法上面，作为环绕通知