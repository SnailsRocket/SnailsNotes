## Angular常见错误汇总

##### 	刚开始使用Angular2最为前端开发框架时，遇到问题分散在一篇篇博客里面，我现在将我遇到的问题，以及解决方案汇总到一篇博客里面，希望能帮到Angular开发的Coder

#### 1.Type 'UserViewModel' is missing the following properties from type 'UserViewModel[]': length, pop, push, concat, and 26 more

> 分析报错信息：报错上面说UserViewModel 这个类没有定义一些UserViewModel[] 数组的属性length，pop，push等，这就说明，在某个地方，你本来是要用UserViewModel[] 但是 你却用的是 UserViewModel类，所以快速定位到报错行，看是不是定义错了，但是定位到62行，发现定义的是数组。p是返回的json数据，但是get<UserViewModel> 泛型定义的却是一个UserViewModel对象，问题就出现在这，修改过来就好了。



##### 错误写法

```typescript
this.http.get<UserViewModel>("http://localhost:28089/user/list").toPromise().then((p) => {
        this.listOfData = p;
    })
```



##### 正确写法

```typescript
this.http.get<UserViewModel[]>("http://localhost:28089/user/list").toPromise().then((p) => {
        this.listOfData = p;
    })
```





![AngularPropertiesMissing](D:\gitproject\github\SnailsNotes\docs\AVERFramework\Angular\img\angularGetParamTypeException.PNG)



#### 1.1.Can't bind to 'ngClass' since it isn't a known property of 'div'.

解决方案：

```typescript
import {  CommonModule } from '@angular/common';
```



#### 2.ERROR Error: Uncaught (in promise): Error: No provider for Http!

解决方案：

```typescript
providers: [Http]
```



#### 3.ERROR Error: Uncaught (in promise): Error: No provider for ConnectionBackend!

解决：以下答案来自overstackflow

```typescript
Http is redundant in
providers: [FrameService, Http, { provide: $WINDOW, useValue: window }],
because HttpModule in
imports: [HttpModule, BrowserModule, FormsModule],
provides it already.
```



#### 4.ERROR Error: Uncaught (in promise): Error: Template parse errors:Can't bind to 'ngForOf' since it isn't a known property of 'tr'.

解决方案1

```typescript
@NgModule({
  imports: [CommonModule]
})
```

or if you don't mind the module being locked to be browser-only

解决方案2

```typescript
@NgModule({
  imports: [BrowserModule],
})
```



#### 5.implements interface 'OnInit'.Property 'ngOnInit' is missing in type 'BfMenuItem'.

解决：添加 `ngOnInit()` 生命周期



#### 6.Uncaught (in promise): Error: Expected 'styles' to be an array of strings.

解决： 查看styleUrls 样式引入写法是否有问题
错误写法：

```typescript
styleUrls: ['./bf-header-msg.component']   
```

正确写法:

```typescript
styleUrls: ['./bf-header-msg.component.scss'],
```



#### 7.Can't bind to 'routerLink' since it isn't a known property of

解决：

```typescript
 import { RouterModule} from '@angular/router';
```



#### 8.Unexpected closing tag "ba-breadcrumb". It may happen when the tag has already been closed by another tag.

解决：标签没有闭合，或闭合标签错误。



#### 9.ERROR Error: Uncaught (in promise): Error: Template parse errors:'bf-breadcrumb' is not a known element:If 'bf-breadcrumb' is an Angular component, then verify that it is part of this module.

解决：
错误原因1：`declarations: []` 在元数据中声明当前组件
错误原因2：组件元数据中选择器属性和`html`中标签不匹配



#### 10.ERROR Error: Uncaught (in promise): Error: Cannot match any routes. URL Segment: 'pages/demo'

解决：路由配置错误，查看路由配置



#### 11.Error: Unexpected value 'BfbreakcrumbComponent' declared by the module 'BfHomeModule'. Please add a @Pipe/@Directive/@Component annotation.

解决：添加注解 `@Pipe/@Directive/@Component`



#### 12. Can't bind to 'ngModel' since it isn't a known property of 'input'.

解决： 引入FormsModule

```typescript
import { FormsModule} from "@angular/common";
```



#### 13.菜单跳转路由失败的原因。（提示路径不匹配，match）

解决：
 原因1：在`menu.config.ts`配置文件中配置出错。
 原因2：在`menu.config.ts`配置没有问题。开发的模块代码出错也会提示路径不匹配，以下是遇到的原因。
 原因3：服务没有在模块中注入。



#### 14.Can't bind to 'label' since it isn't a known property of 'button'.

解决：在`button`标签中，并没有label属性，label是属于其他组件封装的属性，需要引入相对应的模块。



#### 15.Can't bind to 'ngClass' since it isn't a known property of 'div'.

解决：

```typescript
import { CommonModule } from "@angular/common";
```



#### 16.Unexpected module 'BrowserAnimationsModule' declared by the module 'AppModule'. Please add a @Pipe/@Directive/@Component annotation.

错误原因：`declarations: []` ,在这个元数据中引入了模块，导致引入位置错误，
解决：在`imports: []` 引入模块。



#### 17.ExpressionChangedAfterItHasBeenCheckedError: Expression has changed after it was checked. Previous value

解决： 组件使用中，是否存在异步调用问题，解决异步调用中，处理数据还没有加载的情况。



#### 18.Error: No NgModule metadata found for 'undefined'.Error: No NgModule metadata found for 'undefined'.

解决：路由配置错误，检查路由配置路径和模块是否对应

```typescript
{
    path: 'demo/treedemo',
    loadChildren: './scene/searchform/demo.module.ts#DemoModule'
}
```



#### 19.The pipe 'json' could not be found

解决：

```typescript
import { CommonModule } from '@angular/common';
```

```typescript
@NgModule({
    ...
    imports: [ CommonModule ]
    ...
})
```



#### 20.If ngModel is used within a form tag, either the name attribute must be set or the form control must be defined as 'standalone' in ngModelOptions

解决： input 添加name属性



#### 21.Template parse errors:There is no directive with "exportAs" set to "ngModel"

解决： 给input绑定`[(ngModel)]="inputValue"`



#### 22.Failed to execute 'setAttribute' on 'Element': '(ngModel)]' is not a valid attribute name.

解决： `(ngModel)]`, 少写一个 [



#### 23.There is no directive with "exportAs" set to "ngModel"

解决：

```typescript
import { FormsModule }   from '@angular/forms';2.[(ngModel)]="oldPwdValue"
```

绑定数据



#### 24.ERROR Error: No provider for ChildrenOutletContexts!

解决：routing 模块没有在主模块中引入，routing模块并不能单独存在。



