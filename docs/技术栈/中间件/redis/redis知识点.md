## Redis

**redis是一个存在于内存中的数据库，一般用作系统缓存。Redis有复杂的数据结构。可以分为五种String，List，Hash，Set，ZSet(SortSet)。redis是单线程的，支持数据库事务。**



### 缓存雪崩

> 缓存雪崩是因为在一段时间内缓存(热点数据)大面积失效，导致大部分请求直接打到后端，导致后端的数据库挂掉。
>
> 举个例子，假设你1s 有7000 请求,本来缓存可以抗住每秒 5000的请求，但是缓存当时所有的key都失效了，导致请求直接打到，数据库必然扛不住这么大的数据,它会给DBA报警，而实际上数据库会直接挂掉。如果没有用什么特别的方案来处理这个故障，DBA很着急，重启数据库，但是数据库立马又被新的流量打死。这个是我理解的缓存雪崩。
>
> 这个时候触发服务降级，系统熔断，就能最大程度的降低因为某个数据库挂掉导致整个服务不可用带来的影响。



#### 解决方案

> 方案1：搭建redis集群，防止一台redis挂掉，导致整个缓存中间价不可用
>
> 方案2：设置key永不过期(这个不推荐，redis大小有限制，不能当MySQL用)
>
> 方案3：设置随机过期时间，避免所有的key在同一时间大批量失效
>
> 方案4；



### 缓存击穿

> 缓存击穿这个跟缓存雪崩有点像，但是缓存雪崩是大面积的key失效，导致请求打到数据库，而缓存击穿是指单个缓存key
>
> 失效，但是有大量的请求都同时访问这个热点key，导致大量同一请求直接打到数据库，严重的话，直接导致数据库崩溃。
>
> 如果这个数据库是一个用户服务的库，那么就会导致整个系统不可用，用户体验不好，你们公司基本就凉了，然后就准备找工作把。



#### 解决方案

> 设置热点数据永不过期，或者加上互斥锁
>
> 找到被大量访问的那几个key，在redis里面，将key 设置为该值，value设置 null，并设置一个过期时间，等到并发小的时候，自动更新该key到redis里面。(这个方法有个不问，不能提前避免事故的发生，而且发生事故后，找到该key可以直接手动在redis中更新该key的value)





### 缓存穿透

> 缓存穿透是指黑客故意攻击你的服务器，向后端发送一个数据库不存在的key(eg:id=-1  或者 id=1000000 值特别大(我们数据库一般id都是设置自增的)) ，然后用户不断的去重复这个查询。占用了大量的请求，导致正常用户访问我们的服务体验变差。严重的话会直接打崩数据库。



#### 解决方案

> 这个解决方案有很多。可以使用gateway或者zuul网关，限制同一ip访问的次数(但是这个基本没啥用，现在黑客都使用ip代理池去攻击服务器，所以不会出现同一ip高密度访问一个服务器)，
>
> 第二种方案就是在前段校验参数 比如 id<0 
>
> 第三种方案就是使用布隆过滤器(Bloom Filter)，这个能很好的防止缓存穿透的发生。布隆过滤器的原理也很简单，就是使用高效的数据结构和算法快速判断你这个key是否在redis里面，





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







