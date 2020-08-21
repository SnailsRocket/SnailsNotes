## Angular + SpringBoot 项目跨域问题

​	由于项目的需要，最近一段时间都在学习Angular，正好之前无聊写了一个后端的CRUD的demo，索性就将前后端整合起来。

​	整体的思路是，前端由Angular发送一个get请求(import  HttpClient组件)，请求通过Http，发送到Controller层，然后途经三层架构，访问数据库。然后后端返回的json数据发给前端解析。本以为这个demo特别简单，没有什么技术难点，逻辑也不复杂。结果在前端发送get请求的时候出了问题，但是身经百战的小编内心毫无波动。直接F12查看Console，有没有Exception，果不其然，异常见下 (CORS policy)  在跨域这个地方出了问题。



	#### CORS 

> ```
> Cross-Origin Resource Sharing
> ```
>
> 意为跨域资源共享,当一个资源去访问另一个不同域名或者同域名不同端口的资源时，就会发出跨域请求。如果此时另一个资源不允许其进行跨域资源访问，那么访问的那个资源就会遇到跨域问题。



##### 同源策略的保护

> 源(origin)：就是协议(http)、域名(localhost)、端口号(8080)
>
> 当源不同的时候就算跨域，就算仅仅只是端口号不同，跨域微服务架构中常见问题，如果没有配置跨域，请求就会失败。



##### 跨域解决

1、在controller上加注解

``` java
@CrossOrigin(origins = {"http://localhost:4200","null"})
```

2、全局配置

```java
package com.example.Default;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * Created by BLIT on 2020/8/19.
 */
@Configuration
@EnableWebMvc
public class CorsConfig implements WebMvcConfigurer {

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        //设置允许跨域的路径
        registry.addMapping("/**")
                //设置允许跨域请求的域名
                .allowedOrigins("*")  //也可以指定域名 .allowedOrigins("http://192.168.0.0:8080","http://192.168.0.1:8081")
                //是否允许证书 不再默认开启
                .allowCredentials(true)
                //设置允许的方法
                .allowedMethods("*")
                //跨域允许时间
                .maxAge(3600);
    }

}
```



##### 出现问题原因

> 看了上面那段跨域的介绍，就知道了，我前段项目的访问地址是localhost:4200，后端提供的访问接口是localhost:28089，这里端口号不一样，所以出现同源跨域问题，需要使用上面两种方法中的一种，建议第二种，方便快捷。



```html
Access to XMLHttpRequest at 'http://localhost:28089/user/list' from origin 'http://localhost:4200' has been blocked by CORS policy: No 'Access-Control-Allow-Origin' header is present on the requested resource
```



#### 总结

> 出现问题不要慌，解决问题就三板斧，第一步，快速定位问题；第二步分析问题；第三部选出最优的解决方案。最重要还有一点，尽量避免下次再遇到类似的问题