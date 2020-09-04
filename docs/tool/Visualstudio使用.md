### Visual studio 使用技巧

#### nuget package  reference  问题

从SVN上面clone Api 然后save solution ，然后依次添加model、service，这个时候如果你的reference都是黄色的小三角，那么这个就是你的依赖有问题。打开nuget package，将Autofac  install 一下，然后如果还有黄色三角，就找出依赖(一般都是dll文件)，先remove，然后add(公司封装的dll放在c->program file -> compal里边)，



#### 运行项目

> 这个项目，Controller 依赖  service   
>
> service   依赖   model
>
> 所以我们就先build  model，然后依次build完，
>
> 然后run

