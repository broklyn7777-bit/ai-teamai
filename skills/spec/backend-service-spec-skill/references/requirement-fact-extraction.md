# 事实需求抽取

本文定义 `requirement_fact_map` 的使用口径，用于在历史 PRD、需求评审记录、产品说明缺失时，从当前项目代码事实中抽取“系统事实上已经支持了哪些需求”，并沉淀为项目需求知识库。

## 1. 定位

`requirement_fact_map` 不是补写历史 PRD，也不是根据命名想象产品意图。

它只回答：

- 当前系统已经实现了哪些功能模块
- 每个功能模块下有哪些事实需求
- 这些事实需求由哪些接口、页面、任务、消息、配置、数据对象或链路支撑
- 哪些需求已经代码闭环，哪些只是单边事实或线索
- 哪些需求边界需要人工补证

推荐在已有 `create_codemap`、`service_deep_dive`、`crate_router_map` 产物后执行。缺少前置产物时，也可以做轻量抽取，但必须显式降低证据等级。

## 2. 适用输入

```text
requirement_fact_map: scope=<系统、服务群、功能模块或关键链路>, goal=<按功能模块抽取当前事实需求>
```

常见场景：

- 历史项目缺少 PRD，需要补一层“当前事实需求”知识库
- 接手旧系统时，需要按功能模块理解系统实际支持的能力
- 准备重构、迁移、补测试前，需要先确认事实需求边界
- 需要把代码知识上卷给产品、测试、研发共同阅读

## 3. 推荐工作流

```text
create_codemap
-> service_deep_dive
-> crate_router_map
-> requirement_fact_map
-> build_domain_map
```

如果只需要快速建立需求索引，可以使用轻量流程：

```text
create_codemap
-> requirement_fact_map
-> validation/gaps
```

轻量流程必须在结果中标注“未完成链路闭环验证”。

## 4. 默认产物

```text
mydocs/
  requirements/
    index.md
    modules/
      <module>.md
    evidence/
      requirement-evidence-matrix.md
    gaps/
      requirement-gaps.md
```

目录职责：

- `mydocs/requirements/index.md`：事实需求总索引，按功能模块组织入口
- `mydocs/requirements/modules/`：模块级事实需求页
- `mydocs/requirements/evidence/`：需求到代码证据的矩阵
- `mydocs/requirements/gaps/`：未闭环需求、证据缺口、人工确认项

## 5. 证据等级

事实需求必须标注证据等级：

- `fact-closed`：入口、服务实现、数据或链路证据可闭环，基本可作为当前事实需求
- `fact-entry-only`：只看到入口，例如 controller、page、menu、job trigger
- `fact-service-only`：只看到服务实现，缺少真实入口或调用方
- `fact-data-only`：只从表字段、枚举、配置、Redis key 等数据形态看到能力线索
- `fact-send-side`：只看到发送侧、调用侧或 producer
- `fact-receive-side`：只看到接收侧、被调侧或 listener
- `contract-visible`：只看到接口契约、DTO、OpenAPI、Feign 签名等契约证据
- `clue`：仅有命名、注释、历史残留、兄弟仓线索
- `unknown`：当前代码证据不足，无法判断

禁止把 `clue`、`fact-data-only`、`fact-entry-only` 直接写成已确认需求。

## 6. 模块页模板

```md
# <功能模块> 事实需求

## 模块识别依据

- 包路径：
- 接口前缀：
- 页面 / 菜单：
- 表 / 集合：
- 消息主题：
- 关联服务：

## 事实需求列表

| 需求ID | 事实需求 | 证据等级 | 入口 | 支撑服务 | 关联链路 | 未闭环项 |
| --- | --- | --- | --- | --- | --- | --- |
| REQ-XXX-001 | 用户可以执行某业务动作 | fact-closed | POST /xxx | xxx-service | routermap/xxx.md | 无 |

## 关键业务规则

- 规则：
- 证据：
- 证据等级：

## 关联产物

- Codemap：
- Service Deep Dive：
- Router Map：
- Domain Map：
```

## 7. 单条需求模板

```md
## REQ-XXX-001：<事实需求名称>

### 当前事实结论

系统当前支持……

### 功能模块

<模块名>

### 证据等级

fact-closed / fact-entry-only / clue / ...

### 代码证据

- 入口：
- 服务实现：
- 数据对象：
- 配置：
- 消息 / 任务：

### 业务规则

- 规则 1：
- 规则 2：

### 关联链路

- `mydocs/routermap/...`

### 未闭环问题

- 待确认：
```

## 8. 抽取规则

优先从强证据抽取：

1. 对外入口：controller、route、page、menu、job trigger、message listener
2. 应用服务：application service、handler、use case、processor
3. 业务对象：DTO、command、event、entity、状态枚举
4. 持久化与配置：表、字段、索引、配置项、Redis key、缓存策略
5. 链路证据：同步调用、异步消息、回调、补偿任务
6. 横切证据：权限、租户、灰度、幂等、风控、审计、通知

抽取时应避免：

- 只凭方法名推导完整产品需求
- 把技术能力写成用户需求，例如“有 Redis 缓存”不是事实需求
- 把历史残留代码写成当前仍然生效的需求
- 把单服务内部能力写成端到端能力
- 把异常分支、补偿逻辑写成主流程需求

## 9. 与其他产物的关系

```text
codemap       回答“系统有哪些部分”
services      回答“服务内部有什么能力”
routermap     回答“请求/消息怎么跑通”
requirements  回答“当前系统事实支持了哪些需求”
domains       回答“这些事实可以沉淀成哪些业务域知识”
validation    回答“哪些已闭环、哪些仍需补证”
```

`requirement_fact_map` 应消费前面几层事实产物，并把结论写回 `mydocs/requirements/`。如果发现需求证据不足，应同步记录到 `mydocs/validation/` 或 `mydocs/requirements/gaps/`。
