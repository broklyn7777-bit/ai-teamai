---
paths:
  - "**/*.java"
---

# Java Redis 缓存开发规范

> 详细的代码模板、配置示例和排障指南请参见 Skill `uac-redis-cache`。

## 🔴 核心禁忌

| 禁忌 | 正确做法 |
|---|---|
| 纯数字 Key、无意义随机 Key | `业务域:模块:功能:唯一标识` 格式 |
| 永久缓存不设过期时间 | 所有缓存必须设过期，默认 30 分钟 |
| JDK 默认序列化 | StringRedisSerializer + FastJson2 |
| 先删缓存后更库 | 先更库，后删缓存 |
| `keys *`、`hgetall` 慢查询 | `scan` 迭代 |
| 缓存操作异常阻断业务 | 捕获仅打印 error，不影响主流程 |
| 裸 key 存入 Redis | 必须配置 `cache_prefix` |

## 必守原则

1. **Key 命名**：`业务域:模块:功能:唯一标识`，小写+冒号，≤64 字符
2. **过期时间**：禁止永久缓存，避开整点防雪崩
3. **空值防护**：开启 `cache_null_values`，防穿透
4. **更新策略**：先更新 DB，后删缓存
5. **分布式锁**：`setIfAbsent` + Lua 脚本原子释放
6. **多级缓存**：Caffeine + Redis 发布订阅实现多实例同步
7. **对象大小**：单 Value ≤ 1MB

## 🔗 何时调用 uac-redis-cache Skill？

| 场景 | 用本文件 | 调用 Skill |
|------|---------|-----------|
| 查阅禁忌和快速规范 | ✅ | |
| 配置 Redis YAML | | ✅ |
| 设计缓存策略和过期时间 | | ✅ |
| 实现分布式锁 | | ✅ |
| 多级缓存/发布订阅配置 | | ✅ |

完整指南：`skills/uac-redis-cache/SKILL.md`（7 个专题 + 5 个快速参考）
