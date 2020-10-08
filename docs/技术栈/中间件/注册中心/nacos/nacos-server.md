### 本地跑nacos-server 踩坑日记

#### 首先 去官网下载 Nacos的压缩包 

[Nacos官网](https://github.com/alibaba/nacos/releases)

#### 搭建环境

然后解压文件，进入 conf，将里面的nacos_config.sql，执行sql脚本。在nacos目录下面建一个plugins 里面放 mysql驱动 的 jar

#### 修改配置文件

[参考1](https://blog.csdn.net/yankun01/article/details/108750657?utm_medium=distribute.pc_aggpage_search_result.none-task-blog-2~all~first_rank_v2~rank_v25-1-108750657.nonecase&utm_term=%E6%9C%AC%E5%9C%B0%E5%90%AF%E5%8A%A8nacos%E9%97%AA%E9%80%80&spm=1000.2123.3001.4430)

[参考2](https://blog.csdn.net/sx1999aaa/article/details/108253612)

> application.properties
>
> cluster.conf

#### 然后启动 startup.cmd



#### 注意

##### 这个里面有几个坑

**1.** jdbcUrl 只能写在一行， 不然启动报错 jdbc properties error

**2.**数据库驱动 jar 一般教程都没有提示需要这个

**3.**set MODE="standalone"这个设置看场景 一般是 cluster

**4.**登录页面 http://localhost:8848/nacos  账号密码是 nacos

