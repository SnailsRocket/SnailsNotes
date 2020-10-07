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

