## Vue的生命周期

**参考  https://segmentfault.com/a/1190000008010666**

### 生命周期

> 从vue实例创建、运行、到销毁期间，总是伴随着各种各样的事件，这些事件，在Vue中称为生命周期
>
> 钩子函数：就是生命周期事件的别名



### BeforeCreate

> element 和 data 都没有初始化



### Created

> 完成了data的 初始化，但是element 没有初始化



### BeforeMount

> 完成了element 和 data 的初始化



### Mounted

> 完成挂载



### BeforeUpdate

> data里面的值被修改后会触发BeforeUpdate操作



### Updated

> 表示更新DOM完成



### BeforeDestory

> 确认Vue被销毁



### Destoryed

> Vue已经被销毁



![](D:\gitproject\github\SnailsNotes\docs\技术栈\前端框架\Vue\Vue生命周期.png)



 ```javascript
<script>
  var app = new Vue({
    el: '#app',
    data: {
        message : "Druid is cool"
    },
    // 页面加载的时候，前面四个钩子函数已经被加载，一般加载页面参数，是写在created 这个钩子函数里面
    beforeCreate() {
        console.group('beforeCreate创建前的状态=============');
        console.log("%c%s","color:red","el    : "+this.el);
        console.log("%c%s","color:red","data    : "+this.data);
        console.log("%c%s","color:red","message    : "+this.message);
    },
    created() {
        console.group('Created创建前的状态=============');
        console.log("%c%s","color:red","el    : "+this.el);
        console.log("%c%s","color:red","data    : "+this.data);
        console.log("%c%s","color:red","message    : "+this.message);
    },
    beforeMount() {
        console.group('BeforeMount创建前的状态=============');
        console.log("%c%s","color:red","el    : "+this.el);
        console.log("%c%s","color:red","data    : "+this.data);
        console.log("%c%s","color:red","message    : "+this.message);
    },
    mounted() {
        console.group('Mounted创建前的状态=============');
        console.log("%c%s","color:red","el    : "+this.el);
        console.log("%c%s","color:red","data    : "+this.data);
        console.log("%c%s","color:red","message    : "+this.message);
    },
    // 当修改message时，触发该钩子函数 app.message='Druid is a cool boy';
    beforeUpdate() {
        console.group('beforeUpdate创建前的状态=============');
        console.log("%c%s","color:red","el    : "+this.el);
        console.log("%c%s","color:red","data    : "+this.data);
        console.log("%c%s","color:red","message    : "+this.message);
    },
    // DOM渲染完成之后触发updated函数
    updated() {
        console.group('updated创建前的状态=============');
        console.log("%c%s","color:red","el    : "+this.el);
        console.log("%c%s","color:red","data    : "+this.data);
        console.log("%c%s","color:red","message    : "+this.message);
    },
    // 执行 app.$destroy(); 销毁Vue DOM还在，但是Vue不能控制DOM
    beforeDestroy() {
        console.group('beforeDestory创建前的状态=============');
        console.log("%c%s","color:red","el    : "+this.el);
        console.log("%c%s","color:red","data    : "+this.data);
        console.log("%c%s","color:red","message    : "+this.message);
    },
    destroyed() {
        console.group('destory创建前的状态=============');
        console.log("%c%s","color:red","el    : "+this.el);
        console.log("%c%s","color:red","data    : "+this.data);
        console.log("%c%s","color:red","message    : "+this.message);
    }
  })
</script>
 ```



![](D:\gitproject\github\SnailsNotes\docs\技术栈\前端框架\Vue\vue生命周期1.PNG)





![](D:\gitproject\github\SnailsNotes\docs\技术栈\前端框架\Vue\vue生命周期2.PNG)





![](D:\gitproject\github\SnailsNotes\docs\技术栈\前端框架\Vue\vue生命周期3.PNG)