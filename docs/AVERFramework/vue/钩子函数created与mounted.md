## 钩子函数

#### vue2.0生命周期

> beforeCreate
>
> created
>
> beforeMounted
>
> mounted
>
> beforeUpdate
>
> update
>
> activated
>
> deactivated
>
> beforeDestory
>
> destoryed



created 在 mounted前面执行，两者都是对数据进行初始化处理的。

根据官方解释，created是在实例创建完成后被立即调用，这个时候模板还没有被渲染成html，也就是说，这个时候通过id去查找页面元素是找不到的

![created1](D:\gitproject\github\SnailsNotes\docs\AVERFramework\vue\img\vuecreated1.PNG)



下面这个错误就是找不到id为name的dom元素(这个时候模板还没渲染成html)，所以，一般created钩子函数主要是用来初始化数据

![created2](D:\gitproject\github\SnailsNotes\docs\AVERFramework\vue\img\vuecreated2.PNG)



mounted钩子函数一般是用来向后端发起请求拿到数据以后做一些业务处理。(在模板渲染完成才被调用)

![mounted](D:\gitproject\github\SnailsNotes\docs\AVERFramework\vue\img\vuemounted1.PNG)



![mounted2](D:\gitproject\github\SnailsNotes\docs\AVERFramework\vue\img\vuemounted2.PNG)







### Created

> Created 是完成页面数据初始化的，一般页面需要显示的数据，放在created中，注意这个时候模板数据还没渲染成html



### mounted

> mounted 函数是在模板被渲染成html之后才被调用的，但凡涉及到document的操作都要放在mounted这个钩子函数中。

