## Mybatis 之 Mapper 与 Repository的区别

**Mapper 和 Repository  都是修饰持久层类的注解，但是Repository是Spring官方提供的，Mapper是Mybatis提供的。使用Mapper修饰的bean不能被spring识别(注入到业务层会有波浪线，但是运行没有问题)，因为Mybatis 底层使用的是JDK动态代理，coding的时候找不到该Bean，但是运行的时候Mybatis会动态生成这个Bean，并加入到Spring的容器中。**



@Mapper 使用这个注解就不需在启动类上面加上@MapperScan

@Repository 需要结合@MapperScan 使用，不然找不到xml文件



参考：https://blog.csdn.net/lalioCAT/article/details/51803461

































