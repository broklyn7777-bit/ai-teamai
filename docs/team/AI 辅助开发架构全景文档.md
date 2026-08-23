# AI Coding 实现架构

> AI 辅助开发架构全景文档
> 生成日期：2026-06-16

---

## 一、总体架构全景

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         IBS 智能业务系统 — AI Coding 全景                      │
│                    Spring Boot 3.5.0 · JDK 21 · Spring Cloud 2025           │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌─────────────────────── Workflow Routing (意图路由) ──────────────────────┐ │
│  │                                                                          │ │
│  │   用户输入                                                                │ │
│  │     │                                                                    │ │
│  │     ├─► /openspec-superpowers-workflow   复杂功能端到端总控（8步）          │ │
│  │     ├─► /superpowers-openspec-execution  需求模糊→探索→OpenSpec→TDD（9步） │ │
│  │     ├─► /superpowers-feature-workflow    轻量功能 探索→方案→TDD→验证（7步） │ │
│  │     └─► /openspec-feature-workflow       纯 OpenSpec 产物生成（5步）       │ │
│  │                                                                          │ │
│  └──────────────────────────────────────────────────────────────────────────┘ │
│                                    │                                          │
│  ╔═════════════════════════════════╪═══════════════════════════════════════╗  │
│  ║                    Superpowers 编排引擎 (5 阶段)                         ║  │
│  ║                                                                          ║  │
│  ║  Phase 1         Phase 2          Phase 3          Phase 4       Phase 5  ║  │
│  ║  ┌──────────┐   ┌──────────┐    ┌──────────┐    ┌──────────┐  ┌────────┐║  │
│  ║  │brainstorm│──►│writing-  │───►│subagent- │───►│verify-   │──│finish- │║  │
│  ║  │(探索/澄清)│   │plans     │    │driven    │    │before    │  │ing-a   │║  │
│  ║  │方案对比   │   │(实现计划) │    │dev+TDD   │    │complete  │  │branch  │║  │
│  ║  └──────────┘   └──────────┘    └──────────┘    └──────────┘  └────────┘║  │
│  ║                                    │                                      ║  │
│  ║                          ┌─────────┴──────────┐                           ║  │
│  ║                          │  TDD: RED→GREEN→   │                           ║  │
│  ║                          │  REFACTOR 循环      │                           ║  │
│  ║                          └────────────────────┘                           ║  │
│  ╚════════════════════════════════════════════════════════════════════════════╝  │
│                                    │                                          │
├────────────────────────────────────┼──────────────────────────────────────────┤
│                                    │                                          │
│  ┌──────────────────── Agent 智能体层 (15 Agents) ───────────────────────────┐ │
│  │                                                                            │ │
│  │  ┌─ 编排决策层 (Opus) ─┐  ┌─ 执行层 (Sonnet) ────────────────────────┐    │ │
│  │  │  architect  系统设计  │  │  code-reviewer    代码质量审查              │    │ │
│  │  │  planner    实现规划  │  │  java-reviewer    Java/Spring Boot 专家    │    │ │
│  │  └──────────────────────┘  │  security-reviewer 安全/OWASP 扫描         │    │ │
│  │                             │  tdd-guide        测试驱动开发             │    │ │
│  │  ┌─ 专项修复层 (Sonnet) ─┐  │  build-error-resolver 构建错误修复       │    │ │
│  │  │  java-build-resolver  │  └──────────────────────────────────────────┘    │ │
│  │  │  database-reviewer   │                                                   │ │
│  │  │  refactor-cleaner    │  ┌─ 辅助层 ─────────────────────────────────┐    │ │
│  │  └──────────────────────┘  │  e2e-runner · doc-updater · docs-lookup  │    │ │
│  │                             │  python-reviewer · typescript-reviewer    │    │ │
│  │                             └──────────────────────────────────────────┘    │ │
│  └────────────────────────────────────────────────────────────────────────────┘ │
│                                    │                                          │
├────────────────────────────────────┼──────────────────────────────────────────┤
│                                    │                                          │
│  ┌────────────── 技术领域 SKILL 层 (10 UAC Skills) ─────────────────────────┐ │
│  │                                                                            │ │
│  │  ┌─ 核心架构 ──────────┐  ┌─ 数据层 ──────────┐  ┌─ 中间件 ───────────┐  │ │
│  │  │ uac-project-arch    │  │ uac-database      │  │ uac-kafka-messaging│  │ │
│  │  │ 4层模块·分层架构     │  │ MyBatis-Plus     │  │ sf-kafka-api-core  │  │ │
│  │  │ 构造注入·MapStruct   │  │ ShardingSphere   │  │ Kafka 2.5.1+      │  │ │
│  │  └─────────────────────┘  └──────────────────┘  └────────────────────┘  │ │
│  │  ┌─ API & 安全 ────────┐  ┌─ 缓存 & 调度 ─────┐  ┌─ 通用能力 ─────────┐  │ │
│  │  │ uac-api-design      │  │ uac-redis-cache   │  │ uac-excel-process  │  │ │
│  │  │ uac-security        │  │ uac-schedule-tasks│  │ uac-intl           │  │ │
│  │  │ Spring Security    │  │ saturn-spring      │  │ uac-file-storage │  │ │
│  │  └─────────────────────┘  └──────────────────┘  └────────────────────┘  │ │
│  └────────────────────────────────────────────────────────────────────────────┘ │
│                                    │                                          │
├────────────────────────────────────┼──────────────────────────────────────────┤
│                                    │                                          │
│  ┌─────────────── 规则引擎 Rules (30 Rules × 4 Languages) ─────────────────┐ │
│  │                                                                            │ │
│  │  common/ (8)     java/ (12)     typescript/ (5)    python/ (5)             │ │
│  │  ├ coding-style   ├ coding-style  ├ coding-style     ├ coding-style       │ │
│  │  ├ patterns       ├ patterns      ├ patterns         ├ patterns           │ │
│  │  ├ security       ├ security      ├ security         ├ security           │ │
│  │  ├ testing        ├ testing       ├ testing          ├ testing            │ │
│  │  ├ agents         ├ api-design    └ hooks            └ hooks              │ │
│  │  ├ hooks          ├ database                                              │ │
│  │  ├ performance    ├ redis-cache                                           │ │
│  │  ├ superpowers-wf ├ kafka-messaging  ┌─ Hooks System (25+ Hooks) ──┐      │ │
│  │  └ ...            ├ schedule-tasks   │ PreToolUse  PostToolUse      │      │ │
│  │                    ├ excel/file/i18n  │ Stop        SessionStart     │      │ │
│  │                    └ ...              └─────────────────────────────┘      │ │
│  └────────────────────────────────────────────────────────────────────────────┘ │
│                                    │                                          │
├────────────────────────────────────┼──────────────────────────────────────────┤
│                                    │                                          │
│  ┌──────────────── 项目模块层 (Microservices) ──────────────────────────────┐ │
│  │                                                                            │ │
│  │  ┌───────────┐ ┌──────────┐ ┌─────────┐ ┌────────┐ ┌──────────┐         │ │
│  │  │gis-lbc-   │ │gis-lbc-  │ │gis-lbc- │ │gis-lbc-│ │uac-      │         │ │
│  │  │ibs-base   │ │ibs-demo  │ │ibs-     │ │ibs-mdc │ │project   │         │ │
│  │  │(框架层)    │ │(开发/测试)│ │gateway  │ │(主数据) │ │(认证中心) │         │ │
│  │  │v3.0.0.0   │ │          │ │(网关)   │ │        │ │v3.1.0.0  │         │ │
│  │  │orion-*    │ │.claude/  │ │         │ │        │ │          │         │ │
│  │  └───────────┘ └──────────┘ └─────────┘ └────────┘ └──────────┘         │ │
│  │                                                                            │ │
│  │  ┌─────────────────────── OpenSpec 知识资产 ──────────────────────────┐    │ │
│  │  │  proposal.md  →  design.md  →  specs/**/spec.md  →  tasks.md      │    │ │
│  │  └───────────────────────────────────────────────────────────────────┘    │ │
│  └────────────────────────────────────────────────────────────────────────────┘ │
│                                    │                                          │
├────────────────────────────────────┼──────────────────────────────────────────┤
│                                    │                                          │
│  ┌──────────────── 持久化记忆层 ────────────────────────────────────────────┐ │
│  │                                                                            │ │
│  │  .superpowers-memory/                   graphify-out/                      │ │
│  │  ├ PROJECT_CONTEXT.md  (项目背景)        ├ GRAPH_REPORT.md  (代码图谱)      │ │
│  │  ├ CURRENT_STATE.md    (当前状态)        └ wiki/index.md    (知识索引)      │ │
│  │  ├ LEARNING_BACKLOG.md (可复用经验)                                          │ │
│  │  └ session-journal/    (会话日志)         Knowledge Graph Hook:             │ │
│  │                                         Glob/Grep 自动注入图谱上下文        │ │
│  └────────────────────────────────────────────────────────────────────────────┘ │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 二、AI SDD 双引擎对比

| 维度         | OpenSpec 引擎                          | Superpowers 引擎                          |
| ------------ | -------------------------------------- | ----------------------------------------- |
| **管理对象** | 知识资产（specs / design / tasks）     | 代理行为（TDD / 审查 / 子代理）           |
| **核心优势** | Spec 驱动 + 变更追溯 + 知识积累        | 子代理隔离 + TDD 强制 + 自动审查          |
| **核心短板** | 无 TDD、无子代理、无 git 集成          | 平台依赖强、token 开销大、无 spec 管理    |
| **产物**     | `proposal.md` `design.md` `specs/` `tasks.md` | 代码 + 测试 + 审查报告 + 记忆文件 |

**双引擎协同模式**：`openspec-superpowers` 工作流将两者融合 — OpenSpec 负责"定义做什么"，Superpowers 负责"怎么做"。

---

## 三、工作流路由决策树

```
用户意图输入
    │
    ├── 复杂功能 + 跨团队 + 需完整规格？
    │       └─► openspec-superpowers（8步，双引擎融合）
    │
    ├── 需求模糊 + 需先探索再固化？
    │       └─► superpowers-openspec-execution（9步，三明治式）
    │
    ├── 独立功能 + 快速迭代？
    │       └─► superpowers-feature（7步，轻量无 OpenSpec）
    │
    └── 仅做需求定义/规格整理？
            └─► openspec-feature（5步，纯 CLI 驱动）
```

---

## 四、各领域 SKILL 详细规格

| #  | Skill                    | 定位               | 技术栈                                   |
|----|--------------------------|--------------------|------------------------------------------|
| 1  | uac-api-design           | RESTful API 设计   | Spring Boot 2.5.5+, Knife4j 2.0.9+, Forest |
| 2  | uac-database             | 数据库设计         | MyBatis-Plus 3.4.3.4+, MySQL 5.7+, ShardingSphere 3.1.0+ |
| 3  | uac-excel-processing     | Excel 处理         | EasyExcel 2.x+, POI 3.17+, JSR-380        |
| 4  | uac-file-storage         | 文件存储安全       | orion-starter-filestore, SOSS/OSS/FTP     |
| 5  | uac-internationalization | 国际化             | orion-starter-i18n, UAC Feign API         |
| 6  | uac-kafka-messaging      | 消息队列           | sf-kafka-api-core 1.20.3+, Kafka 2.5.1+   |
| 7  | uac-project-architecture | 项目架构守护       | Spring Boot 2.5.5+, Lombok 1.18.16+, Java 8+ |
| 8  | uac-redis-cache          | 缓存优化           | orion-starter-redis, Redis 5.0+            |
| 9  | uac-schedule-tasks       | 分布式调度         | saturn-spring 3.6.9+, ZooKeeper            |
| 10 | uac-security             | 安全防护           | Spring Security 2.5.2+, orion-crypto, Jasypt |

---

## 五、Agent 智能体清单

| Agent                  | Model   | 职责                              |
|------------------------|---------|-----------------------------------|
| architect              | Opus    | 系统设计、可扩展性、ADR           |
| planner                | Opus    | 实现规划、步骤分解                |
| code-reviewer          | Sonnet  | 多语言代码质量审查                |
| java-reviewer          | Sonnet  | Java/Spring Boot 专项审查         |
| security-reviewer      | Sonnet  | OWASP Top 10、密钥检测、漏洞扫描  |
| tdd-guide              | Sonnet  | RED → GREEN → REFACTOR、80%+ 覆盖 |
| build-error-resolver   | Sonnet  | 最小 diff 修复构建错误            |
| java-build-resolver    | Sonnet  | Java 专项构建修复                 |
| database-reviewer      | —       | 数据库设计审查                    |
| refactor-cleaner       | —       | 死代码清理                        |
| e2e-runner             | —       | 端到端测试执行                    |
| doc-updater            | —       | 文档维护                          |
| docs-lookup            | —       | 文档检索                          |
| python-reviewer        | —       | Python 代码审查                   |
| typescript-reviewer    | —       | TypeScript 代码审查               |

---

## 六、规则引擎结构

```
rules/
├── common/                    # 8 条跨语言通用规则
│   ├── agents.md              # 智能体编排 + 自动触发规则
│   ├── coding-style.md        # 简洁优先、不可变性、最小改动
│   ├── hooks.md               # Hook 系统参考
│   ├── patterns.md            # Repository、分层架构、错误传播
│   ├── performance.md         # 模型选择策略、上下文管理
│   ├── security.md            # 提交前安全必检清单
│   ├── superpowers-workflow.md # 5 种完整工作流定义
│   └── testing.md             # 80% 覆盖率、TDD 强制
│
├── java/                      # 12 条 Java 专用规则
│   ├── api-design.md
│   ├── coding-style.md
│   ├── database.md
│   ├── excel-processing.md
│   ├── file-storage.md
│   ├── hooks.md
│   ├── internationalization.md
│   ├── kafka-messaging.md
│   ├── patterns.md
│   ├── redis-cache.md
│   ├── schedule-tasks.md
│   ├── security.md
│   └── testing.md
│
├── typescript/                # 5 条 TypeScript 专用规则
│   ├── coding-style.md
│   ├── hooks.md
│   ├── patterns.md
│   ├── security.md
│   └── testing.md
│
└── python/                    # 5 条 Python 专用规则
    ├── coding-style.md
    ├── hooks.md
    ├── patterns.md
    ├── security.md
    └── testing.md
```

---

## 七、Hooks 全生命周期治理

| 生命周期事件    | 关键 Hooks                                                              |
| --------------- | ----------------------------------------------------------------------- |
| **SessionStart** | 上下文引导 + 包管理器检测                                                |
| **PreToolUse**   | block-no-verify、auto-tmux-dev、git-push-reminder、commit-quality、doc-file-warning、suggest-compact、continuous-learning、InsAIts-security、governance-capture、config-protection、MCP-health-check |
| **PostToolUse**  | 命令审计日志、成本追踪、PR 创建日志、构建完成分析、quality-gate、edit-accumulator、console-warn |
| **Stop**         | 批量格式化 + 类型检查（Biome/tsc）、Spring Java 格式化、console.log 检查、session-end 持久化、session 评估、桌面通知 |
| **PreCompact**   | 上下文压缩前状态保存                                                     |
| **SessionEnd**   | 生命周期结束标记                                                         |

---

## 八、项目模块层

| 模块                   | 角色          | 版本      | 说明                              |
|------------------------|---------------|-----------|-----------------------------------|
| `gis-lbc-ibs-base`     | 框架层        | v3.0.0.0  | orion-* 核心模块、安全、加密、DB   |
| `gis-lbc-ibs-demo`     | 开发/测试     | —         | 主工作区，含完整 .claude/ 配置      |
| `gis-lbc-ibs-gateway`  | API 网关      | —         | 路由、限流、鉴权                   |
| `gis-lbc-ibs-gen`      | 代码生成      | —         | 脚手架、模板生成                   |
| `gis-lbc-ibs-mdc`      | 主数据中心    | —         | 主数据管理                         |
| `uac-project`          | 认证中心      | v3.1.0.0  | OAuth2、6 种认证方式、前端 UI      |

---

## 九、关键技术洞察

1. **分层隔离设计**：规则引擎（Rules）→ 技能层（Skills）→ 智能体层（Agents）三层解耦，规则约束行为边界，技能提供领域知识，智能体负责实际执行

2. **知识图谱增强**：通过 `graphify` Hook 在 Glob/Grep 工具调用时自动注入代码结构图谱，让 AI 在搜索代码前先理解"代码地图"

3. **持久化记忆系统**：`.superpowers-memory/` 实现跨会话记忆 — `PROJECT_CONTEXT.md` 固定项目背景，`CURRENT_STATE.md` 追踪进行中的工作，`session-journal/` 记录决策历史

4. **Hooks 全生命周期治理**：25+ Hooks 覆盖 PreToolUse → PostToolUse → Stop → SessionStart/End 全链路，实现安全监控、成本追踪、质量门禁的自动化

5. **双引擎协同**：OpenSpec 负责规格定义与知识沉淀，Superpowers 负责执行编排与质量保障，两者通过 `openspec-superpowers` 工作流实现无缝融合
