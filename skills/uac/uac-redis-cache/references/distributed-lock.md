# 分布式锁标准用法

```java
RedisCacheImpl cache = RedisHelper.getRedisCache("primary");
String lockKey = "order:process:" + orderId;
// 阻塞式获取：等待 5 秒，锁过期时间 10 秒
String lockId = cache.acquireLock(lockKey, 5, 10);

// 必须在 finally 中释放锁，检查 lockId 防止误删
try {
    // 业务逻辑
} finally {
    boolean released = cache.releaseLock(lockKey, lockId);
}
```

**红线禁忌**：
- 禁止在 finally 外释放锁
- 禁止不检查 lockId 直接释放（可能误释放他人的锁）
- 禁止锁过期时间 < 业务最大执行时间
