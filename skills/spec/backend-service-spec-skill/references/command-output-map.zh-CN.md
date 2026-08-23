# 服务端基础技能命令产物对照

本文用于说明 `backend-service-spec-skill` 中各个常用命令执行后，通常会产出什么文档，以及这些文档在 `mydocs/` 中应属于哪一层。

图放置规则：

- 默认优先把图直接内嵌到对应正文文档
- 只有在图需要跨文档复用、需要独立高频更新、需要集中资产管理或导出，或用户明确要求图文分离时，才使用 `mydocs/diagrams/`
- 如果图拆分到了 `mydocs/diagrams/`，正文中仍应保留简短说明，并附上该图的直接链接

注意：

- 这里说的是“推荐标准产物”，不是强制唯一文件名
- 真实文件名、日期前缀、目录结构可以按团队约定调整
- 如果本轮范围较小，部分产物可以合并
- 如果证据不足，应输出 `partially closed`、`clue-level` 或 `unresolved`

## 1. `create_codemap`

推荐命令：

```text
create_codemap: mode=service_landscape, scope=<system-or-service-group>, goal=<梳理目标>
```

默认产物：

- 服务清单页
- 服务关系总图
- 技术栈与模块分层页
- 上下游依赖摘要页
- 本轮范围说明页
- 架构图（Markdown + Mermaid）
- 服务调用关系图（Markdown + Mermaid）

常见落点目录：

```text
mydocs/codemap/
```

推荐配套图目录：

```text
mydocs/diagrams/architecture/
mydocs/diagrams/call-graph/
```

## 2. `service_deep_dive`

推荐命令：

```text
service_deep_dive: scope=<service-name>, goal=<纵切目标>
```

默认产物：

- 单服务结构页
- 接口清单页
- 模块分区页
- 依赖关系页
- 服务规范页
- 风险点与未闭环页
- 上下游依赖图（Markdown + Mermaid）
- 服务内模块架构图（Markdown + Mermaid）

常见落点目录：

```text
mydocs/services/
```

推荐配套图目录：

```text
mydocs/diagrams/upstream-downstream/
mydocs/diagrams/architecture/
```

## 3. `crate_router_map`

也兼容：

- `create_router_map`

推荐命令：

```text
crate_router_map: scope=<business-chain-or-entry>, goal=<梳理通信链路>
```

默认产物：

- 关键链路页
- 调用路径分段页
- 同步调用页
- 异步消息页
- 补偿/重试/实时通道页
- 链路闭环状态页
- 时序图（Markdown + Mermaid）
- 链路调用图（Markdown + Mermaid）

常见落点目录：

```text
mydocs/routermap/
```

推荐配套图目录：

```text
mydocs/diagrams/sequence/
mydocs/diagrams/call-graph/
```

## 4. `build_domain_map`

推荐命令：

```text
build_domain_map: scope=<system-or-service-group>, goal=<按业务域梳理>
```

默认产物：

- 业务域页
- 域 -> 服务 -> 规范 映射页
- 域内关键链路摘要页
- 域级约束与规则页
- 域页事实边界说明
- 域上下文图（Markdown + Mermaid）

常见落点目录：

```text
mydocs/domains/
```

推荐配套图目录：

```text
mydocs/diagrams/architecture/
```

## 5. `requirement_fact_map`

推荐命令：

```text
requirement_fact_map: scope=<system-or-module-or-chain>, goal=<按功能模块抽取当前事实需求>
```

默认产物：

- 事实需求总索引
- 功能模块事实需求页
- 需求到代码证据矩阵
- 未闭环需求与人工确认项
- 关联 codemap / service_deep_dive / routermap / domain map 的需求索引

常见落点目录：

```text
mydocs/requirements/
```

## 6. 轻量全量分析

典型流程：

1. 范围识别
2. `create_codemap`
3. 1 到 2 个 `service_deep_dive`
4. 1 到 2 条 `crate_router_map`
5. 按需 `requirement_fact_map`

默认产物组合：

- 1 份范围识别页
- 1 份 codemap 总图页
- 1 到 2 份单服务纵切页
- 1 到 2 份关键链路页
- 1 份事实需求索引页（按需）
- 1 份总索引页

## 7. 重型全量分析

典型流程：

1. 范围识别
2. `create_codemap`
3. 多个 `service_deep_dive`
4. 多条 `crate_router_map`
5. 按需 `requirement_fact_map`
6. `build_domain_map`
7. 验证页与未闭环清单

默认产物组合：

- 1 份范围识别页
- 1 份 codemap 总图页
- 多份单服务纵切页
- 多份关键链路页
- 1 份事实需求索引页（按需）
- 1 份业务域页
- 1 份验证页
- 1 份未闭环清单
- 1 份总索引页

## 8. 推荐目录结构

```text
mydocs/
  README.md
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

图产物格式约定：

- 默认使用 `.md`
- 图块使用 Mermaid
- 图片导出只作为派生结果，不替代源 Markdown
