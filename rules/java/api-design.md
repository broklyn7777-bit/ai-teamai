---
paths:
  - "**/*.java"
---

# Java API 设计规范

> 详细的代码模板、配置示例和排障指南请参见 Skill `uac-api-design`。

## 🔴 核心禁忌

| 禁忌 | 正确做法 |
|---|---|
| Controller 中编写业务逻辑 | Controller 只做校验+调用 |
| Controller 中 try-catch 吞异常 | 全局异常处理 |
| 直接返回 Entity 对象 | 必须使用 VO/DTO 包装 |
| 入参不校验 | JSR-380 + `@Validated` |
| 接口遗漏 `@PreAuthorize` | 所有业务接口必须权限控制 |
| POST/PUT/DELETE 遗漏 `@BussinessLog` | 写操作必须加操作审计 |
| 修改操作遗漏旧数据存储 | Service 层执行 `LogObjectHolder.me().set()` |
| 外部 API 调用不设超时重试 | 连接 5s/读取 10s，非幂等禁重试 |

## 必守原则

1. **URL**：小写+中划线，GET/POST 为主
2. **入参出参**：入参 `XxxQo`，出参 `XxxVo`，统一 `RestResponse<T>`
3. **文档**：Knife4j `@Api`/`@ApiOperation`/`@ApiModelProperty`
4. **幂等**：写接口必须 `@Idempotent`
5. **异常**：定义 `{模块}CodeEnum` + `{模块}Exception`，传完整枚举
6. **日志**：启动类加 `@EnableAccessLog` + `@EnableOperationLog`
7. **外部调用**：Forest 框架，`{业务}Client` 接口定义，配置中心管理 URL

## 🔗 何时调用 uac-api-design Skill？

| 场景 | 用本文件 | 调用 Skill |
|------|---------|-----------|
| 查阅禁忌和快速规范 | ✅ | |
| 设计 RESTful 接口/文档 | | ✅ |
| 配置幂等性 | | ✅ |
| 配置访问/操作日志表 | | ✅ |
| Forest 客户端超时重试 | | ✅ |

完整指南：`skills/uac-api-design/SKILL.md`（6 个专题 + 6 个快速参考）
