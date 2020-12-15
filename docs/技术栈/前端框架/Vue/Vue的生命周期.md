## Vue的生命周期

**参考  https://segmentfault.com/a/1190000008010666**

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





