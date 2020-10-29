## Spring data 集成 redis

### keys 与 scan 的区别

#### keys

##### redisconnection.keys

> keys 命令用于返回指定的正则表达式所匹配的所有key的列表，其所检索的是redis当前所使用的数据库(默认为0号数据库)

##### 性能问题

> 由于每个Redis实例是使用单线程处理所有请求的，故keys命令和其他命令都是在同一队列排队等待执行的，如果keys命令执行时间长，则会阻碍其他命令的执行，导致性能问题。如果keys命令需要匹配非常多的key，则可能造成长期停顿。

```java
redisTemplate.keys(pattern) // 使用
```



#### Scan命令

Scan命令是2.8及之后的版本提供的，主要用于解决keys命令可能导致整个redis实例停顿的问题。scan是一种迭代命令，主要是对keys命令进行了分解，即原本使用一个keys请求一次匹配获取所有符合的keys的操作，分解了多次scan操作，每次scan操作返回匹配的key的一个子集，这样每个scan请求的操作时间很短，多次scan请求之前可以执行其他命令，故减少对其他命令执行的阻塞，直到最后一个scan请求发现没有数据可以返回了，则操作完成，汇总该次所有scan请求的数据，从而达到与keys命令一次获取的数据相同。

​	由于scan命令需要执行多次，即相当于执行了多个命令，存在多次命令请求和响应周期，故整体执行时间可能要比keys命令要长。

##### 用法

> 在使用scan命令时，通常需要搭配 count一起使用。
>
> scan 0 MATCH user_* COUNT 1000

#### java 中使用scan

**在java中一般基于spring的redisTemplate来进行相关的操作，其中RedisTemplate是线程安全的，故整个项目可以共享一个RedisTemplate实例**

```java
public int getTotalUsers() {
    Set<String> allUsers = redisTemplate.execute(new RedisCallback<Set<String>>() {
      @Override
      public Set<String> doInRedis(RedisConnection connection) throws DataAccessException {
        Set<String> partUers = new HashSet<>();
        // 放在try中自动释放cursor
        try (Cursor<byte[]> cursor = connection.scan(new ScanOptions.ScanOptionsBuilder()
                .match(RedisStorage.USER_KEY + "*").count(50000).build())) {
          while (cursor.hasNext()) {
            partUers.add(new String(cursor.next()));
          }
        } catch (IOException e) {
          LOG.error("getTotalUsers cursor close {}", e);
        }
        return partUers;
      }
    });
    return sessions.size();
}
```



#### SpringRedisTemplate 对scan进行了封装

```java
Set<Object> execute = redisTemplate.execute(new RedisCallback<Set<Object>>() {

    @Override
    public Set<Object> doInRedis(RedisConnection connection) throws DataAccessException {

        Set<Object> binaryKeys = new HashSet<>();

        Cursor<byte[]> cursor = connection.scan( new ScanOptions.ScanOptionsBuilder().match("test*").count(1000).build());
        while (cursor.hasNext()) {
            binaryKeys.add(new String(cursor.next()));
        }
        return binaryKeys;
    }
});
```

注意Cursor一定不能关闭，在之前的版本中，这里Cursor需要手动关闭，但是从1.8.0开始，不能手动关闭！否则会报异常。

ScanOptions有两个参数，一个是match，另一个是count，分别对应scan命令的两个参数。

Scan命令源码：

```java
 /* Handle the case of a hash table. */
    ht = NULL;
    if (o == NULL) {//键扫描
        ht = c->db->dict;
    } else if (o->type == REDIS_SET && o->encoding == REDIS_ENCODING_HT) {
        ht = o->ptr;
    } else if (o->type == REDIS_HASH && o->encoding == REDIS_ENCODING_HT) {
        ht = o->ptr;
        count *= 2; /* We return key / value for this type. */
    } else if (o->type == REDIS_ZSET && o->encoding == REDIS_ENCODING_SKIPLIST) {
        zset *zs = o->ptr;
        ht = zs->dict;
        count *= 2; /* We return key / value for this type. */
    }
//由于redis的ziplist, intset等类型数据量挺少，所以可用一次返回的。下面的else if 做这个事情。全部返回一个key 。
    if (ht) {//一般的存储，不是intset, ziplist
        void *privdata[2];

        /* We pass two pointers to the callback: the list to which it will
         * add new elements, and the object containing the dictionary so that
         * it is possible to fetch more data in a type-dependent way. */
        privdata[0] = keys;
        privdata[1] = o;
        do {
            //一个个扫描，从cursor开始，然后调用回调函数将数据设置到keys返回数据集里面。
            cursor = dictScan(ht, cursor, scanCallback, privdata);
        } while (cursor && listLength(keys) < count);     } else if (o->type == REDIS_SET) {
        int pos = 0;
        int64_t ll;

        while(intsetGet(o->ptr,pos++,&ll))//将这个set里面的数据全部返回，因为它是压缩的intset，会很小的。
            listAddNodeTail(keys,createStringObjectFromLongLong(ll));
        cursor = 0;
    } else if (o->type == REDIS_HASH || o->type == REDIS_ZSET) {//那么一定是ziplist了，字符串表示的数据结构，不会太大。
        unsigned char *p = ziplistIndex(o->ptr,0);
        unsigned char *vstr;
        unsigned int vlen;
        long long vll;

        while(p) {//扫描整个键，然后全部返回这一条。并且返回cursor为0表示没东西了。其实这个就等于没有遍历
            ziplistGet(p,&vstr,&vlen,&vll);
            listAddNodeTail(keys,
                 (vstr != NULL) ? createStringObject((char*)vstr,vlen) : createStringObjectFromLongLong(vll));
            p = ziplistNext(o->ptr,p);
        }
        cursor = 0;
    } else {
        redisPanic("Not handled encoding in SCAN.");
    }
```



> - 提供键空间的遍历操作，支持游标，复杂度O(1), 整体遍历一遍只需要O(N)；
> - 提供结果模式匹配；
> - 支持一次返回的数据条数设置，但仅仅是个hints，有时候返回的会多；
> - 弱状态，所有状态只需要客户端需要维护一个游标；
> - 无法提供完整的快照遍历，也就是中间如果有数据修改，可能有些涉及改动的数据遍历不到；
> - 每次返回的数据条数不一定，极度依赖内部实现；
> - 返回的数据可能有重复，应用层必须能够处理重入逻辑；上面的示例代码中，redisTemplate.execute方法是个Set，相当于已经对于返回的key去重
> - count是每次扫描的key个数，并不是结果集个数。count要根据扫描数据量大小而定，Scan虽然无锁，但是也不能保证在超过百万数据量级别搜索效率；count不能太小，网络交互会变多，count要尽可能的大。在搜索结果集1万以内，建议直接设置为与所搜集大小相同













