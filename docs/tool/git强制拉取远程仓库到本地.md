
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

![git流程图](D:\gitproject\github\SnailsNotes\docs\tool\git工作区.JPG)

git add 是将新建的文件加入到暂存区--->Staged
git commit -m 将暂存区的文件提交到本地仓库--->Unmodified
如果对Unmodified状态的文件进行修改---> modified
如果对Unmodified状态的文件进行remove操作--->Untracked
add commit 都是对本地仓库的数据进行更改，只有push才会提交到远程仓库。

#### 特别注意
提交到远程仓库的时候一般都是提交到自己新建的分支，如果你提交到master/origin 你就抱着你的电脑出门左拐。然后合并代码(merge)的时候如果有冲突，就一定要拉上那个文件有冲突的anthor 进行冲突解决，
#### 解决冲突
拉上有冲突文件的author ，一般编译器，像IDEA，有一个功能就是可以diff可以对比两个文件有那个地方不一致，然后选择一个版本，删除掉不一样的地方。
