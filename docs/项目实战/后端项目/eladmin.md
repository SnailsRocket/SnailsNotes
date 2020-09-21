## eladmin



#### 验证码逻辑

> 使用的是 gitee 上面提供的验证码 https://gitee.com/whvse/EasyCaptcha
>
> 1.首先，刷新页面，或者点击验证码图片(这个地方需要限流，同一个ip10s内，只能刷新10次，如果次数不正常就拉黑ip，防止恶意攻击)
>
> 2.然后后台AuthorizationController的getCode接收到获取验证码的请求，然后获取验证码生产类LoginProperties.getCaptcha，依据配置信息生产验证码，返回一个Captcha对象(这个对象是easy-captcha 这个jar包提供的，源码放在gitee上面)；
>
> 3.生成uuid，作为redis的key，Captcha的text 作为Redis的value
>
> 并设置过期时间
>
> 4.将验证码的信息的图片Captcha对象使用Base64加密后作为value，key= img放入map里面去，uuid也放入map里面
>
> 5.返回一个ResponseEntity对象(这个Spring Web jar包提供的)(以前都是自己定义的返回对象)



#### 登录逻辑









### redis