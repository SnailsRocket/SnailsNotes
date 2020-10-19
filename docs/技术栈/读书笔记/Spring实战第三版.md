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



### DAO 数据访问对象 data access Object

**Hibernate、Mybatis(plus)、Jpa 简化了JDBC的操作，拆分成两大块，一个是模板模块、一个是写具体的查询逻辑(SQL),一般简单的单表，可以直接使用框架提供得模板(接口)，模板部分封装了加载数据库驱动、获取数据库连接、获取执行器、关闭数据库连接、关闭执行器等等**

#### DriverManagerDateSource



### Mybatis

#### lazy loading  延迟加载  

只抓取需要的数据

> 像我们需要查询一组 Department 对象的数据，Department对象里面有一个EmployeeList  数据集，我们只关心Department属性，查询每个Department对象中EmployeeList 可能会很耗时，所以暂时不执行，等待需要用的时候再去查(就像电商项目中的商品展示一样，一般只展示商品的亮点信息，详细信息需要点击去才能查看的到)。



#### Eager fetching  预先抓取

> 很多时候如果数据固定(电商系统的首页那些数据一般变动不大(更进阶的做法是 使用 thymeleaf 模板))，一般都预先加载到内存中

**前端里面也有类似的操作，像 Created mounted 钩子函数等**

#### Cascading 级联

**有时候，修改一张表里面的数据会更改其他表里面的数据**



### 事务  @Transactional

**f分为编码式事务和声明式事务(基于AOP)**

将一系列操作放入事务中(转账流程)，如果中间有一个环节出问题，整个流程回滚，重新执行

**转账逻辑**

> 1.首先a账号给b账号转账100
>
> 2.查询a账号里面是否有 100，true就冻结这100 金额，(冻结是为了防止在转账的过程中其他操作将a账号里面的金额全部取出，然后a扣款的时候失败)
>
> 3.a账号扣减 100，
>
> 4.b账号增加100，
>
> 5.提交事务

**如果不用事务，在给a账号扣款成功后，服务器宕机，后面的逻辑没有继续执行，b账号没有增加余额**



#### 事务管理器  transactionManager



#### ACID  

> 原子性  Atomic
>
> 一致性 Consistent
>
> 隔离性 Isolated
>
> 持久性 Durable



#### 隔离级别



> read-uncommitted  允许读取未提交的数据，可能会导致脏读、幻读、不可重复读
>
> read-committed	允许读取并发事务已提交的数据、可以阻止脏读
>
> repeatable-read	对同意字段的多次读取结果是一致的，除非数据是被本事务自己所修改，可以阻止脏读、不可重复读，幻读还是有可能发生
>
> serializable 完全服从ACID的隔离界别，完全锁定事务相关的数据库表来实现

Mysql 默认是 read-committed



**并发会导致下列问题**

> 脏读 事务a 读取到事务b 修改未提交的数据
>
> 不可重复读	 事务a第一次读和第二次读的数据不一致
>
> 幻读	与不可重复读类似，事务a读取了几行数据，另一个并发事务b插入了一些数据，在之后的查询中事务a查到一些原本不存在的数据



#### 事务超时

> 为了使应用程序很好的运行，事务不能执行太长时间，因为事务是对后端数据库进行锁定，可能是一部分数据，可能是整张表。如果事务执行的时间很长，那么其他 线程都在等待状态，整个应用响应的速度大大的降低(这里就是不使用事务的最高隔离级别Serializable)，一般过了事务超时时间就直接回滚事务。



### SpringMVC

##### SpringMVC执行流程

> 1, 前端发出请求 URL
>
> 2.请求到DispatcherServlet (前端控制器)
>
> 3.前端控制器收到请求之后，转到 Handler Mapper(处理器映射) 并返回 Chain(执行链)到DispatcherServlet
>
> 4.然后Chain被发送 到 Handler Adaptor (处理器适配器)，并有适配器分发到每个Handler上面
>
> 5.handler 执行分发过来的认为，并返回ModelAndView
>
> 6.DispatcherServlet收到ModelAndView 之后，将它转给ViewResolver(视图处理器),并返回 View 给DispatcherServlet，
>
> 7.然后DispatcherServlet将View 渲染成 jsp 、thymeleaf、freemark并返回给前端界面



**SpringMVC 基于Model View Controller模型实现的**

**DispatcherServlet 的任务是把url请求发送到Controller 上，良好的控制器一般不处理业务逻辑，都是将业逻辑丢给拖给service去处理**



### SpringSecurity

基于Spring AOP 和 Servlet 过滤器实现的安全框架



#### SpringSecurity 支持 SpEL 表达式

> authentication
>
> denyAll
>
> hasAnyRole
>
> hasRole
>
> hasIpAddress
>
> isAnonymous
>
> isAuthenticated
>
> isFullyAuthenticated
>
> isRememberMe
>
> permitAll
>
> principal



#### RPC  remote produre Call

REST (Representational State Transfer)  是面向资源的

RPC 是面向服务的，并且关注于行为和动作

REST 是基于 SpringMVC的 

**4个主要的REST方法:get、post、delete、put**当然还有三个不常见的option、head、trace

**每个HTTP方法具有两个特性：安全性和幂等性，如果一个方法不改变资源的状态就认为它是安全的。幂等的方法可能改变状态可能不改变状态，但是一次请求和多次请求具有相同的作用，按照规定所有安全的方法都必须是幂等的，但是幂等的方法不一定是安全的**

对HttpClient 的封装 RestTemplate(Spring 框架提供的)

HiddenHttpMethodFilder 放在 DispatchServlet  之前，对后台进行访问的URL进行针对性的过滤



### JMS  java message service

**JMS相比于同步通信，他没有等待，减低代码之间的耦合，提升框架的可扩展性**

**基于JMS实现的消息中间件有 ActiveMQ**

**还有RabbitMQ、RocketMQ、kafka**

#### 点对点消息模型

> 每一个消息都有一个发送者和接受者



#### 发布/订阅消息模型

> 有一个发布者发送消息，其他多个(也可以是单个)服务监听这个消息队列，当有消息时，就取出来消费掉



#### Spring 对 JMS 的支持

JmsTemplate