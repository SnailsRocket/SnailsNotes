## git

### 注意

> git 命令 需要在.git同级目下下敲
>
> 目前我们使用到的 Git 命令都是在本地执行，如果你想通过 Git 分享你的代码或者与其他开发人员合作。 你就需要将数据放到一台其他开发人员能够连接的服务器上
>
> 要添加一个新的远程仓库，可以指定一个简单的名字，以便将来引用,命令格式如下
>
> ```html
> git remote add [shortname] [url]
> ```
>
> 



### git工作流程

* 克隆 Git 资源作为工作目录。
* 在克隆的资源上添加或修改文件。
* 如果其他人修改了，你可以更新资源。
* 在提交前查看修改。
* 提交修改。
* 在修改完成后，如果发现错误，可以撤回提交并再次修改并提交。



### 流程图

![git工作流程图](.\giteorkprogress.PNG)



### 工作区，暂存区，版本库

* **工作区：**就是你在电脑里能看到的目录。
* **暂存区：**英文叫stage, 或index。一般存放在 ".git目录下" 下的index文件（.git/index）中，所以我们把暂存区有时也叫作索引（index）。
* **版本库：**工作区有一个隐藏目录.git，这个不算工作区，而是Git的版本库。



### 暂存区与版本库之间关系

![暂存区与版本库](.\tempalte%26repository.PNG)



### git创建仓库

> git init / git init newrepo
>
> git add *.c
>
> git add README
>
> git commit -m '初始化项目版本'
>
> git clone <repo url>



### git基本操作

> git init
>
> git clone
>
> git add  将文件添加到缓存区中
>
> git status
>
> git diff    来查看执行git status 的结果的详细信息
>
> git diff --cached
>
> git diff HEAD
>
> git diff --stat
>
> git commit  将缓存区中的内容添加到仓库中
>
> git reset HEAD
>
> git rm 删除
>
> git rm -f  强制删除
>
> git rm --cached <file>  从缓存区中移除，但是保留在工作目录
>
> git mv  移动或重命名一个文件



### 分支管理

> git branch  (branchname)  创建分支
>
> git checkout (branchname)  切换分支
>
> git merge  合并分支
>
> git branch  列出分支
>
> git branch -d (branchname)



### git查案提交记录

> git log



### 常用操作

> git add --all
>
> git commit -m  ""
>
> git push
>
> git status   // 查看工作区中新增或修改的文件



## SVN

### svn的概念

* **repository（源代码库）:**源代码统一存放的地方

* **Checkout（提取）:**当你手上没有源代码的时候，你需要从repository checkout一份

* **Commit（提交）:**当你已经修改了代码，你就需要Commit到repository

* **Update (更新):**当你已经Checkout了一份源代码， Update一下你就可以和Repository上的源代码同步，你手上的代码就会有最新的变更

  > 如果两个程序员同时修改了同一个文件呢, SVN 可以合并这两个程序员的改动，实际上SVN管理源代码是以行为单位的，就是说两个程序员只要不是修改了同一行程序，SVN都会自动合并两种修改。如果是同一行，SVN 会提示文件 Conflict, 冲突，需要手动确认

  

