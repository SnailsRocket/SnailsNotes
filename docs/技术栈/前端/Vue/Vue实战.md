## Vue实战

### 参考资料

> https://blog.csdn.net/xwxyxxubo/article/details/108419591
>
> https://www.cnblogs.com/pywjh/p/13914374.html   pywjh



### 页面渲染流程

> 1.用户通过链接，访问网页，
>
> 2.首先(不管根目录下有没有index.html)执行main.js(跟后端一样main都是程序执行的入口)
>
> 3.main.js里面有一个路由拦截，只允许访问login.vue 这个页面，如果store里面有user，那么运行继续访问，里面还创建了一个Vue实例，里面加载了 route store ,以及Vue 组件渲染
>
> 4.



main.js

```vue
Vue.prototype.postRequest = postRequest;
Vue.prototype.postKeyValueRequest = postKeyValueRequest;
Vue.prototype.putRequest = putRequest;
Vue.prototype.deleteRequest = deleteRequest;
Vue.prototype.getRequest = getRequest;
Vue.config.productionTip = false

// 这个方法就是一个路由拦截，当用户输入url的时候，判断是否是/(进入login界面)，不是就判断是否有登录过
// to 表示将要进入的路由对象  from 表示即将离开的路由对象  next是继续跳转还是中断的方法
router.beforeEach((to, from, next) => {
    if (to.path == '/') { // to 和 from 都是 Route 类型的
        next();
    } else {
        if (window.sessionStorage.getItem("user")) {
            initMenu(router, store); // 发送 get请求到 SystemConfigController 
            next();
        } else {
            next('/?redirect=' + to.path); // 重定向
        }
    }
})
// 实例化一个 vue 对象，在 mount 生命周期就渲染，页面首先执行main.js
new Vue({
    router, // 路由
    store, //根据实例化存储，子组件通过 this.$store 访问
    render: h => h(App) // App组件渲染,这里的h即是 vm.$createElement
}).$mount('#app')
```



route.js

```javascript
export default new Router({
    routes: [
        {
            path: '/',
            name: 'Login',
            component: Login,
            hidden: true
        }, {
            path: '/home',
            name: 'Home',
            component: Home,
            hidden: true,
            meta: {
                roles: ['admin', 'user']
            },
            children: [
                {
                    path: '/chat',
                    name: '在线聊天',
                    component: FriendChat,
                    hidden: true
                }, {
                    path: '/hrinfo',
                    name: '个人中心',
                    component: HrInfo,
                    hidden: true
                }
            ]
        }, {
            path: '*',
            redirect: '/home'
        }
    ]
})
```



app.vue

```vue
<template>
  <div id="app">
    <!-- 路由匹配到的组件将显示在这里-->
    <router-view/>
  </div>
</template>
```



