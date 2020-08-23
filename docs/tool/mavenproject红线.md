## maven导入包时出现的异常(pom文件中project处红线)

### Scenes1

#### 在pom文件中添加依赖的时候，因为网络的问题，然后pom文件中该依赖就是一条红线

分析解决

> pom文件中添加的依赖是通过中央仓库远程下载的，因为网络波动等原因，导致下载失败生成了后缀为lastUpdated的文件，直接使用mavenclean这个工具类删除掉仓库中的lastUpdated文件，重新下载行了。



[maven更换阿里云仓库](https://github.com/SnailsRocket/SnailsNotes/blob/master/docs/tool/mavensettingaliyun.md)





### Scenes2

#### 用IDEA 中的Maven打开pom文件这种方式打开项目，maven直接异常,全是红线

> 使用mavenclean 删除掉mavenrepository中所有的lastupdate文件及空文件夹，然后重新导入还是没用该异常还是异常



[mavenclean工具类](https://github.com/SnailsRocket/SnailsNotes/blob/master/docs/tool/mavenclean.md)



##### 处理方案 1

> 首先不要慌 ，选中reimport键，reimport一下，如果还是红，就点击 invalidate caches/restart  重启IDEA，基本上这波操作，大部分maven问题都可以解决。



##### 处理方案 2 

> 如果上面的那波操作不行，看一下maven的配置是不是指向本地的，然后run mavenclean这个类，将本地仓库里面的缓存清一下，再reimport，然后重复invalidate caches/restart,





