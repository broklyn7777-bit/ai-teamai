---
paths:
  - "**/*.java"
---

# Java Kafka 消息队列规范

> 详细的代码模板、配置示例请参见 Skill `uac-kafka-messaging`。

## 🔴 核心禁忌

| 禁忌 | 正确做法 |
|---|---|
| 手动创建 KafkaProducer/Consumer | 通过框架 ProducerPool/Listener |
| 消息体无 bizId | 每条消息必须包含 bizId |
| 消费线程内抛异常 | 内部捕获处理，防线程中断 |
| 硬编码 Topic/消费者组 | 常量类统一管理 |
| 单条消息体 > 1MB | 建议 ≤ 100KB，大文件传地址引用 |
| 消费线程数 > 分区数 | 多余线程无法分配 |

## 必守原则

1. **框架**：`sf-kafka-api-core`，禁止原生引入 spring-kafka
2. **Topic 命名**：`业务域_模块_功能`（大写+下划线）或 `业务域-模块-功能`
3. **消费者组**：`业务域-模块-consumer`
4. **消息 Key**：`业务域:模块:ID`
5. **消息基类必需字段**：`bizId`、`createTime`、`traceId`
6. **配置集中化**：所有参数在 yml 配置，敏感信息占位符

## 🔗 何时调用 uac-kafka-messaging Skill？

| 场景 | 用本文件 | 调用 Skill |
|------|---------|-----------|
| 查阅禁忌和快速规范 | ✅ | |
| 实现生产者/消费者 | | ✅ |
| Topic/消费者组配置 | | ✅ |
| 消息重试/死信队列设计 | | ✅ |

完整指南：`skills/uac-kafka-messaging/SKILL.md`（5 个专题 + 完整代码模板）
