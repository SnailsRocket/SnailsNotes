## Navicat连接Mysql失败 错误码1045

### 问题复现

**前段时间因为chrome经常崩溃的原因，就刷新了电脑的系统，重新安装环境的时候，发现安装Cnetos7 docker容器中的mysql出现了一点小问题。安装完成Navicat连接不上**



### 查找并解决问题

1.首先根据错误码 1045 推断出就是密码错误导致的Navicat 连接不上

2.但是我在SecurityCRT中输入密码登录却可以进去，（这个时候我就把密码错误这个想法给推翻了，导致后面卡了我一下午）

3.因为是刚装的环境。我不确定我配置有没有问题，可能因为端口映射等原因导致的，我就试了下Redis的连接，发现连接的是如此的丝滑。

4.这个检查完我所有的推想，发现没有一个有问题，这个时候我的内心是崩溃的。然后我就去google，发现所有说1045 绝对是密码问题

5.然后我内心冒出了一个想法，会不会同一个账号远程跟本地的密码可以设置不一样，然后我就输入了下面的命令，发现远程密码并不是之前本地登录的那个，后面就是update 远程密码，navicat就可以登录了。

在SecurityCRT中输入下面的命令

```powershell
docker exec -it mysql bash -- 进入mysql命令模式
# mysql -uroot -p
密码
use mysql;
select host,user,authentication_string from user;
```

![](E:\github\SnailsNotes\docs\技术栈\bug汇总\数据库\mysql\mysql.user表.PNG)







