# Superpowers 工作流指南（总结）

> 本文总结自项目 `docs/superpowers-doc/`（superpowers流程指南 + superpowers-skill-routing）。对应的 12 个基础技能与 4 个工作流技能已入团队仓库 `skills/superpowers/` 与 `skills/workflow/`。

## 一、Superpowers 基础技能（12 个，见 skills/superpowers/）

| 技能 | 职责 |
|------|------|
| using-superpowers | 元入口，管控所有 skill 调用 |
| brainstorming | 探索 → 澄清 → 方案比较 → 设计文档 |
| writing-plans | 将设计分解为可执行小任务 |
| executing-plans | 独立会话执行计划 |
| subagent-driven-development | 当前会话子代理驱动开发（推荐） |
| test-driven-development | RED → GREEN → REFACTOR |
| using-git-worktrees | 工作树隔离（必需） |
| verification-before-completion | 完成前全量验证（横切所有步骤） |
| requesting-code-review / receiving-code-review | 发起 / 处理代码审查 |
| systematic-debugging | 系统性 4 步调试 |
| dispatching-parallel-agents | 独立任务并行调度 |

## 二、四个工作流及选型（见 skills/workflow/）

| 场景 | 推荐工作流 | 特点 |
|------|-----------|------|
| 大型跨团队功能，需完整规格和设计 | `openspec-superpowers-workflow` | 8 步，双重产物（Superpowers 设计文档 + OpenSpec 规格） |
| 需要严格规格追踪（合规/审计） | `superpowers-openspec-execution-workflow` | 9 步三明治式：探索 → OpenSpec 固化 → 实现验证 → 归档 |
| 独立功能、快速迭代 | `superpowers-feature-workflow` | 7 步，不生成 OpenSpec 产物，轻量 |
| 仅需求定义/规格固化（不写代码） | `openspec-feature-workflow` | 5 步纯 OpenSpec CLI |

### 典型步骤（以 openspec-superpowers 为例）

1. `brainstorming` 探索上下文、逐一提问、2-3 方案对比
2. 输出设计文档（`docs/superpowers/specs/`）
3. OpenSpec 产物：proposal / design / specs / tasks
4. `writing-plans` 分解任务（`docs/superpowers/plans/`）
5. `using-git-worktrees` + `subagent-driven-development` 隔离实现
6. 每任务内 `test-driven-development`，任务后 `requesting-code-review`
7. `verification-before-completion` 全量测试 + lint 零失败
8. `finishing-a-development-branch` 提交/PR/清理工作树

## 三、任务类型 → 技能序列路由

| 任务 | 技能序列 |
|------|---------|
| 实现新功能 | brainstorming → writing-plans → subagent-driven-development → test-driven-development → verification-before-completion → finishing-branch |
| 修复 Bug | systematic-debugging → test-driven-development（隔离测试）→ verification → finishing-branch |
| 代码审查 | requesting-code-review → 审查 → receiving-code-review |
| 并行独立任务 | dispatching-parallel-agents → 汇总 |
| 重构复杂系统 | brainstorming → writing-plans → subagent-driven（并行模块改造）→ TDD → verification |

## 四、决策树速查

- **不知道如何开始** → `brainstorming`（会提问、给方案，批准后自动推进）
- **写完不知是否完整** → `verification-before-completion`（列清单逐项检查）
- **遇到错误无从下手** → `systematic-debugging`（4 步引导）
- **需要深度架构指导** → `architect` 代理 + `rules/` 规则

## 五、与团队规则的融合

| Superpowers 技能 | 配合的团队规则 |
|-----------------|--------------|
| brainstorming | java/patterns.md + common/security.md |
| writing-plans | common/agents.md（编排） |
| test-driven-development | java/testing.md（80%+ 覆盖率） |
| verification-before-completion | common/security.md + java/coding-style.md |
| systematic-debugging | common/coding-style.md（错误处理） |
| requesting-code-review | java/security.md + java/patterns.md |
