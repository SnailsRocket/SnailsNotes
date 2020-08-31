### git冲突解决

当user1 update mavenclean.class 中的23行并commit push到master分支上面，然后user2也update mavenclean.class 中的23行，user1跟user2修改的内容不一样。当合并分支的时候，git不知道使用谁的代码，所以一般遇到这种问题，找到发生冲突的文件，然后两个人进行校对。



git基本命令

>git init
>
>git clone url
>
>git status (-s)
>
>git diff
>
>git rm -f
>
>git mv
>
>git rm --cached
>
>git add --all
>
>git commit -m ""
>
>git push
>
>git branch (name)
>
>git checkout
>
>git merge
>
>git branch -d
>
>git log



#### 强制覆盖本地的版本库(当本地版本库与远程版本库有同名的文件，远程版本库会覆盖本地版本库)

```java
git fetch --all && git reset --hard origin/master && git pull
```

或者执行这三个命令

git fetch --all  // 拉取所有更新，不同步；

git reset --hard origin/master  //本地代码同步线上最新版本(会覆盖本地所有与远程仓库上同名的文件)；

git pull  //再更新一次（其实也可以不用，第二步命令做过了其实）





下面这个异常的原因是因为，我想将远程版本库pull到本地，但是我本地的版本库不是远程master分支的上一个版本(就是我update文件后并没有push上去，然后另一个用户又将自己的update的文件push到远程库的master分支，然后我pull远程库的master的时候，git不知道是否将当前的文件覆盖掉，)

```java
error: Your local changes to the following files would be overwritten by merge:
        src/main/java/com/newbee/mall/interceptor/NewBeeMallLoginInterceptor.java
```

上面这个异常的解决办法

git reset --hard // 回退到上一个版本

git pull // 拉取代码

