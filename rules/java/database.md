---
paths:
  - "**/*.java"
---

# Java 数据库开发规范

> 本文档定义数据库开发的核心约束。详细的代码模板、配置示例和排障指南请参见 Skill `uac-database`。

## 🔴 核心禁忌

| 禁忌 | 正确做法 |
|---|---|
| `${}` SQL 拼接 | `#{}` 参数化查询 |
| 字段无 DEFAULT 且允许 NULL | 每字段必须有 DEFAULT |
| BOOLEAN/BIT 类型 | TINYINT(1) |
| TEXT 类型 | VARCHAR |
| 物理外键 | 逻辑外键（应用层维护） |
| 触发器、存储过程 | 应用层实现 |
| SELECT * | 列出具体字段 |
| 单表 >5 索引 | 精心设计索引 |
| 批量操作 >1000 条 | 分批处理 |
| 数据库关键字作表名 | 使用前缀命名 |

## 必守原则

1. **命名**：snake_case，表名用单数，避免 MySQL 关键字
2. **表结构**：必须包含 `id`（雪花算法）、`create_time`、`update_time`、`del_flag`
3. **MyBatis-Plus**：只用 `#{}` 参数化，结果集用 ResultMap，批量 ≤1000
4. **事务**：框架自动管理（按方法名前缀判断），禁止手写 `@Transactional`
5. **多数据源**：`@DS` 注解切换，方法级覆盖类级
6. **多租户**：所有业务表必须有 `tenant_id`，系统表用 `@InterceptorIgnore` 忽略
7. **数据权限**：方法级使用 `@DataPermission`
8. **SQL 打印**：开发/测试启用 p6spy，生产禁用

## 🔗 何时调用 uac-database Skill？

| 场景 | 用本文件 | 调用 Skill |
|------|---------|-----------|
| 查阅禁忌和快速规范 | ✅ | |
| 设计 schema、Entity | | ✅ |
| 编写复杂 SQL | | ✅ |
| 配置分片、多租户 | | ✅ |
| 性能优化、慢 SQL 排查 | | ✅ |

完整指南：`skills/uac-database/SKILL.md`（11 个专题 + 7 个快速参考）
