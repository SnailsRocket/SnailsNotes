## mall-admin

项目地址

> https://github.com/macrozheng/mall-admin-web



部署指导路径

> http://www.macrozheng.com/#/foreword/mall_foreword_01

​	从github上面clone  mall-admin  的代码，这个是mall的前端代码，可以在IDEA中打开，也可以在VSCode中打开，这里我使用VSCode打开。

​	Ctrl+shift + N 打开一个新窗口，然后open folder，找到mall-admin就可以了。在VSCode中open Console  ，在运行项目之前需要先安装一下相关的依赖 cnpm install ，然后npm run dev，这个前端项目就跑起来了。如果你本地后端项目没有跑起来，这个项目的开发者提供了后端环境 ，打开config文件夹中的dev.env.js文件，将BASE_API改成 http://120.27.63.9:8080/ 就可以了



项目结构

```vue
src -- 源码目录
├── api -- axios网络请求定义
├── assets -- 静态图片资源文件
├── components -- 通用组件封装
├── icons -- svg矢量图片文件
├── router -- vue-router路由配置
├── store -- vuex的状态管理
├── styles -- 全局css样式
├── utils -- 工具类
└── views -- 前端页面
    ├── home -- 首页
    ├── layout -- 通用页面加载框架
    ├── login -- 登录页
    ├── oms -- 订单模块页面
    ├── pms -- 商品模块页面
    └── sms -- 营销模块页面
```