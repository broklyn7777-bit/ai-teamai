---
paths:
  - "**/*.java"
---

# Java Saturn 定时任务规范

> 详细的代码模板、配置示例请参见 Skill `uac-schedule-tasks`。

## 🔴 核心禁忌

| 禁忌 | 正确做法 |
|---|---|
| 非指定版本 Saturn/引入其他调度框架 | 使用框架指定版本 |
| 硬编码控制台地址/cron表达式 | 全部在 Saturn 控制台配置 |
| 任务类不继承 AbstractSaturnJavaJob | 必须继承 + @Component |
| 不捕获异常/不打印日志 | 主动捕获，完整打印日志 |
| 任务内写复杂业务逻辑 | 调用 Service 层，任务只做调度 |
| 分布式场景不使用分片 | 强制分片机制防重复执行 |
| 遗漏 setSystemTaskAuth | handleJavaJob 开始处必须设置 |

## 必守原则

1. **依赖**：`saturn-spring 3.6.9.SF.RELEASE`
2. **类规范**：继承 `AbstractSaturnJavaJob`，重写 `handleJavaJob`，`@Component` 托管
3. **配置**：`SaturnJobConfig` 独立配置类，yml 绑定 consoleURI + appnamespace
4. **入口设置**：`handleJavaJob` 开始处调用 `userTheadLocalUtil.setSystemTaskAuth()`
5. **异常处理**：捕获业务异常，规范返回 SaturnJobReturn
6. **日志**：完整打印执行开始/结束/异常信息

## 🔗 何时调用 uac-schedule-tasks Skill？

| 场景 | 用本文件 | 调用 Skill |
|------|---------|-----------|
| 查阅禁忌和快速规范 | ✅ | |
| 新建定时任务类 | | ✅ |
| 配置 Saturn 命名空间 | | ✅ |
| 分片/广播任务设计 | | ✅ |

完整指南：`skills/uac-schedule-tasks/SKILL.md`（4 个专题 + 完整代码模板）
