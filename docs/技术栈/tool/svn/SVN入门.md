### SVN 入门教程

#### 1.安装SVN

##### 1.1安装完成后，在电脑中新建一个文件夹，用来存放clone下来的代码。

![SVN Checkout](D:\gitproject\github\SnailsNotes\docs\技术栈\tool\svn\img\SVN1.PNG)

如果你右键出现如上的图标，就说明你SVN安装成功了！

##### 1.2 使用checkout下载项目

先简单介绍几个基本的命令

> Checkout(相当于git的clone)：SVN仓库的代码下载到本地，比如你现在参与一个团队的项目，在你参与之前项目可能已经在运行或者技术主管也已经搭建好代码仓库，你可以通过checkout命令项目代码，获取相应的项目的代码。
>
> Update(pull)：在你编写代码的过程中，项目参考者很可能已经提交过代码到SVN服务器，而你本地项目都是自己编写，肯定没有其他参与者新提交的代码，你可以通过update SVN获得SVN最新的代码。
>
> Commit：当你完成一部分开发后并且程序中没有其它的错误，你可以通过commit提交代码到SVN服务器，服务器会产生一个新的版本，这样其它参与者就可以获取到您相应提交的代码。重要提示：每次必须先先update再Commit。(有一个问题，如果其他参与者update的代码，你在本地也修改过，那么update的时候，仓库的代码 覆盖你的代码吗，还是update失败？)

Checkout命令使用图解

右键 --> Svn Checkout -->

步骤1：在URL of repository输入 {项目地址}

![checkout](D:\gitproject\github\SnailsNotes\docs\技术栈\tool\svn\img\checkout.PNG)

步骤2 ： 如果有提示输入账号输入账号密码就可以下载项目代码到本地了。

![svn登录](D:\gitproject\github\SnailsNotes\docs\技术栈\tool\svn\img\login.PNG)

![checkout_success](D:\gitproject\github\SnailsNotes\docs\技术栈\tool\svn\img\checkout_success.PNG)

##### 注意事项

  ***\*打开下载的目录\****.svn这个隐藏目录记录着两项关键信息：工作文件的基准版本和一个本地副本最后更新的时间戳，千万不要手动修改或者删除这个.svn隐藏目录和里面的文件!!,否则将会导致你本地的工作拷贝(静态试图)被破坏，无法再进行操作。

1. \***TortoiseSVN图标介绍\***
2. ***\*新加的文件未加入版本管理的\**** ![](D:\gitproject\github\SnailsNotes\docs\技术栈\tool\svn\img\readme_md.png)
3. ***\*新加的文件已加入版本管理的\****![](D:\gitproject\github\SnailsNotes\docs\技术栈\tool\svn\img\readme_md1.png)
4. ***\*已经加入版本管理并已经提交到服务器的\****![](D:\gitproject\github\SnailsNotes\docs\技术栈\tool\svn\img\readme_md2.png)
5. ***\*修改过的文件未提交到服务器的\****![](D:\gitproject\github\SnailsNotes\docs\技术栈\tool\svn\img\readme_md3.png)
6. ***\*冲突的文件，多人同时修改了该文件\****![](D:\gitproject\github\SnailsNotes\docs\技术栈\tool\svn\img\readme_md4.png)

#### 2.Add命令图解

以下是我新加的文件，是没有图标的，相当这个文件已经创建了，但没有归属到SVN代码管理中

![add](D:\gitproject\github\SnailsNotes\docs\技术栈\tool\svn\img\add.PNG)

选中文件右键出现如下菜单，把文件加到SVN代码管理中

![add2](D:\gitproject\github\SnailsNotes\docs\技术栈\tool\svn\img\add2.PNG)

下面是加进去的图标，明显文件上多了一个图标+号，至此文件只是加到了SVN中，但还没有提交到SVN服务器。

![add3](D:\gitproject\github\SnailsNotes\docs\技术栈\tool\svn\img\add3.PNG)



同样是选中文件右键，功能菜单和上次的菜单已经不一样了，因为该文件已经加入到SVN代码管理中了

![add4](D:\gitproject\github\SnailsNotes\docs\技术栈\tool\svn\img\add4.PNG)

#### 3.Commit命令图解

当我们代码编写完了，把代码提交到服务器可以通过Commit 来提交代码，注意要先更新再提交

![commit](D:\gitproject\github\SnailsNotes\docs\技术栈\tool\svn\img\commit.PNG)



下图是提交完后的文件图标

![commit1](D:\gitproject\github\SnailsNotes\docs\技术栈\tool\svn\img\commit1.PNG)

如果你修改了代码文件，状态就变成了已修改，而图标重载已变成了红色感叹号，你可以很容易地看出那些文件从你上次更新工作复本被修改过，且需要提交

![commit2](D:\gitproject\github\SnailsNotes\docs\技术栈\tool\svn\img\commit2.PNG)



#### 4.查看所修改的文件

> 右键 -> TortoiseSVN -> Show log  // 查看我们的提交记录



#### 5. 过滤掉不想提交到SVN服务器的文件或者文件夹

> 右键  -> setting 在 ignore pattern 中填写类似*.jpg (不提交。jpg格式的图片)、
>
> ```html
> */images/*  不提交images目录
> ```
>
> 