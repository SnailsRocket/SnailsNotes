

两者都是锁，用来控制并发冲突，区别在于Lock是个接口，提供的功能更加丰富，除了这个外，他们还有如下区别：

1. synchronize自动释放锁，而Lock必须手动释放，并且代码中出现异常会导致unlock代码不执行，所以Lock一般在Finally中释放，而synchronize释放锁是由JVM自动执行的。
2. Lock有共享锁的概念，所以可以设置读写锁提高效率，synchronize不能。（两者都可重入）
3. Lock可以让线程在获取锁的过程中响应中断，而synchronize不会，线程会一直等待下去。lock.lockInterruptibly()方法会优先响应中断，而不是像lock一样优先去获取锁。
4. Lock锁的是代码块，synchronize还能锁方法和类。
5. Lock可以知道线程有没有拿到锁，而synchronize不能(Thread.holdsLock方法可以让synchronize也能感应到是否获取到了锁)



CAS 乐观锁  每次去取共享变量的时候，都假设没有被使用，直接获得锁(乐观锁并不是锁，只是一种实现思路)

synchronized 悲观锁 假设每次去取变量的时候，都被其他线程使用

互斥锁  互斥变量 mutex

 



