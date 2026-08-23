---
name: backend-service-spec-skill
description: 用于旧系统、微服务、平台型仓库的代码知识梳理与中央知识库沉淀。统一支持跨服务 create_codemap、跨服务业务域梳理、crate_router_map、单服务纵切梳理、事实需求抽取。强调严格按代码事实输出，并显式区分 scope、参数清晰度、链路类型、需求证据等级与证据闭环状态。
---

# Backend Service Spec Skill

用于把单服务、跨服务、业务域、通信链路、事实需求五类梳理动作统一成一套可复用知识技能。

## 0. 何时使用

当用户出现以下目标时，使用本技能：

- 想梳理旧系统、微服务、平台型仓库的代码总图
- 想做跨服务调用链、接口链路、消息链路排查
- 想把零散服务文档上卷成“域 -> 服务 -> 规范”三层知识
- 想对单个高价值服务做纵切梳理
- 想在历史 PRD 缺失时，按功能模块从代码事实抽取当前系统事实需求
- 想把代码知识沉淀成团队可复用的中央知识库，而不是停留在一次对话里

如果只是实现功能、修 Bug、写测试，而不是做知识梳理，不优先使用本技能。

## 1. 核心原则

始终遵守以下约束：

- 严格按代码事实输出，不把猜测写成事实
- 先索引，后正文：先建立地图，再沉淀稳定知识页
- Codemap 是索引层，不是最终知识库正文
- 业务域页的价值是“上卷整理”，不是重复抄写服务页
- 跨服务链路必须区分同步调用、异步消息、定时/补偿、实时通道
- 事实需求抽取必须区分当前代码事实、单边线索、数据线索和待人工确认项
- 无法闭环验证的内容必须显式标注证据等级，不能伪装成已确认
- 如果只看到单边依赖、单边契约、单边 producer/listener，不得直接写成双边已确认闭环
- 在进入正式梳理前，先做 workspace 范围识别

## 2. 执行前置：workspace 范围识别

在运行核心功能前，先用最小成本判断当前 scope 属于哪一种：

- `single-system`: 单一系统 / 单一运行时家族
- `service-family`: 同一家族、多服务协作
- `multi-system-workspace`: 多套系统共存的工作区

最少要回答三个问题：

1. 当前 scope 是单系统、服务家族，还是多系统并存工作区
2. 本轮目标是全景索引、关键链路、还是稳定知识页
3. 当前产物应该落在 `mydocs/` 的哪一层

如果识别为 `multi-system-workspace`：

- 第一轮优先 `create_codemap: mode=service_landscape`
- 先切 family，再做闭环链路
- 不要直接上 `build_domain_map`

详见：`references/workspace-classification.md`

## 3. 核心功能

### 3.1 跨服务 `create_codemap`

用途：

- 在多服务、微服务、平台仓库中生成跨服务 CodeMap
- 继承 sdd-riper 的 `create_codemap` 思想，但升级为“服务间视角”
- 不只看单项目结构，还看服务注册、调用方向、依赖关系、上下游角色、关键链路

适用输入：

```text
create_codemap: mode=service_landscape, scope=<系统名或服务群>, goal=<梳理目标>
```

也兼容：

```text
create_codemap: mode=project, scope=<项目名>, goal=<输出项目总图与核心流程>
create_codemap: mode=feature, scope=<关键功能或链路>, goal=<梳理核心入口与主链路>
create_codemap: mode=service_chain, scope=<跨服务业务链>, goal=<梳理服务级链路>
```

输出重点：

- 服务清单
- 服务职责边界
- 服务间调用关系
- 入口与出口
- 同步/异步链路索引
- 外部系统依赖
- 风险热点
- 代码证据来源
- workspace 范围判断

默认产物：

- `mydocs/codemap/YYYY-MM-DD_hh-mm_<name>服务总图.md`
- `mydocs/codemap/YYYY-MM-DD_hh-mm_<name>链路地图.md`

详情模板见 `references/codemap-modes.md`

### 3.2 跨服务业务域梳理

用途：

- 把零散服务知识提升为团队可复用的上下文层
- 形成“域 -> 服务 -> 规范”三层知识结构
- 支持中央仓库、Wiki、OpenSpec、旧系统知识库共建

适用输入：

```text
build_domain_map: scope=<系统或服务群>, goal=<按业务域梳理>
```

输出规则：

- 域层只做上卷整理，不重写服务页全文
- 域层必须区分：强事实承载服务、线索级关联服务、仍待补证关系
- 规范层必须区分：`code-fact-summary` 与 `team-proposed-standard`
- 最好先完成关键服务的 `service_deep_dive`，再做业务域梳理

详情模板见 `references/domain-layering.md`

### 3.3 `crate_router_map`

用途：

- 梳理请求在跨服务之间的完整通信路径
- 同时覆盖同步与异步通信
- 支持接口级和链路级视角
- 支持跨团队、跨技术栈系统

说明：

- 按用户要求，保留命令名 `crate_router_map`
- 也兼容别名 `create_router_map`

适用输入：

```text
crate_router_map: scope=<业务链路或入口>, goal=<梳理跨服务通信链路>
```

输出必须拆开：

- 同步调用链
- 异步消息链
- 定时/补偿链
- 实时通道链（如存在）

证据等级至少区分：

- `fact-closed`
- `fact-send-side`
- `fact-receive-side`
- `contract-visible`
- `clue`

详情模板见 `references/router-map.md`

### 3.4 单服务纵切梳理

用途：

- 对单个高价值服务做系统性纵切
- 形成可长期复用的服务知识页集合

适用输入：

```text
service_deep_dive: scope=<服务名>, goal=<梳理高价值服务>
```

推荐输出：

- `overview.md`
- `entrypoints.md`
- `dependencies.md`
- `mq.md`
- `sources.md`

大服务第二轮按需补：

- `api.md`
- `call-chain.md`
- `external-dependencies.md`
- `route-map.md`
- `topic-detail.md`
- `ws.md`
- `runtime-config.md`
- `risk-and-hotspots.md`

其中 `api.md` 必须显式标注参数清晰度分层：

- 路径级
- 签名级
- DTO 字段级
- payload/schema 级

详情模板见 `references/service-deep-dive.md`

### 3.5 `requirement_fact_map`

用途：

- 在历史 PRD、需求评审记录缺失时，从当前代码事实抽取“系统事实上已经支持了哪些需求”
- 按功能模块沉淀项目需求知识库
- 把接口、页面、任务、消息、配置、数据对象、链路证据上卷为事实需求
- 显式区分已闭环需求、单边事实、数据线索、命名线索和待人工确认项

适用输入：

```text
requirement_fact_map: scope=<系统、服务群、功能模块或关键链路>, goal=<按功能模块抽取当前事实需求>
```

输出重点：

- 功能模块识别依据
- 模块级事实需求列表
- 需求到代码证据矩阵
- 需求证据等级
- 关联 codemap / service_deep_dive / routermap / domain map
- 未闭环需求与人工确认项

默认产物：

- `mydocs/requirements/index.md`
- `mydocs/requirements/modules/<module>.md`
- `mydocs/requirements/evidence/requirement-evidence-matrix.md`
- `mydocs/requirements/gaps/requirement-gaps.md`

详情模板见 `references/requirement-fact-extraction.md`

## 4. 推荐工作流

### 4.1 多系统工作区首轮

```text
classify_workspace -> create_codemap(service_landscape) -> 按 family 拆 scope -> 选关键服务做 service_deep_dive -> 对关键链路做 crate_router_map -> 最后再评估 build_domain_map
```

### 4.2 旧系统中央知识库建设

```text
先做 create_codemap -> 再做关键链路 crate_router_map -> 再做关键服务 service_deep_dive -> 按需做 requirement_fact_map -> 服务事实和事实需求稳定后再做 build_domain_map
```

### 4.3 单服务起步

```text
先做 service_deep_dive -> 若发现明显上下游协作，再补 crate_router_map / build_domain_map
```

## 5. 事实分层规则

输出任何文档时，优先区分：

1. 代码中直接确认
2. 由多处代码交叉确认
3. 只看到发送侧 / 接收侧 / 契约侧，但未闭环
4. 仅为命名、配置、兄弟仓、topic、handler 等线索
5. 团队建议或待定规范

禁止：

- 把命名推测写成业务定义
- 把单边 Feign 依赖写成双边已确认闭环
- 把 MQ producer 存在写成 listener 必然存在
- 把 listener 存在写成 producer 已确认
- 把签名级清晰写成字段级已明确
- 把多系统工作区误写成单系统
- 把代码线索补写成历史 PRD 或产品意图
- 把单服务内部能力写成端到端事实需求
- 把 `clue`、`fact-data-only`、`fact-entry-only` 直接写成已确认需求

## 6. 产物分层

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

使用建议：

- `mydocs/codemap/`：地图索引层
- `mydocs/services/`：单服务纵切知识页
- `mydocs/domains/`：业务域上卷页
- `mydocs/requirements/`：按功能模块沉淀当前系统事实需求、证据矩阵和需求缺口
- `mydocs/routermap/`：跨服务通信链路层
- `mydocs/diagrams/`：图产物层，统一放 Markdown 内嵌 Mermaid 的架构图、调用关系图、依赖图、时序图
- `mydocs/context/`：上下文资料与补充材料
- `mydocs/specs/`：Research / Plan / Review 等过程文档
- `mydocs/validation/`：闭环验证、未闭环清单、质量检查页
- `mydocs/index/`：总索引、导航页与汇总入口

## 7. 必看引用

- `references/workspace-classification.md`
- `references/codemap-modes.md`
- `references/router-map.md`
- `references/domain-layering.md`
- `references/service-deep-dive.md`
- `references/requirement-fact-extraction.md`
- `references/central-repo-conventions.md`
- `references/quality-checklist.md`
- `references/usage-guide.md`
- `references/output-templates.md`
- `references/diagram-output-guidelines.md`
- `references/mermaid-safety-checklist.zh-CN.md`

## 8. 输出风格

- 先给结论，再给结构
- 以事实为主，不写推测性业务发散
- 文件命名稳定，可长期复用
- 目录适合中央仓库团队协作
- 文档默认面向“团队知识复用”，不是一次性分析笔记
- 图产物默认使用 `Markdown + Mermaid`，图片只作为派生结果，不替代源文件
- 图产物默认优先内嵌到对应正文；只有在需要跨文档复用、独立高频更新、集中导出管理，或用户明确要求图文分离时，才拆到 `mydocs/diagrams/`
- 如果图拆到 `mydocs/diagrams/`，正文里仍需保留简短说明和直接链接，保证上下文可读
- Mermaid 节点标签优先写“角色语义”或“动作语义”，不要默认把 `method(arg)` 这类方法签名直接塞进节点
- 精确的方法名、DTO 名、枚举名、Redis key、topic 名等细节保留在图下正文说明中，图节点本身优先保证兼容渲染
- 如果节点文本需要换行，优先拆成短语，不要在同一节点里叠加括号参数、引号、复杂 JSON 和多层标点
- 图产物交付前，按 `references/mermaid-safety-checklist.zh-CN.md` 做最后一轮自检

## 7.5 新增规则页

为弥补长期中央仓库维护能力，本技能新增三份规则型参考页：

- `references/knowledge-lifecycle.md`
- `references/incremental-update-policy.md`
- `references/workflow-state-model.md`

使用时建议：

- 先按 `workspace-classification.md` 判断范围
- 再按 `knowledge-lifecycle.md` 判断优先读取 current 还是 draft
- 再按 `incremental-update-policy.md` 决定增量补齐还是重建
- 最后用 `workflow-state-model.md` 判断当前处于哪种执行状态
