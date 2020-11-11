## Spring 之 BeanUtils.copyProperties的使用(深拷贝，浅拷贝)

**深拷贝**：将父类对象的属性拷贝到子类对象里面

**浅拷贝**：只是调用子类对象的set方法，将父类对象的地址值给子类的属性，如果父类的属性发生改变，子类相对应的属性也会发生改变

BeanUtils.copyProperties  是浅拷贝



参考[深拷贝浅拷贝](https://blog.csdn.net/enthan809882/article/details/104956537/)

