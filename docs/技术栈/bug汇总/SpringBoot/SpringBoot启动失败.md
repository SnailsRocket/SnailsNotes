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