## 高时延

### bug 重现

**使用postwoman向后端的登录接口发出请求，发现响应时间高达460ms，但是第二次请求就正常了(44ms)**



### 问题分析

**高时延只是出现在系统启动后第一次向后端发送请求，会不会是第一次访问需要初始化什么类，导致接口响应时间变长。**

> 看了后端打印的日志信息 ,系统启动后，第一次发送请求，会初始化DispatchServlet

![](D:\gitproject\github\SnailsNotes\docs\项目实战\后端项目\OrderSystem\Initializing Spring DispatcherServlet.PNG)



### 解决问题

系统启动后，手动模拟用户登录，使Spring容器Initializing DispatcherServlet 