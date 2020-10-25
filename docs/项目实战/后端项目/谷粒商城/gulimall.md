## 谷粒商城

 ### 部署环境

>  谷粒的环境都是部署在docker容器里面，暂时只部署了mysql、redis、mongo、RabbitMQ、RocketMQ
>
> 在 centos7 中安装 docker  yum isntall -y docker
>
> 然后 docker pull mysql/redis/mongo.rabbitmq
>
> 远程连接这个容器。



### 版本冲突问题

https://blog.csdn.net/Ajax_mt/article/details/79152581

> mybatis-plus 版本是 3.3.1   

直接原因 不能实现bean初始化

间接原因 版本冲突

降低mybatis-plus的版本