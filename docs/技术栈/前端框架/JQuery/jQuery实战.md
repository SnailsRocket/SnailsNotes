## jQuery

### ready()函数

> 当 DOM（文档对象模型） 已经加载，并且页面（包括图像）已经完全呈现时，会发生 ready 事件
>
> ready() 函数规定当 ready 事件发生时执行的代码。
>
> ready() 函数仅能用于当前文档，因此无需选择器。



```javascript
$(document).ready(function(){
  $(".btn1").click(function(){
    $("p").slideToggle();
  });
});
$(document).ready(function)
$().ready(function)
$(function)
```



### $ 定义 jQuery

