SpringBoot 错误总结 （累计35个常见错误）（持续更新....）

##### 1.新建Spring boot,出现src的包上出现错误的叉号：

 分析原因: 你要更新一下选择项目-----Maven----Updata project，或者删除jar包---Libraries---Maven Dependencies，然后重新关闭eclipse，重新启动！

##### 2.如果你项目与别人一样，怎么试都不行，还是报错，或者其它问题：

  记住一句话，小问题重启，大问题重装！

##### 3.启动时出现警告：

分析原因: 项目目录设计错误

application.[Java](http://lib.csdn.net/base/java) 文件不能直接放在main/java文件夹下，必须要建一个包把他放进去

##### 4.Web项目无法访问resources/templates/xxx.html文件

分析原因:没有导入相关模板的依赖

##### 5.启动时出现NoSuchBeanDefinitionException: No qualifying bean of type [con: No qualifying bean of type

分析原因:@SpringApplicationConfiguration

##### 6.`BasicErrorController`提供两种返回错误一种是页面返回、当你是页面请求的时候就会返回页面，另外一种是json请求的时候就会返回json错误：

分析原因:

```java
 @RequestMapping(produces = "text/html")
    public ModelAndView errorHtml(HttpServletRequest request,
            HttpServletResponse response) {
        HttpStatus status = getStatus(request);
        Map<String, Object> model = Collections.unmodifiableMap(getErrorAttributes(
                request, isIncludeStackTrace(request, MediaType.TEXT_HTML)));
        response.setStatus(status.value());
        ModelAndView modelAndView = resolveErrorView(request, response, status, model);
        return (modelAndView == null ? new ModelAndView("error", model) : modelAndView);
    }
 
    @RequestMapping
    @ResponseBody
    public ResponseEntity<Map<String, Object>> error(HttpServletRequest request) {
        Map<String, Object> body = getErrorAttributes(request,
                isIncludeStackTrace(request, MediaType.ALL));
        HttpStatus status = getStatus(request);
        return new ResponseEntity<Map<String, Object>>(body, status);
 
          }
```

##### 7.javax.servlet.ServletException: Circular view path [login]: would dispatch back to the current handler URL [/login] again出现错误：

 分析原因:

当没有声明ViewResolver时，spring会注册一个默认的ViewResolver，就是JstlView的实例， 该对象继承自InternalResoureView。
JstlView用来封装JSP或者同一Web应用中的其他资源，它将model对象作为request请求的属性值暴露出来, 并将该请求通过javax.servlet.RequestDispatcher转发到指定的URL.
Spring认为， 这个view的URL是可以用来指定同一web应用中特定资源的，是可以被RequestDispatcher转发的。
也就是说，在页面渲染(render)之前，Spring会试图使用RequestDispatcher来继续转发该请求。

解决:消除缺省转发,修改view和path，让他们不同名。

##### 8.当以.yml结尾的配置出现报错：

  分析原因：文件中有多余的空格，这个需要ctrl + alt + l 将文件格式化，然后删除掉多余的空格。

##### 9.当出现错误java.net.BindException: Address already in use: bind

 解决：打开Windows进程管理器结束javaw.exe，重新运行。并在每次启动程序前，结束之前的运行。

##### 10.当出现错误Spring Boot Error: java.lang.NoSuchMethodError

 解决：仔细搜索报错信息中的方法名，查看出错类中是否缺少某方法。笔者此次报错由于org.springframework.core.ResolvableType.forInstance方法找不到所致，又想起 之前在pom.xml中移除了parent依赖，想起是否改文件没有完整下载。查询了官网说明：当移除parent依赖时，需要增加spring-boot-dependencies的依赖。因此pom.xml中在<dependencies>前新增以下依赖。

```xml
<dependencyManagement>
  <dependencies>
    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-dependencies</artifactId>
      <version>1.3.3.RELEASE</version>
      <type>pom</type>
      <scope>import</scope>
    </dependency>
  </dependencies>
</dependencyManagement>
```

##### 11.当出现错误java -jar myApplication.jar

分析原因：系统报错，Unable to start EmbeddedWebApplicationContext due to missing EmbeddedServletContainerFactory bean.

  解决：在Application.java主程序入口中加入以下代码：

```java
@Bean
public EmbeddedServletContainerFactory servletContainer() {
       
    TomcatEmbeddedServletContainerFactory factory = new TomcatEmbeddedServletContainerFactory();
    return factory;
       
}
```

##### 12 .启动spring boot报错

 解决：这个原因是maven依赖包冲突，有重复的依赖（有循环依赖，A依赖B，然后B又依赖A）。 检查一下你引入的jar包里面是不是有相同的方法名。

##### 13.结果启动时报错BeanCreationException：

org.springframework.beans.factory.BeanCreationException:
Error creating bean with name 'userController':
Injection of autowired dependencies failed;
nested exception is org.springframework.beans.factory.BeanCreationException: Could not autowire field: private com.caizhaotu.dao.user.UserRepository com.caizhaotu.controller.user.UserController.userRepository;
nested exception is org.springframework.beans.factory.BeanCreationException: Error creating bean with name 'userRepository': Invocation of init method failed; nested exception is java.util.NoSuchElementException

解决：application.java 可以放在controller、service、dao层都可以，但是要保证application.java 包位置处于所有层的上级，比如com.xxx.web、com.xxx.service、com.xxx.dao。把application.java放在com.xxx即可。@SpringBootApplication 注解效果等于 @Configuration，@EnableAutoConfiguration 及 @ComponentScan 这三个注解一起使用，所以不要在 Controller 在启动类上面添加 @EnableAutoConfiguration 。

##### 14.class TaskImpl 中注入失败，目标变量为null并报错

解决：1.一些业务细节代码已经单机跑通了。 2.使用了@SpringBootApplication进行自动化配置与扫描。3.没有遗漏的@Component。

##### 15.Spring Boot单元测试报错

```java
java.lang.NoClassDefFoundError: org/mockito/internal/util/MockUtil
 
    at org.springframework.boot.test.mock.mockito.MockReset.<clinit>(MockReset.java:56)
    at org.springframework.boot.test.mock.mockito.ResetMocksTestExecutionListener.beforeTestMethod(ResetMocksTestExecutionListener.java:44)
    at org.springframework.test.context.TestContextManager.beforeTestMethod(TestContextManager.java:269)
    at org.springframework.test.context.junit4.statements.RunBeforeTestMethodCallbacks.evaluate(RunBeforeTestMethodCallbacks.java:74)
    at org.springframework.test.context.junit4.statements.RunAfterTestMethodCallbacks.evaluate(RunAfterTestMethodCallbacks.java:86)
    at org.springframework.test.context.junit4.statements.SpringRepeat.evaluate(SpringRepeat.java:84)
    at org.junit.runners.ParentRunner.runLeaf(ParentRunner.java:325)
    at org.springframework.test.context.junit4.SpringJUnit4ClassRunner.runChild(SpringJUnit4ClassRunner.java:252)
    at org.springframework.test.context.junit4.SpringJUnit4ClassRunner.runChild(SpringJUnit4ClassRunner.java:94)
    at org.junit.runners.ParentRunner$3.run(ParentRunner.java:290)
    at org.junit.runners.ParentRunner$1.schedule(ParentRunner.java:71)
    at org.junit.runners.ParentRunner.runChildren(ParentRunner.java:288)
    at org.junit.runners.ParentRunner.access$000(ParentRunner.java:58)
    at org.junit.runners.ParentRunner$2.evaluate(ParentRunner.java:268)
    at org.springframework.test.context.junit4.statements.RunBeforeTestClassCallbacks.evaluate(RunBeforeTestClassCallbacks.java:61)
    at org.springframework.test.context.junit4.statements.RunAfterTestClassCallbacks.evaluate(RunAfterTestClassCallbacks.java:70)
    at org.junit.runners.ParentRunner.run(ParentRunner.java:363)
    at org.springframework.test.context.junit4.SpringJUnit4ClassRunner.run(SpringJUnit4ClassRunner.java:191)
    at org.junit.runner.JUnitCore.run(JUnitCore.java:137)
    at com.intellij.junit4.JUnit4IdeaTestRunner.startRunnerWithArgs(JUnit4IdeaTestRunner.java:117)
    at com.intellij.junit4.JUnit4IdeaTestRunner.startRunnerWithArgs(JUnit4IdeaTestRunner.java:42)
    at com.intellij.rt.execution.junit.JUnitStarter.prepareStreamsAndStart(JUnitStarter.java:262)
    at com.intellij.rt.execution.junit.JUnitStarter.main(JUnitStarter.java:84)
Caused by: java.lang.ClassNotFoundException: org.mockito.internal.util.MockUtil
    at java.net.URLClassLoader.findClass(URLClassLoader.java:381)
    at java.lang.ClassLoader.loadClass(ClassLoader.java:424)
    at sun.misc.Launcher$AppClassLoader.loadClass(Launcher.java:331)
    at java.lang.ClassLoader.loadClass(ClassLoader.java:357)
```

 解决：在build.gradle引用compile中加入[group: 'org.mockito', name: 'mockito-all', version: '1.10.19']

##### 16.eclipse新建springboot的项目，出现以下错误The type org.springframework.context.ConfigurableApplicationContext cannot be resolved. It is indirectly referenced from required .class files

解决：执行 mvn dependency:purge-local-repository  mvn clean

##### 17.[ERROR] Failed to execute goal org.springframework.boot:spring-boot-maven-plugin:1.4.3.RELEASE:repackage (default-cli) on project springboot_1: Execution default-cli of goal org.springframework.boot:spring-boot-maven-plugin:1.4.3.RELEASE:repackage failed: Source must refer to an existing file -> [Help 1]

[ERROR] To see the full stack trace of the errors, re-run Maven with the -e switch.
[ERROR] Re-run Maven using the -X switch to enable full debug logging.
[ERROR] For more information about the errors and possible solutions, please read the following articles:
[ERROR] [Help 1] http://cwiki.apache.org/confluence/display/MAVEN/PluginExecutionException Process finished with exit code 1

解决：直接使用maven的package命令，即可完成打包，若有新的内容添加，可以使用spring-boot-maven-plugin的repackage命令.

##### 18.使用spring boot 使用druid，启动tomcat时报错：提示由于unregister mbean error导致无法启动启动类。

解决：在配置文件加入`spring.jmx.enabled: false`

##### 19.出现这样的错误：

```java
at org.springframework.beans.factory.support.ConstructorResolver.createArgumentArray(ConstructorResolver.java:749) ~[spring-beans-4.3.10.RELEASE.jar:4.3.10.RELEASE]
at org.springframework.beans.factory.support.ConstructorResolver.instantiateUsingFactoryMethod(ConstructorResolver.java:467) ~[spring-beans-4.3.10.RELEASE.jar:4.3.10.RELEASE]
at org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.instantiateUsingFactoryMethod(AbstractAutowireCapableBeanFactory.java:1173) ~[spring-beans-4.3.10.RELEASE.jar:4.3.10.RELEASE]

org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.doCreateBean(AbstractAutowireCapableBeanFactory.java:513) ~[spring-beans-4.3.10.RELEASE.jar:4.3.10.RELEASE]
at org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.createBean(AbstractAutowireCapableBeanFactory.java:483) ~[spring-beans-4.3.10.RELEASE.jar:4.3.10.RELEASE]
at org.springframework.beans.factory.support.AbstractBeanFactory$1.getObject(AbstractBeanFactory.java:306) ~[spring-beans-4.3.10.RELEASE.jar:4.3.10.RELEASE]
at org.springframework.beans.factory.support.DefaultSingletonBeanRegistry.getSingleton(DefaultSingletonBeanRegistry.java:230) ~[spring-beans-4.3.10.RELEASE.jar:4.3.10.RELEASE]
```

 解决：删除jar包，重新导入。

##### 20.在spring boot项目中出现不能加载iframe 页面报一个"Refused to display 'http://......' in a frame because it set 'X-Frame-Options' to 'DENY'. "错误

  解决：因spring Boot采取的java config，在配置spring security的位置添加：

```javal
@Override
protected void configure(HttpSecurity http) throws Exception {
       http.headers().frameOptions().disable();
     http
      .csrf().disable();
     http
      .authorizeRequests()
             .anyRequest().authenticated();
      http.formLogin()
          .defaultSuccessUrl("/platform/index",true)
          .loginPage("/login")
          .permitAll()
        .and()
          .logout()
           .logoutUrl("/logout");
      
      http.addFilterBefore(wiselyFilterSecurityInterceptor(),FilterSecurityInterceptor.class);
      
}
```

##### 21.错误提示如下:

Caused by: java.lang.IllegalStateException: Tomcat connector in failed state

at org.springframework.boot.context.embedded.tomcat.TomcatEmbeddedServletContainer.start(TomcatEmbeddedServletContainer.java:159) ~[spring-boot-1.3.6.RELEASE.jar:1.3.6.RELEASE]

... 15 common frames omitted

2017-04-14 19:36:55.419 ERROR 19420 --- [  restartedMain] o.a.coyote.http11.Http11NioProtocol    : Failed to start end point associated with ProtocolHandler ["http-nio-8080"]

解决：是NI server占据了8080端口。

##### 22 .出现springboot框架maven构建fastJson启动报错

```java
Exception in thread "main" java.lang.IllegalStateException: Failed to read Class-Path 
attribute from manifest of jar file:
/E:/myRepository/repositotyExe/repositoty/com/alibaba/fastjson/1.2.32/fastjson-1.2.32.jar
at org.springframework.boot.devtools.restart.ChangeableUrls.
getUrlsFromClassPathOfJarManifestIfPossible(ChangeableUrls.java:110)
at org.springframework.boot.devtools.restart.ChangeableUrls.fromUrlClassLoader
(ChangeableUrls.java:96)
at org.springframework.boot.devtools.restart.DefaultRestartInitializer.getUrls
(DefaultRestartInitializer.java:93)
at org.springframework.boot.devtools.restart.DefaultRestartInitializer.getInitialUrls(
DefaultRestartInitializer.java:56)
at org.springframework.boot.devtools.restart.Restarter.<init>(Restarter.java:140)
at org.springframework.boot.devtools.restart.Restarter.initialize(Restarter.java:546)
at org.springframework.boot.devtools.restart.RestartApplicationListener.onApplication
StartingEvent(RestartApplicationListener.java:67)
at org.springframework.boot.devtools.restart.RestartApplicationListener.onApplicationEvent
(RestartApplicationListener.java:45)
at org.springframework.context.event.SimpleApplicationEventMulticaster.invokeListener
(SimpleApplicationEventMulticaster.java:167)
at org.springframework.context.event.SimpleApplicationEventMulticaster.multicastEvent
(SimpleApplicationEventMulticaster.java:139)
at org.springframework.context.event.SimpleApplicationEventMulticaster.multicastEvent
(SimpleApplicationEventMulticaster.java:122)
at org.springframework.boot.context.event.EventPublishingRunListener.starting(
EventPublishingRunListener.java:68)
at org.springframework.boot.SpringApplicationRunListeners.starting(SpringAppl
icationRunListeners.java:48)
at org.springframework.boot.SpringApplication.run(SpringApplication.java:303)
at org.springframework.boot.SpringApplication.run(SpringApplication.java:1162)
at org.springframework.boot.SpringApplication.run(SpringApplication.java:1151)
at com.bldz.springboot.Spring_Boot_JdbcTemplate.App.main(App.java:14)
Caused by: java.util.zip.ZipException: invalid LOC header (bad signature)
	at java.util.zip.ZipFile.read(Native Method)
	at java.util.zip.ZipFile.access$1400(ZipFile.java:60)
	at java.util.zip.ZipFile$ZipFileInputStream.read(ZipFile.java:717)
	at java.util.zip.ZipFile$ZipFileInflaterInputStream.fill(ZipFile.java:419)
	at java.util.zip.InflaterInputStream.read(InflaterInputStream.java:158)
	at sun.misc.IOUtils.readFully(IOUtils.java:65)
	at java.util.jar.JarFile.getBytes(JarFile.java:425)
	at java.util.jar.JarFile.getManifestFromReference(JarFile.java:193)
	at java.util.jar.JarFile.getManifest(JarFile.java:180)
	at org.springframework.boot.devtools.restart.ChangeableUrls.getUrlsFromCl
assPathOfJarManifestIfPossible(ChangeableUrls.java:107)
	... 16 more
```

 解决：删除maven仓库下的 /E:/myRepository/repositotyExe/repositoty/com/alibaba/fastjson/1.2.32/fastjson-1.2.32.jar,重新编译即可!

##### 23.Spring Boot Maven项目启动报错

```java
ERROR 2172 --- [ main] o.s.boot.SpringApplication : Application startup failed    org.springframework.boot.context.embedded.EmbeddedServletContainerException: Unable to start embedded Jetty servlet container

at org.springframework.boot.context.embedded.jetty.JettyEmbeddedServletContainer.start(JettyEmbeddedServletContainer.java:124) ~[spring-boot-1.3.1.RELEASE.jar:1.3.1.RELEASE]
at org.springframework.boot.context.embedded.EmbeddedWebApplicationContext.startEmbeddedServletContainer(EmbeddedWebApplicationContext.java:293) ~[spring-boot-1.3.1.RELEASE.jar:1.3.1.RELEASE]
at org.springframework.boot.context.embedded.EmbeddedWebApplicationContext.finishRefresh(EmbeddedWebApplicationContext.java:141) ~[spring-boot-1.3.1.RELEASE.jar:1.3.1.RELEASE]
at org.springframework.context.support.AbstractApplicationContext.refresh(AbstractApplicationContext.java:541) ~[spring-context-4.2.4.RELEASE.jar:4.2.4.RELEASE]
at org.springframework.boot.context.embedded.EmbeddedWebApplicationContext.refresh(EmbeddedWebApplicationContext.java:118) ~[spring-boot-1.3.1.RELEASE.jar:1.3.1.RELEASE]
at org.springframework.boot.SpringApplication.refresh(SpringApplication.java:764) [spring-boot-1.3.1.RELEASE.jar:1.3.1.RELEASE]
at org.springframework.boot.SpringApplication.doRun(SpringApplication.java:357) [spring-boot-1.3.1.RELEASE.jar:1.3.1.RELEASE]
at org.springframework.boot.SpringApplication.run(SpringApplication.java:305) [spring-boot-1.3.1.RELEASE.jar:1.3.1.RELEASE]
at org.springframework.boot.SpringApplication.run(SpringApplication.java:1124) [spring-boot-1.3.1.RELEASE.jar:1.3.1.RELEASE]
at org.springframework.boot.SpringApplication.run(SpringApplication.java:1113) [spring-boot-1.3.1.RELEASE.jar:1.3.1.RELEASE]
at com.easemob.weichat.gateway.im.IMRoutewayServerStarter.main(IMRoutewayServerStarter.java:28) [classes/:na]
Caused by: java.net.BindException: Address already in use
at sun.nio.ch.Net.bind0(Native Method) ~[na:1.8.0_112]
at sun.nio.ch.Net.bind(Net.java:433) ~[na:1.8.0_112]
at sun.nio.ch.Net.bind(Net.java:425) ~[na:1.8.0_112]
at sun.nio.ch.ServerSocketChannelImpl.bind(ServerSocketChannelImpl.java:223) ~[na:1.8.0_112]
at sun.nio.ch.ServerSocketAdaptor.bind(ServerSocketAdaptor.java:74) ~[na:1.8.0_112]
at org.eclipse.jetty.server.ServerConnector.open(ServerConnector.java:321) ~[jetty-server-9.2.14.v20151106.jar:9.2.14.v20151106]
at org.eclipse.jetty.server.AbstractNetworkConnector.doStart(AbstractNetworkConnector.java:80) ~[jetty-server-9.2.14.v20151106.jar:9.2.14.v20151106]
at org.eclipse.jetty.server.ServerConnector.doStart(ServerConnector.java:236) ~[jetty-server-9.2.14.v20151106.jar:9.2.14.v20151106]
at org.eclipse.jetty.util.component.AbstractLifeCycle.start(AbstractLifeCycle.java:68) ~[jetty-util-9.2.14.v20151106.jar:9.2.14.v20151106]
at org.springframework.boot.context.embedded.jetty.JettyEmbeddedServletContainer.start(JettyEmbeddedServletContainer.java:118) ~[spring-boot-1.3.1.RELEASE.jar:1.3.1.RELEASE]
... 10 common frames omitted
```

解决：典型的端口被占用，，改下你的boot启动端口

##### 24.The type javax.servlet.http.HttpServletRequest cannot be resolved. It is indirectly referenced from required .class files
是缺少serverlet的引用库，

 解决：
  1.工程右键-properties->java build path
  2.在java build path的libraries tab页中选择Add external Jars按钮
  \3. 选择eclipse的安装目录，我本机的路径如下，你自己需要根据自己的路径查找添加。E:\eclipse-java-indigo-SR1-win32\eclipse\plugins 选择javax.servlet.jsp_2.0.0.v201101211617.jar；javax.servlet_2.5.0.v201103041518.jar 进行添加即可
  注释：由于版本不同，文件包名可能稍有区别。

##### 25.Ambiguous mapping. Cannot map 'XXXController' method

解决：

@RequestMapping(value=XXX) 可能是同一个Controller或者 是不同的Controller。 XXX重名导致。

##### 26.打开Eclipse提示“The default workspace “xxxx” is in use or cannot be created Please choose a different one“

解决： 第一种：出现这种情况一般是workspace的配置文件中出现了.lock文件（workspace/.metadata/.lock），锁定了workspace。把.lock文件删除即可。如果该文件不能删除，可能是因为javaw.exe进程未结束，结束该进程及eclipse.exe进程即可删除。
第二种：重新启动电脑。

##### 27.missing artifact com.oracle:ojdbc6:jar:11.2.0.1.0问题解决 ojdbc包pom.xml出错

原因：Oracle的ojdbc.jar是收费的，所以maven的中央仓库中没有这个资源，只能通过配置本地库才能加载到项目中去。

解决：

1.首先确定你是否有安装oracle，如果有安装的话，找到ojdbc6.jar包
D:\app\Administrator\product\11.2.0\dbhome_1\jdbc\lib\ojdbc6.jar(这是我路径，你们的可能与我不同)
2.将ojdbc6.jar包添加到maven本地仓库或者手动加入jar包。
3.最后找到项目的pom.xml引入如下代码，右击项目名称，找到maven，找到update project更新下就ok了。

##### 28.tomcat用shell定时清理日志

解决：

1.写一个/usr/local/script/cleanTomcatlog.sh脚本

```shell
#!/bin/bash
export LANG=zh_CN
#tomcat1日志文件路径
export WEB_TOMCAT1=/usr/local/tomcat1/logs
#tomcat2日志文件路径
export WEB_TOMCAT2=/usr/local/tomcat2/logs
#tomcat3日志文件路径
export WEB_TOMCAT3=/usr/local/tomcat3/logs
echo > ${WEB_TOMCAT1}/catalina.out
echo > ${WEB_TOMCAT2}/catalina.out
echo > ${WEB_TOMCAT3}/catalina.out
find ${WEB_TOMCAT1}/* -mtime +5 -type f -exec rm -f {} \;
find ${WEB_TOMCAT2}/* -mtime +5 -type f -exec rm -f {} \;
find ${WEB_TOMCAT3}/* -mtime +5 -type f -exec rm -f {} \;
```

2 .设置cleanTomcatlog.sh脚本可执行

```shell
chmod a+x cleanTomcatlog.sh
```

3.在控制台上输入以下命令

```shell
crontab -e
```

4.按i键编辑这个文本文件，输入以下内容，每天凌晨4：30重启tomcat

```shell
30 04 * * * /usr/local/script/cleanTomcatlog.sh
```

按esc键退出编辑，输入wq回车保存

5.重启定时任务

```java
[root@]# service crond stop
 
[root@]# service crond start
```

##### 29.Springboot清理logs日志

解决：

```shell
#!/bin/bash
#路径
logs_path="/mnt/springboot/logs"
find $logs_path -mtime +30 -name "access.log.log.*" -exec rm -rf {} \;
find $logs_path -mtime +30 -name "*.log.*" -exec rm -rf {} \;
>$logs_path/error.log;
```

##### 30.SpringBoot做文件上传时出现了The field file exceeds its maximum permitted size of 1048576 bytes.错误

解决：

Spring Boot 1.3.x或者之前

```java
multipart.maxFileSize=100MB
multipart.maxRequestSize=1000MB
```

Spring Boot 1.4.x

```java
spring.http.multipart.maxFileSize=100MB
spring.http.multipart.maxRequestSize=1000MB
```

很多人设置了multipart.maxFileSize但是不起作用，是因为1.4版本以上的配置改了，详见官方文档：spring boot 1.4
Spring Boot 2.0之后

```java
spring.servlet.multipart.max-file-size=100MB
spring.servlet.multipart.max-request-size=1000MB
```

```java
@Configuration  
@SpringBootApplication  
public class Application {  
  
    public static void main(String[] args) throws Exception {  
        SpringApplication.run(Application.class, args);  
    }  
  
  
    /**  
     * 文件上传配置  
     * @return  
     */  
    @Bean  
    public MultipartConfigElement multipartConfigElement() {  
        MultipartConfigFactory factory = new MultipartConfigFactory();  
        //文件最大  
        factory.setMaxFileSize("10240MB"); //KB,MB  
        /// 设置总上传数据总大小  
        factory.setMaxRequestSize("102400MB");  
        return factory.createMultipartConfig();  
    }  
  
}  
```

##### 31.[spring使用swagger这个错误怎么解决，项目能运行，就是一直报错误。](https://segmentfault.com/q/1010000015756786)

错误日志：

```java
09:09:55.044 logback [RMI TCP Connection(9)-127.0.0.1] DEBUG s.d.s.w.r.o.OperationResponseClassReader - Setting spring response class to:ServerResponse
09:09:55.044 logback [RMI TCP Connection(9)-127.0.0.1] DEBUG s.d.s.r.o.OperationAuthReader - Authorization count 0 for method resetPassword
09:09:55.046 logback [RMI TCP Connection(9)-127.0.0.1] ERROR s.d.s.r.o.OperationHttpMethodReader - Invalid http method: postValid ones are [[Lorg.springframework.web.bind.annotation.RequestMethod;@5c8bcf2a]
java.lang.IllegalArgumentException: No enum constant org.springframework.web.bind.annotation.RequestMethod.post
    at java.lang.Enum.valueOf(Enum.java:238) ~[na:1.8.0_171]
    at org.springframework.web.bind.annotation.RequestMethod.valueOf(RequestMethod.java:35) ~[spring-web-4.3.12.RELEASE.jar:4.3.12.RELEASE]
    at springfox.documentation.swagger.readers.operation.OperationHttpMethodReader.apply(OperationHttpMethodReader.java:50) ~[springfox-swagger-common-2.4.0.jar:2.4.0]
    at springfox.documentation.spring.web.plugins.DocumentationPluginsManager.operation(DocumentationPluginsManager.java:113) [springfox-spring-web-2.4.0.jar:2.4.0]
    at springfox.documentation.spring.web.readers.operation.ApiOperationReader.read(ApiOperationReader.java:80) [springfox-spring-web-2.4.0.jar:2.4.0]
    at springfox.documentation.spring.web.scanners.CachingOperationReader$1.load(CachingOperationReader.java:50) [springfox-spring-web-2.4.0.jar:2.4.0]
    at springfox.documentation.spring.web.scanners.CachingOperationReader$1.load(CachingOperationReader.java:48) [springfox-spring-web-2.4.0.jar:2.4.0]
    at com.google.common.cache.LocalCache$LoadingValueReference.loadFuture(LocalCache.java:3628) [guava-20.0.jar:na]
    at com.google.common.cache.LocalCache$Segment.loadSync(LocalCache.java:2336) [guava-20.0.jar:na]
    at com.google.common.cache.LocalCache$Segment.lockedGetOrLoad(LocalCache.java:2295) [guava-20.0.jar:na]
    at com.google.common.cache.LocalCache$Segment.get(LocalCache.java:2208) [guava-20.0.jar:na]
```

解决:

将小写post改成大写就好了 或者 `@RequestMapping` 注解增加 `method = RequestMethod.POST`

```java
	@ApiOperation(value="获取所有的区域信息", notes="获取区域列表", httpMethod = "GET", response =Area.class, produces = "application/json")
	@RequestMapping(value = "/listarea", method = RequestMethod.GET)
或者
	@ApiOperation(value="获取所有的区域信息", notes="获取区域列表", httpMethod = "POST", response =Area.class, produces = "application/json")
	@RequestMapping(value = "/listarea", method = RequestMethod.POST)
```

##### 32.无法下载SpringBoot 2.0.0.M3和SpringCloud Finchley.M2

解决：
\+ 在pom.xml文件里加上如下代码(可参考[product的pom.xml](https://gitlab-demo.com/SpringCloud_Sell/product/blob/master/pom.xml))：

```java
<repositories>
    <repository>
        <id>spring-snapshots</id>
        <name>Spring Snapshots</name>
        <url>https://repo.spring.io/snapshot</url>
        <snapshots>
            <enabled>true</enabled>
        </snapshots>
    </repository>
    <repository>
        <id>spring-milestones</id>
        <name>Spring Milestones</name>
        <url>https://repo.spring.io/milestone</url>
        <snapshots>
            <enabled>false</enabled>
        </snapshots>
    </repository>
</repositories>
 
<pluginRepositories>
    <pluginRepository>
        <id>spring-snapshots</id>
        <name>Spring Snapshots</name>
        <url>https://repo.spring.io/snapshot</url>
        <snapshots>
            <enabled>true</enabled>
        </snapshots>
    </pluginRepository>
    <pluginRepository>
        <id>spring-milestones</id>
        <name>Spring Milestones</name>
        <url>https://repo.spring.io/milestone</url>
        <snapshots>
            <enabled>false</enabled>
        </snapshots>
    </pluginRepository>
</pluginRepositories>
```

\+ 若在自己配置了国内maven库镜像后无法下载以上版本，则请将镜像注释掉，用maven默认的中央仓库下载（如果觉得太慢，就用科学上网）

##### 33.遇到Eureka Client无法启动的情况

解决：
\+ 如果用的版本是SpringBoot 2.0.0.M3和SpringCloud Finchley.M2按照视频可正常启动
\+ 如果是高版本无法启动时，需要在pom.xml中加入如下依赖：

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>
```

##### 34.order项目的server模块不能正常引入product项目中的client模块

出现原因
\+ 可能是因为product项目的client模块还没有打包成功，order项目的server模块不能找不到该依赖
解决：
\+ 1.先对product项目,在父模块下进行maven打包

```xml
mvn clean install -Dmaven.test.skip=true
```

\+ 2.再进入order项目，用同样的命令再进行打包

##### 35.IDEA连接mysql8.0.16，报[08001] Could not create connection to database server.

Connection to icloud_db@localhost failed.
[08001] Could not create connection to database server. Attempted reconnect 3 times. Giving up.

原因是Mysql版本比较高出现的系列适配问题。

**解决方式:**

**1. mysql5.5 使用：com.mysql.jdbc.Driver而8.0.\*版本用com.mysql.cj.jdbc.Driver**

**2. 追加useSSL+serverTimezone+characterEncoding+autoReconnect**

**jdbc:mysql://localhost:3306/icloud_db?useSSL=false&serverTimezone=Hongkong&characterEncoding=utf-8&autoReconnect=true**

mysql的连接驱动配置在这个位置，idea--->Database--->"+"---->>data source--->>mysql

##### 36.**IDEA中，使用generator插件生成mybatis代码，遇到Could not autowire. No beans of 'xxx' type found.异常**

解决方式1：mapper文件上加@Repository注解，这是从sping2.0新增的一个注解，用于简化 Spring 的开发，实现数据访问；

​        2：在mapper文件上加@Component注解，把普通pojo实例化到spring容器中；

##### 37.TypeException: The alias 'Criterion' is already mapped to the value

通过mybaits插件自动生成代码(多张数据库表的mapper文件)时，报如上异常；

**原因：**是因为mybatis2.0.1自身缺陷导致的bug，而且mybatis默认使用2.0.1。

**解决方式：**使用mybatis-spring 2.0.0 或 2.0.2-SNAPSHOT

##### 38.FileUploadBase$FileSizeLimitExceededException: The field file exceeds its maximum permitted  size of 1048576 bytes.

原因：通过MultipartFile文件上传时，报该异常。原因：上传文件大小超过tomcate的最大限制；

**解决方式：**

方式一：在application.properties中加入配置，改变上传文件最大值;

1、**1.4版本之前配置方式：**

   multipart.maxFileSize=2000Mb

   multipart.maxRequestSize=2500Mb

2、**1.4版本后修改为:**

   spring.http.multipart.maxFileSize=2000Mb

   spring.http.multipart.maxRequestSize=2500Mb

3、**2.0版本之后修改该为:**

 spring.http.multipart.max-file-size=2000Mb

 spring.http.multipart.max-request-size=2500Mb

方式二：在启动类 Application中添加配置，我是采取这种方式解决的。

1.给该类添加@Configuration 注解，

2.在该类中添加该方法；

```java
@Bean
public MultipartConfigElement multipartConfigElement() {
    MultipartConfigFactory factory = new MultipartConfigFactory();
    //文件最大
    factory.setMaxFileSize("10240KB"); //KB,MB
    /// 设置总上传数据总大小
    factory.setMaxRequestSize("102400KB");
    return factory.createMultipartConfig();
}
```

##### 39.Could not resolve view with name 'xxxxxxxxxxx' in servlet with name 'dispatcherServlet'"

**出现该异常的原因：**由于我的请求参数比较多，于是把它们封装成一个类，然后又在.mapper文件中引用了该类；而且Controller类用@Controller注解的；

**解决方式：**

给Controller类添加@RestController注解；

###### @Controller与@RestController区别如下

@RestController is a stereotype annotation that combines @ResponseBody and @Controller.

##### 40. **FileUploadBase$FileSizeLimitExceededException: The field file exceeds its maximum permitted size of ...**

**出现原因：**上传的文件大小超过最大限制

解决方式：

在你的Application入口类中加入，multipartConfigElement方法

```java
/**
 * 设置文件上传最大值
 *
 * @return
 */
@Bean
public MultipartConfigElement multipartConfigElement() {
    MultipartConfigFactory factory = new MultipartConfigFactory();
    //文件最大
    factory.setMaxFileSize(DataSize.of(50, DataUnit.MEGABYTES)); //MB
    /// 设置总上传数据总大小
    factory.setMaxRequestSize(DataSize.of(70, DataUnit.MEGABYTES));
    return factory.createMultipartConfig();
}
```

##### 41.**在使用mybatis-generator:generate自动生成Dao和Mapper文件时报异常： Failed to execute goal org.mybatis.generator:mybatis-generator-maven-plugin:1.3.2:generate (default-cli) on project XXX: <properties> resource datasource.properties does not exist** 

原因：无法找到对应<properties> resource文件.

解决方法：在pom.xml文件中加入

```xml
    <build>
     
        <resources>
            <resource>
                <directory>src/main/java</directory>
                <includes>
                    <include>**/*.xml</include>
                </includes>
                <filtering>true</filtering>
            </resource>
 
            <resource>
                <directory>src/main/resources</directory>
                <includes>
                    <include>**/*.properties</include>
                </includes>
            </resource>
        </resources>
 
    </build>
```

