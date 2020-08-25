## JavaScript

### 简介

javascript 是一个为网页交互的脚本语言，运行在网页上面，使网页拥有动态效果



### DOM(document object model)

> 文档对象模型：是针对xml但经过扩展用于HTML的应用编程接口，
>
> DOM
>
> 把整个页面映射为一个多层节点结构(html,head,body.div,p,a)
>
> node类型
>
> document类型   getElementById()  getElementByName () getElementByTagName()
>
> Element类型
>
> Text类型



### BOM(borwser object model)

> 浏览器对象模型：提供与浏览器交互的方法和接口
>
> window对象
>
> location对象 提供了与当前窗口中加载的文档有关信息，既是window的属性也是document的属性
>
> navigator对象 浏览器对象，提供浏览器相关对象可以用来检测浏览器插件
>
> Screen对象 表明对浏览器窗口外部的显示器的信息
>
> history对象 存储用户上网的访问记录



### src 引入外部文件

> 这里有一个小技巧，就是head和body后面都可以引入js文件，但是由于一般的js文件相对来说比较大，如果放在head里面，需要加载完js才能显示页面，而放在body下面，就可以先显示页面再加载js文件



### 延迟脚本 defer

> 这个脚本会被延迟到整个页面加载完毕再去执行，这个时候src js 放在head里面也没有关系



### 异步脚本  async

> 这个脚本一定会执行，但是不保证他们执行的顺序



### 语法

#### 注释

```javascript
// 单行注释
/*
 *多行注释
 */
```



#### 关键字



#### 变量

```javascript
<script>
		function test() {
			message = "Druid"; // 定义的是一个全局变量
		}
		test(); // 当调用一次test message就被定义了，然后到处都可以使用message
		alert(message);
	</script>

<script>
		function test() {
			var message = "Druid"; // 定义的是一个局部变量
		}
		test();
		alert(message); // exception console 显示 message未定义
	</script>
```

也可以使用一个var定义多个变量，使用 ',' 分隔	



### 数据类型 typeof操作符

> Undefined
>
> Null
>
> Boolean
>
> Number
>
> String
>
> Object
>
> NaN  Not a Number





### 三目运算符

```javascript
var b = (a>c) ? true : false
```



### break & continue

> break 跳出当前循环
>
> continue 结束本次循环，继续后面的循环



### with

> 将代码的作用域设置到一个特定的对象中

```javascript
// 不适用with
var qs = location.search.substring(1);
var hostName = location.hostname;
var url = location.href;

// 使用with关联了location对象，严格模式下不能使用with，大量使用with会导致性能下降
with(location) {
    var qs = search.substring;
    var hostName = hostname;
    var url = href;
}
```



### 基本类型 与 引用类型

> 基本数据类型：(注意在很多编程语言中将String当做引用数据类型)
>
> Undefined  Null  Boolean  Number String



> 引用数据类型：
>
> Object  ： 基类
>
> Array ECMAscript中的数组与其他语言中的数组区别很大，数组的大小可以动态改变，而且可以第一个存储数字，第二个存储对象
>
> Date类型
>
> RegExp 正则表达式  p103
>
> Function 函数也是对象，注意没有方法的重载，(在JavaScript的全局函数this代表的就是window对象)
>
> 基本包装类 Boolean  Number String
>
> 单体内置对象 eg;(内置对象Object Array String)  (单体内置对象 global math)



#### eval()

> eval() 函数可计算某个字符串，并执行其中的的 JavaScript 代码。



### 垃圾收集

> JavaScript 有自动的的圾回机制

####  标记清除

> 将需要回收的对象，一个个的标记出来，然后依次清除，但是这样就会有一个问题，就是很多对象不是集中在一块区域，这样就会导致内存碎片化，这就衍生出了第二个算法，标记压缩算法

#### 标记压缩算法

> 将需要回收的对象标记出来，并压缩到左侧区域，然后直接回收左侧区域就可以了，但是这样也有一个问题，GC过程中会将对象压缩到左边去，效率会有点第。

#### 复制算法

> 将不回收的内存复制到一块新内存中，然后直接将之前的旧内存全部回收掉，这样就解决了标记清除带来的内存碎片的问题，但是，始终需要空出来一篇内存区域，用来放不回收的对象，而且如果所有的对象都不回收，就是全复制，这个效率特别低



### 计数策略之循环引用(类似循环依赖) (垃圾回收的一种方式)

> 对象A中包含一个指向对象B的指针
>
> 对象B中包含一个指向对象A的指针
>
> 这两个对象永远都不会被回收



### args

> 在method的参数中，args可以接收多个参数，一个，两个，多个都可以 



### OOP (object Oriented progress)

> ECMAScript中没有类的概念



### 系统对话框

> alert()  弹出提示框
>
> confirm()  确认框 
>
> prompt()  弹出输入框



### 事件

#### 事件流

##### 事件冒泡 

> div --> body --> html  --> document

##### 事件处理函数

> onclick  onload  



#### 事件类型

> UI
>
> 焦点事件
>
> 鼠标事件
>
> 滚轮事件
>
> 文本事件
>
> 键盘事件
>
> 合成事件
>
> 变动



### 表单 form

> submit() 提交
>
> reset()  重置	

#### 表单序列化  serialize



### JSON   javascript  object  notation

> 只是一种序列化数据格式

#### 解析json

> jsoup
>
> JSON.parse()  解析JSON

#### 序列化json

> jsoup
>
> JSON.Stringify()  将 javascript对象序列化成JSON字符串



### Ajax    核心是XMLHttpRequest (简称 XHR)

> 不需要重新加载整个页面，选择性的加载部分数据，效率更高。
>
> 请求方式：get post put delete  head  

 



### cookies  session

>cookies 存储在客户端浏览器
>
>session  存储在server上面
>
