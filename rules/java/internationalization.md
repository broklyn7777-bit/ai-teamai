---
paths:
  - "**/*.java"
---

# Java 国际化与时区规范

> 详细的代码模板、配置示例请参见 Skill `uac-internationalization`。

## 🔴 核心禁忌

| 禁忌 | 正确做法 |
|---|---|
| Controller/Service 中硬编码文案 | 统一通过国际化工具类获取 |
| 不同模块复用同一个 Key | 按模块独立 Key，`模块.功能.场景.含义` |
| 数据库连接使用 UTC 时区 | 国内业务 Asia/Shanghai |
| 时间字段使用 string 传参 | 统一 Date/LocalDateTime/LocalDate |
| 前端遗漏 TIME-ZONE 请求头 | 每次请求必须携带 |
| 手动手写时区转换逻辑 | 框架全局拦截自动转换 |

## 必守原则

1. **框架**：`orion-spring-boot-starter-i18n`
2. **禁止硬编码**：所有接口返回提示、异常信息纳入国际化
3. **Key 命名**：`模块.功能.场景.含义`，小写+点分隔
4. **数据源**：UAC 远程 Feign 接口获取全局配置，禁止本地维护 properties
5. **实体注解**：`@I18nClass` 标记类，`@I18nField` 标记翻译字段
6. **时区**：JDBC 连接串配置时区，时间字段用 Date 类型
7. **前端传参**：Header 携带 `TIME-ZONE`

## 🔗 何时调用 uac-internationalization Skill？

| 场景 | 用本文件 | 调用 Skill |
|------|---------|-----------|
| 查阅禁忌和快速规范 | ✅ | |
| 配置国际化 YAML | | ✅ |
| 实现 UAC 远程配置 | | ✅ |
| 实体注解/多时区处理 | | ✅ |

完整指南：`skills/uac-internationalization/SKILL.md`（6 个专题 + 完整代码模板）
