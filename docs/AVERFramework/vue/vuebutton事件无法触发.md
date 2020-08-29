### Vue项目中使用button绑定click事件，事件无法触发methods中的方法解决办法

#### 事故还原

> 小胖做完公司的项目，老大看着小胖疲惫的脸庞，有点心疼小胖，就给小胖放了三天假，没有给小胖新的需求。小胖平常主要是写的后端，但是最近跟小顺子有点聊技术，小顺子经常把Vue挂在嘴边，小胖有点不服气，正好最近也有时间，打算利用这三天把Vue入个门，但是刚开始就把小胖给难住了，小胖写了一个button，并绑定了click点击事件，但是发现无法触发methods中的but方法，异常提示信息大致的意思是but_ajax未定义。



浏览器console显示异常信息



```html
but_ajax is not defined
    at HTMLButtonElement.onclick
```



出了bug但是小胖的内心毫无波动，脑袋里想起了公司架构师老王经常说的一句话，遇到bug不要慌，解bug才是程序员最快的成长方式(但是下面遇到了三个基础性的错误小胖还是有点尴尬的)



端口绑定异常，这个异常说明就是端口已经被绑定了(后端是我之前写好的，我准备将端口改成4200，但是4200已经在运行angular项目)

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



![data定义数组异常](https://github.com/SnailsRocket/SnailsNotes/blob/master/docs/AVERFramework/vue/img/data%E5%AE%9A%E4%B9%89%E6%95%B0%E7%BB%84%E5%BC%82%E5%B8%B8.PNG)



#### Vue的第四个bug  钩子函数(mounted/created)

> 小胖有一个想法，就是在页面加载的时候，直接发送ajax请求，然后将数据显示在table中(table 是使用的el-table ElementUI的组件)，小胖想着钩子函数也是一个method，所以想当然的把created(mounted) 放在methods里面，结果发现没有效果，这个时候小胖想肯定是钩子函数没有执行，应该是没有被浏览器识别，小胖就直接怀疑钩子函数是不是放错位置了，小胖试着将钩子函数(mounted/created)跟el、data、methods放在同一级，然后重新启动项目，效果出来了。



#### Vue的第五个bug

> 钩子函数发送ajax获取数据，放回到表单中，这里有一个明显的延时，数据要过将近1s才显示，出现过两次，后面基本上在200ms左右，这里因为我的element.css elementui.js以及vue.js都是在放在本地，不是去请求网络，所以速度稍微快一点。(如果面试问道怎么优化页面响应速度的话，可以说将js,css文件使用min版的，然后使用离线文件，(一般企业开发，开发阶段可能使用网络文件，但是生产环境都是使用离线文件))



![Vue页面响应时间](D:\gitproject\github\SnailsNotes\docs\AVERFramework\vue\img\ElementUI&Vue页面响应时间.PNG)





### 总结

> 写一个简单的vue 按钮，出现了跨域、vue与js的点击事件混用、vue中data的调用，这三个bug，发现对一些基础知识的理解差很多，平常还是需要多敲，多敲确实可以快速成长，但是需要将基础的东西过一遍再去敲，去琢磨才可以事半功倍，看似简单的需求，居然花了两个小时找bug，至此Vue算是迈进了门，但是后面的路还有很长。