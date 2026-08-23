---
name: uac-database
description: |
  数据库设计专家。用于设计数据库 schema、创建 Entity 模型、编写 MyBatis mapper、实现 DAO 层、配置多数据源路由、处理分库分表和多租户隔离。
  覆盖表命名规范、字段设计、索引优化、事务管理、数据权限控制。包括 MyBatis-Plus 集成、ShardingSphere 配置、SQL 性能分析、p6spy 慢SQL排查。
  触发关键词："建表"、"SQL"、"Entity"、"Mapper"、"DAO"、"字段"、"主键"、"索引"、"数据库"、"表设计"、"分库分表"、"多租户"、"tenant_id"、"多数据源"、"@DS"、"数据权限"、"事务"、"p6spy"、"慢SQL"、"MyBatis-Plus"
compatibility: Requires MyBatis-Plus 3.4.3.4+, MySQL 5.7+/Oracle 11g+, Sharding Sphere 3.1.0+, Spring Data JDBC
---

# Skill: Database-Development
# 适用场景：建表SQL、Entity、Mapper、DAO、索引、MyBatis-Plus、事务、SQL日志、多数据源、分库分表、多租户隔离、数据权限拦截

## 一、命名规范（阿里强制）
1. 库名、表名、字段名：小写 + 下划线
2. 表名使用单数，禁止复数
3. 禁止使用数据库关键字：user、order、status、type等

## 二、表结构强制三字段
每张表**必须包含**：
- id BIGINT PK 主键（雪花算法/自增）
- create_time DATETIME NOT NULL
- update_time DATETIME NOT NULL
- del_flag TINYINT DEFAULT 0 （软删除）

## 三、字段设计规范
1. 禁止允许 NULL 不写 DEFAULT
2. 布尔值使用 TINYINT(1)，1=是 0=否
3. 字符串优先使用 VARCHAR，非必要不用 TEXT
4. 禁止物理外键，使用逻辑外键
5. 禁止触发器、存储过程

## 四、索引规范
1. 单表索引数量 ≤ 5
2. 联合索引遵循最左匹配原则
3. 高频查询字段必须建索引
4. 禁止 SELECT *
5. 禁止大表全表扫描

## 五、MyBatis/MyBatis-Plus 规范

1. 必须使用 #{}，禁止 ${} 拼接
2. 所有复杂业务逻辑 SQL 在 Mapper XML 中实现，充分利用 ResultMap，设计通用可复用的 SQL
3. 单表简单查询禁止在 XML 中实现，使用 MyBatis-Plus BaseMapper 方法或 default 方法
4. 结果集必须使用 ResultMap
5. 批量操作必须分批执行（batchSize ≤ 1000），避免内存溢出

详细说明、示例代码和最佳实践见 `references/mybatis-plus-tips.md`

**红线禁忌**：禁止使用 ${} 拼接；禁止在 SysConfigMapper 等系统表 Mapper 上自定义 SQL；禁止一次性处理 >1000 条数据

## 六、多数据源规范

- **统一依赖**：复用框架 `orion-db` 依赖，禁止自定义多数据源工具类
- **默认数据源**：设置 master 为默认数据源，非必要不新增
- **切换规则**：通过 `@DS` 注解实现，方法注解优先级高于类注解
- **严格模式**：生产默认关闭，避免服务异常

详细用法见 `references/multi-datasource-tips.md`

## 七、声明式事务规范

- **框架自动开启**：框架默认开启事务管理，禁止手动关闭
- **切面规则固定**：默认匹配 Service 层方法，禁止随意修改
- **事务区分**：查询方法只读事务，写入方法（pay/do/build开头）可传播事务
- **禁止手动事务**：禁止业务代码手写 TransactionTemplate

详细配置见 `references/transaction-tips.md`

## 八、分库分表规范

- **统一依赖**：复用框架 `orion-spring-boot-starter-shardingsphere` 依赖
- **配置隔离**：分片配置在 Nacos 专用配置文件，不与普通数据源混用
- **数据源切换**：必须通过 `@DS("sharding")` 指定分片数据源
- **算法规范**：优先使用框架内置算法，特殊场景自定义必须标准化
- **生产日志**：生产环境关闭 SQL 打印（sql-show: false）

详细快速入门见 `references/sharding-quick-start.md`

## 九、多租户隔离（SaaS）规范

- **全局开关**：SaaS 项目必须开启，非 SaaS 项目禁止开启
- **租户字段**：业务表必须包含 `tenant_id`，框架自动拦截
- **忽略规则**：仅系统基础表允许忽略租户拦截，业务表禁止
- **租户 ID 获取**：通过框架安全工具类获取，禁止自定义逻辑
- **忽略粒度**：优先方法级忽略，禁止全局大范围忽略

详细配置见 `references/multi-tenancy-quick-start.md`

## 十、数据权限拦截

- **资源维度控制**：按资源（机构、部门、项目）配置独立过滤规则
- **管理员豁免**：超管、租户管理员默认豁免，普通用户严格拦截
- **注解控制**：通过 `@DataPermission` 在方法级控制，不允许全局强制拦截
- **SQL 无侵入**：依托框架拦截器自动拼接，禁止手写权限过滤

详细配置见 `references/data-permission-quick-start.md`

## 十一、SQL 分析打印规范

- **环境限制**：仅测试/开发环境开启，生产环境必须关闭
- **驱动规范**：开启后必须使用 p6spy 驱动，禁止混用原生驱动
- **慢 SQL 配置**：阈值默认 2 秒，禁止随意修改

详细说明见 `references/sql-profiling-tips.md`

---

## 📚 快速参考文件导航

本技能包含以下快速参考文件，可用于快速查表和故障排查：

| 文件名 | 用途 | 适用场景 |
|---|---|---|
| **mybatis-plus-tips.md** | SQL 复用设计、批量操作、常见错误 | 快速查表 |
| **multi-datasource-tips.md** | @DS 注解用法、数据源切换 | 快速查表 |
| **transaction-tips.md** | 事务配置、方法匹配规则、失效排查 | 快速查表 + 故障排查 |
| **sql-profiling-tips.md** | p6spy 配置、慢 SQL 阈值、日志输出 | 快速参考 |
| **sharding-quick-start.md** | 分库分表快速入门步骤 | 新功能上手 |
| **multi-tenancy-quick-start.md** | 多租户快速配置清单 | 新功能上手 |
| **data-permission-quick-start.md** | 数据权限快速配置清单 | 新功能上手 |

### 使用建议

- **第一次学习某个功能**：先读本文档相应章节，理解完整概念
- **日常开发中快速回忆**：查阅 `references/` 对应文件，快速找到关键代码