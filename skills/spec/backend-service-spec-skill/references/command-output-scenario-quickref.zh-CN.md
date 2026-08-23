# 服务端技能命令速查表

本文用于帮助用户快速判断：

- 该用哪个命令
- 会产出什么
- 建议放到 `mydocs/` 的哪一层
- 适合什么场景

默认规则：

- 当核心命令按标准产物执行时，默认应一并产出配套图产物
- 只有在范围极小、证据不足以负责任画图，或用户明确要求纯文字输出时，才可以省略图

## 1. `create_codemap`

命令：

```text
create_codemap: mode=service_landscape, scope=<system-or-service-group>, goal=<梳理目标>
```

典型产物：

- 服务清单页
- 服务关系总图
- 技术栈与模块分层页
- 上下游依赖摘要页
- 架构图（Markdown + Mermaid）
- 服务调用关系图（Markdown + Mermaid）

推荐目录：

```text
mydocs/codemap/
```

配套图目录：

```text
mydocs/diagrams/architecture/
mydocs/diagrams/call-graph/
```

适合场景：

- 第一次进入系统
- 想先看全局结构
- 想先识别高价值服务

## 2. `service_deep_dive`

命令：

```text
service_deep_dive: scope=<service-name>, goal=<纵切目标>
```

典型产物：

- 单服务结构页
- 接口清单页
- 模块分区页
- 依赖关系页
- 服务规范页
- 上下游依赖图（Markdown + Mermaid）
- 服务内模块架构图（Markdown + Mermaid）

推荐目录：

```text
mydocs/services/
```

配套图目录：

```text
mydocs/diagrams/upstream-downstream/
mydocs/diagrams/architecture/
```

适合场景：

- 高价值核心服务梳理
- 想先吃透一个服务
- 后面要做域页或链路页

## 3. `crate_router_map`

也兼容：

- `create_router_map`

命令：

```text
crate_router_map: scope=<business-chain-or-entry>, goal=<梳理通信链路>
```

典型产物：

- 关键链路页
- 同步调用页
- 异步消息页
- 补偿/重试页
- 链路闭环状态页
- 时序图（Markdown + Mermaid）
- 链路调用图（Markdown + Mermaid）

推荐目录：

```text
mydocs/routermap/
```

配套图目录：

```text
mydocs/diagrams/sequence/
mydocs/diagrams/call-graph/
```

适合场景：

- 想追一条真实请求
- 想梳理消息链路
- 想区分 sync / async / compensation

## 4. `build_domain_map`

命令：

```text
build_domain_map: scope=<system-or-service-group>, goal=<按业务域梳理>
```

典型产物：

- 业务域页
- 域 -> 服务 -> 规范 映射页
- 域内关键链路摘要页
- 域级规则页
- 域上下文图（Markdown + Mermaid）

推荐目录：

```text
mydocs/domains/
```

配套图目录：

```text
mydocs/diagrams/architecture/
```

适合场景：

- 做团队中央知识库
- 需要跨服务业务域抽象
- 想把服务事实提升成长期可复用知识页

## 5. `requirement_fact_map`

命令：

```text
requirement_fact_map: scope=<system-or-module-or-chain>, goal=<按功能模块抽取当前事实需求>
```

典型产物：

- 事实需求总索引
- 功能模块事实需求页
- 需求到代码证据矩阵
- 未闭环需求与人工确认项

推荐目录：

```text
mydocs/requirements/
```

适合场景：

- 历史 PRD 或需求依据缺失
- 需要按功能模块理解系统当前实际能力
- 重构、迁移、补测试前需要确认事实需求边界

## 6. 轻量全量

典型产物组合：

- 范围识别页
- codemap 总图页
- 1 到 2 份单服务纵切页
- 1 到 2 份关键链路页
- 事实需求索引页（按需）
- 总索引页
- 默认还应包含 codemap、选定服务、选定链路的配套图产物

推荐目录：

```text
mydocs/
  codemap/
  services/
  requirements/
  routermap/
  diagrams/
```

适合场景：

- 第一次进入项目
- 想控制 token 成本
- 想先拿一版可靠基线

## 7. 重型全量

典型产物组合：

- 范围识别页
- codemap 总图页
- 多份单服务纵切页
- 多份关键链路页
- 事实需求索引页（按需）
- 业务域页
- 验证页
- 未闭环清单
- 总索引页
- 默认还应包含 codemap、服务、链路、业务域的配套图产物

推荐目录：

```text
mydocs/
  codemap/
  services/
  domains/
  requirements/
  routermap/
  diagrams/
  context/
  specs/
  validation/
  index/
```

适合场景：

- 核心系统知识沉淀
- 团队中央知识库建设
- 想做更完整的长期基线
