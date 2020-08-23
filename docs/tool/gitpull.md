## git 远程分支代码强制覆盖本地代码

### 需求

> 把远程分支的代码强制覆盖到本地



### 错误示例

```java
git clone url
```

> 会出现提示本地已经存在， clone失败，除非删除重新clone，但是每次都这样做费时



### 解决

```java
git fetch --all
# 从远程获取最新版本到本地，不会merge
git reset --hard origin/master
# --hard origin/<master> master指定远程的分支为master
git pull
# 从远处获取最新版本并merge到本地

```

