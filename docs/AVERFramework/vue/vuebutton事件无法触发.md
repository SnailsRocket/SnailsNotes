### Vue项目中使用button绑定click事件，事件无法触发methods中的方法解决办法

#### 事故还原

> 小胖做完公司的项目，老大看着小胖疲惫的脸庞，有点心疼小胖，就给小胖放了三天假，没有给小胖新的需求。小胖平常主要是写的后端，但是最近跟小顺子有点聊技术，小顺子经常把Vue挂在嘴边，小胖有点不服气，正好最近也有时间，打算利用这三天把Vue入个门，但是刚开始就把小胖给难住了，小胖写了一个button，并绑定了click点击事件，但是发现无法触发methods中的but方法，异常提示信息大致的意思是but_ajax未定义。



浏览器console显示异常信息



```html
but_ajax is not defined
    at HTMLButtonElement.onclick
```



出了bug但是小胖的内心毫无波动，脑袋里想起了公司架构师老王经常说的一句话，遇到bug不要慌，解bug才是程序员最快的成长方式(但是下面遇到了三个基础性的错误小胖还是有点尴尬的)



端口绑定异常，这个异常说明就是端口已经被绑定了(后端是我之前写好的，我准备将端口改成4200，但是4200已经在运行angular)

```html
java.net.BindException: Address already in use: bind
```



#### 跨域问题 

这个项目前端的路径是localhsot:63342 ,然后后端的路径的localhost:28089 ,前端发送ajax的时候url路径需要带上接口，这个是跨域必须的，然后后端需要配置跨域信息(添加注解@CrossOrigin(origin={"前端的url"})，或者编写一个config类)



#### vue button (特别注意) 犯了一个很沙雕的错误，浪费一个小时

> vue 中button 的点击事件  
>
> ```javascript
> <button v-on:click="but_click">发送请求</button>
> ```
>
> js 中 button点击事件
>
> ```javascript
> <button onclick="but_click">发送请求</button>
> ```
>
> 刚开始小胖犯了一个很沙雕的错误，在vue的methods中定义一个点击事件的方法，但是在<button> 中 使用的是js的onclick事件，所以就出现找不到method，js的点击事件对应的方法，直接写在script中，放在methods中不会被识别
>
> ```javascript
> <script>
> 	but_ajax = function() {
>     $.get(url).then(response => {
>         this.tableData = response;
>     })
> }
> </script>
> ```
>
> 





### userData is not defined

> 在 data中定义了 userData ，但是出现异常如下,异常信息说明userData没有定义，但是我们明明在data中定义过了，小胖我思前想后，发现我又写了一个沙雕的bug，userData是vue对象中的data里面定义的，要想使用，必须使用this关键字，this指代的是vue对象。



```html
Uncaught ReferenceError: userData is not defined
```



![data定义数组异常](D:\gitproject\github\SnailsNotes\docs\AVERFramework\vue\img\data定义数组异常.PNG)



### 总结

> 写一个简单的vue 按钮，出现了跨域、vue与js的点击事件混用、vue中data的调用，这三个bug，你对一些基础知识的理解差很多，平常还是需要多敲，看似简单的需求，居然花了两个小时找bug，至此Vue算是彻底入门，但是后面的路还有很长。