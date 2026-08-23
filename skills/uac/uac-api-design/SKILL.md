---
name: uac-api-design
description: |
  RESTful API 设计专家。用于设计 RESTful API、实现 Controller 端点、创建 DTO/VO、配置参数验证、处理 API 文档和日志。
  覆盖幂等接口设计、统一响应处理、异常标准化、外部 API 集成模式。包括 Knife4j/Swagger 文档化、访问日志、操作审计规范、Forest 客户端。
  触发关键词："接口"、"API"、"Controller"、"DTO"、"VO"、"参数"、"返回值"、"Swagger"、"Knife4j"、"端点"、"文档"、"幂等"、"Idempotent"、"BussinessLog"、"操作日志"、"访问日志"、"RestResponse"、"Forest"、"外部接口"、"超时"、"重试"
compatibility: Requires Spring Boot 2.5.5+, Spring Web MVC, Knife4j 2.0.9+, Forest HTTP client
---

# Skill: API-Development
# 适用场景：Controller、接口开发、DTO、VO、参数校验、返回值、文档、接口日志、接口幂等

## 一、RESTful 与参数返回规范

- URL 使用小写 + 中划线，统一使用 GET/POST
- 入参 `XxxQo`，出参 `XxxVo`，分页 `PageParam`/`PageBean`
- 必须使用 JSR380 校验配合 `@Validated`
- 统一返回 `RestResponse<T>`，错误码使用枚举

详见 `references/restful-rules.md`

## 二、Controller 编写铁律与文档

- `@RestController` + `@RequestMapping`，禁止编写业务逻辑
- Controller 中禁止异常捕获
- Knife4j 文档：`@Api`、`@ApiOperation`、`@ApiModelProperty`
- 所有业务接口必须 `@PreAuthorize`，禁止硬编码权限检查

详见 `references/controller-rules.md`

## 三、接口幂等性

- 数据写入/状态变更接口必须实现幂等性控制
- 统一使用 `orion-spring-boot-starter-idempotent` + `@Idempotent` 注解
- 仅 POST/PUT/DELETE 接口需加幂等注解，GET 接口禁止使用

详见 `references/idempotent-tips.md`

## 四、异常处理规范

- 模块定义 `{模块名}CodeEnum` 实现 `ExceptionEnums`，异常码 = 模块主码 + 子码
- 核心模块创建 `{模块名}Exception` 继承 `RuntimeException`
- 必须传入完整枚举，禁用纯数字/字符串
- Controller 中禁止异常捕获，由框架全局异常处理

详见 `references/exception-rules.md`

## 五、接口日志规范

- 访问日志：启动类加 `@EnableAccessLog`，自动采集请求信息
- 操作日志：启动类加 `@EnableOperationLog`，新增/修改加 `@BussinessLog`
- 修改操作必须通过 `LogObjectHolder.me().set(旧数据)` 存储原始数据
- 日志表必须配置自动分区（保留 24 个月），包含 `tenant_id` 字段

详见 `references/log-config.md`

## 六、外部接口调用（Forest）

- 统一使用 `forest-spring-boot-starter`，禁止 HttpClient/RestTemplate
- 接口类定义在 `{module}-biz` 模块的 `remote` 包下，命名 `{业务名}Client`
- URL 和敏感信息必须配置中心管理，禁止硬编码
- 必须设置超时（连接 5s/读取 10s），非幂等操作禁止重试
- 远程调用异常统一转换为业务异常，禁止直接向上游暴露

详见 `references/forest-client-tips.md`

## 红线禁忌

### 日志
- ⛔ 禁止 POST/PUT/DELETE 接口遗漏 `@BussinessLog`（GET 除外）
- ⛔ 禁止 `@BussinessLog` 的 `operation` 参数为英文，必须中文清晰表达
- ⛔ 禁止修改操作遗漏 `LogObjectHolder.me().set(旧数据)`，必须在 Service 层执行
- ⛔ 禁止跳过日志表自动分区配置

### 权限与安全
- ⛔ 禁止业务接口遗漏 `@PreAuthorize`，禁止匿名访问
- ⛔ 禁止硬编码权限检查，必须声明式权限
- ⛔ 禁止跳过数据归属校验，增删改必须校验归属防越权

### 代码分层与返回值
- ⛔ 禁止在 Controller 中编写业务逻辑
- ⛔ 禁止直接返回 Entity 对象，必须使用 VO/DTO 包装
- ⛔ 禁止入参不校验，必须 JSR-380 + `@Validated`
- ⛔ 禁止接口返回值不遵循统一格式，必须 `RestResponse<T>`

### 外部接口
- ⛔ 禁止外部 API 调用不做超时和重试配置

---

## 📚 快速参考文件导航

| 文件名 | 用途 | 适用场景 |
|---|---|---|
| **restful-rules.md** | RESTful URL、参数校验、返回体格式 | 快速查表 |
| **controller-rules.md** | Controller 铁律、Knife4j 文档、权限控制 | 快速查表 |
| **idempotent-tips.md** | 幂等性配置、@Idempotent 用法、Redis 配置 | 快速查表 |
| **exception-rules.md** | 异常枚举、异常类定义、抛出规范 | 快速查表 |
| **log-config.md** | 访问日志、操作日志、表结构、分区配置 | 快速查表 |
| **forest-client-tips.md** | Forest 接口定义、配置、超时重试、异常处理 | 快速查表 + 故障排查 |
