# Redis 红线禁忌

- ⛔ 禁止手动创建 RedisConnection、手写 Redis 序列化逻辑，禁止绕过 RedisHelper 工具类
- ⛔ 禁止生产使用单机 Redis、不配置缓存前缀、永久缓存不设置过期时间
- ⛔ 禁止随意调大连接池参数、Caffeine 最大缓存数，避免 JVM OOM
- ⛔ 禁止 Redis 密码明文写入配置文件，必须通过配置中心托管
- ⛔ 禁止使用 `keys *`、`hgetall` 等慢查询，大数据量用 `scan` 迭代
- ⛔ 禁止同类内部方法调用注解缓存（切面失效）
- ⛔ 禁止滥用 `allEntries = true` 全量清除，仅批量更新场景使用
- ⛔ 禁止 Redis 操作异常不捕获、影响主业务流程
- ⛔ 禁止缓存大对象（单Value > 1MB），需拆分或压缩
