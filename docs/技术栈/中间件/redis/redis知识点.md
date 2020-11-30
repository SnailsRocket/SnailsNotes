## Redis

**redis是一个存在于内存中的数据库，一般用作系统缓存。Redis有复杂的数据结构。可以分为五种String，List，Hash，Set，ZSet(SortSet)。redis是单线程的，支持数据库事务。**





### 持久化方式  RDB AOF

#### 为什么需要持久化了

Redis 是存在内存中的缓存数据库，一旦服务器宕机，或者redis master 死掉，redis中的数据库就全部丢失，前端访问的请求全部打到后端数据库(Mysql)，进而导致后端数据库崩溃，整个系统崩掉。所以这个时候需要将redis里面的数据持久化到本地系统盘里面去。

**redis默认的持久化方式是RDB，也就是快照式，AOF是增量式**

#### RDB (一般几分钟执行一次,在redis.conf 里面设置 触发条件 save 60 5)

> Redis 数据库默认的持久化方式
>
> 查看持久化文件在哪个文件夹    config get dir
>
> 持久化到dump.db 这个二进制文件里面
>
> fork 一个线程，遍历hash table ，利用 copy on write,把整个db dump下来
>
> 粒度相对较大，如果save，shutdown，slave 之前进行crash了，则中间的操作没有办法恢复



#### AOF(可以设置每写一个命令执行一次AOF，也可以设置1s一次)

> 持久化到以 .aof  为后缀的文件里面
>
> 相当于日志类的，记录redis 的 
>
> 粒度较小，crash之后，只有之前没有来的及做日志的操作没办法恢复。
>
> 恢复数据时，执行时间较RDB模式要长，而且对于相同数据集，AOF的文件比RDB 大





### PipeLine(流水线)

**首先来看一下redis 执行一次需要耗费的时间**

1次时间 =  1次网络时间 + 1次命令时间

执行n次就需要

n次时间 = n 次网络时间 + n 次命令时间

但是由于命令执行时间非常短，影响时间开销的主要是网络时间，所以我们可以**把一组命令打包，然后一次发送过去**，这样的话，n次时间就是

n 次时间 = 1次网络时间 + n次命令时间

#### PipeLine优点

> 省略由于单线程导致命令的排队等待的时间
>
> 比起命令执行时间，网络时间才是系统的瓶颈
>
> pipeline的作用是将一组命令打包，发送给服务器，服务器执行完按顺序打包返回



#### PipeLine VM M (mget、mset)

> M 操作在Redis队列中是一个原子操作，而PipeLine不是原子操作
>
> M和PipeLine 都会将数据顺序的传输，顺序的返回(redis 是单线程)
>
> M 操作一个命令对应多个键值对，PipeLine操作对个命令



PipeLine 一次不宜携带太多命令，否则影响网络性能

PipeLine每次只能作用在一个redis节点上



```java
//没有使用pipieline的情况下 发送10000 次 相当于需要耗费 10000 次网络传输延时
public void testWithoutPipeline() {
    Jedis jedis = new Jedis("127.0.0.1" , 6379);
    for(int i = 1 ; i <= 10000 ; i++ ) {
        jedis.hset("hashKey-" + i , "field-" + i , "value-" + i);
    }
}

//使用pipeline的情况下  只耗费 100 次网络传输延时
public void testPipeline() {
    Jedis jedis = new Jedis("127.0.0.1" , 6379);
    for(int i = 0 ; i < 100 ; i++ ) {
        Pipeline pipeline = jedis.pipelined(); // PipeLine 一次不宜携带太多命令
        for(int j = i * 100 ; i < (i+1) * 100 ; j++ ) {
            pipeline.hset("hashKey-" + j , "field-" + j , "value-" + j);
        }
        pipeline.syncAndReturnAll();
    }
}
```









