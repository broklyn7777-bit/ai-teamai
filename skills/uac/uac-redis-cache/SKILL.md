---
name: uac-redis-cache
description: |
  缓存优化专家。用于实现 Redis 缓存策略、配置分布式锁、构建多级缓存（Redis + Caffeine 本地缓存）、优化应用性能。
  覆盖缓存穿透/击穿/雪崩防护、Lettuce 高性能 Redis 访问配置、序列化策略、过期时间管理、使用 Redis 进行消费端幂等去重、发布订阅缓存同步。
  触发关键词："Redis"、"缓存"、"分布式锁"、"本地缓存"、"Caffeine"、"Lettuce"、"热点数据"、"缓存穿透"、"缓存雪崩"、"缓存击穿"、"性能优化"、"setIfAbsent"、"Cacheable"、"CacheEvict"、"缓存前缀"、"过期时间"
compatibility: Requires orion-spring-boot-starter-redis, Redis 5.0+ (cluster mode in production), Spring Cache abstraction
---

# Skill: Redis-Cache-Development
# 适用场景：Redis使用规范、本地缓存、分布式锁、多级缓存、发布订阅缓存同步

## 一、强制命名规范

**Key命名**：采用 **业务域:模块:功能:唯一标识** 格式，小写英文+数字+冒号，禁止特殊字符/空格/中文，长度≤64字符
示例：`user:base:info:1001`、`order:pay:lock:20240321001`

**禁止行为**：禁止纯数字Key、禁止无意义随机Key、禁止裸key存入Redis（必须配置全局缓存前缀）

## 二、核心使用规范

1. **过期时间强制**：所有缓存必须设置过期时间，**禁止永久缓存**；默认30分钟，避开整点防雪崩
2. **空值防护**：禁止存储null值，开启 `cache_null_values`，查询无结果存短过期占位值（1分钟）
3. **序列化**：禁用JDK默认序列化，统一 StringRedisSerializer（Key）+ FastJson2（Value）
4. **客户端**：优先 Lettuce，禁止混用 Jedis 和 Lettuce
5. **更新策略**：**先更新数据库，后删除缓存**，禁止先删缓存后更库
6. **对象大小**：单Value≤1MB，大对象拆分或压缩

## 三、分布式锁规范

1. 加锁必须用 `setIfAbsent`（原子命令）+ 过期时间，杜绝死锁
2. 解锁必须用 Lua 脚本保证原子性，校验锁归属再删除，防止误释放
3. 锁过期时间 > 业务最大执行时间
4. 禁止循环内频繁加锁解锁

## 四、编码禁忌

1. 禁止使用 `keys *`、`hgetall` 等慢查询，用 `scan` 替代
2. Redis操作异常必须捕获，不能影响主业务流程，仅打印error日志
3. 禁止手动创建 RedisConnection、手写序列化逻辑、绕过 RedisHelper

## 五、Redis 核心约束

- **统一依赖**：复用框架 Redis starter，禁止原生引入依赖、手写连接池
- **配置集中化**：所有参数在 yml 配置，敏感密码接入配置中心占位符
- **集群优先**：生产强制 Redis 集群，禁止单机部署
- **缓存前缀强制**：必须配置 `cache_prefix`，禁止裸key

## 六、多级缓存（Redis + Caffeine）

- **适用场景**：仅热点本地数据、低延迟要求，禁止大数据集/跨实例共享
- **多级联动**：本地缓存必须配合 Redis + 发布订阅实现多实例同步
- **过期强制**：必须配置访问/写入过期 + 最大缓存数（≤1000），禁止无过期本地缓存
- **禁止强一致性依赖**：本地缓存为JVM级别，禁止用于强一致性场景

## 七、发布订阅缓存同步

- 多实例部署下，Caffeine 变更必须通过 Redis 发布订阅通知所有实例
- 监听类实现 `MyRedisListener` 接口，`handlerName` 精准匹配
- 消息体精简，禁止传递大对象

---

## 📚 快速参考文件导航

| 文件名 | 用途 |
|---|---|
| **redis-basic-config.md** | 依赖引入、YAML配置、动态加载Redis、工具类用法 |
| **distributed-lock.md** | 分布式锁标准用法 |
| **spring-cache-annotations.md** | @Cacheable/@CacheEvict/@Caching/@CachePut 标准用法 |
| **pubsub-cache-sync.md** | 发布订阅缓存同步标准用法 |
| **redis-redlines.md** | 完整红线禁忌 |

---

### 使用建议

- **第一次学习某个功能**：先读本文档相应章节，理解完整概念
- **日常开发中快速回忆**：查阅 `references/` 对应文件，快速找到关键代码
