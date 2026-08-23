# Superpowers 工作流

## Superpowers 技能

| # | 技能 | 用途 |
|---|------|------|
| 1 | brainstorming | 探索、澄清、方案比较、设计文档 |
| 2 | using-git-worktrees | 工作树隔离 |
| 3 | writing-plans | 实现计划编写 |
| 4 | executing-plans | 计划执行 |
| 5 | subagent-driven-development | 子代理驱动开发 |
| 6 | test-driven-development | RED → GREEN → REFACTOR |
| 7 | requesting-code-review | 代码审查 |
| 8 | finishing-a-development-branch | 分支提交/PR/清理 |
| 9 | verification-before-completion | 全量验证 |
| 10 | systematic-debugging | 系统性调试 |

## OpenSpec 命令

| 命令 | 描述 |
| :--- | :--- |
| `/openspec:proposal <name>` | 生成提案 |
| `/openspec:spec <name>` | 生成规格 |
| `/openspec:design <name>` | 生成设计文档 |
| `/openspec:tasks <name>` | 生成任务清单 |

## Superpowers + OpenSpec 协同工作流

### 开发工作流程选择

| 场景               | 推荐工作流                            | 特点                  |
|------------------|----------------------------------|---------------------|
| 大型跨团队功能，需完整规格和设计 | `openspec-superpowers`           | 双重产物，规格+设计双保险       |
| 需严格规格追踪（合规/审计）   | `superpowers-openspec-execution` | 三段式+归档，完整生命周期       |
| 独立功能、快速迭代        | `superpowers-feature`            | 无 OpenSpec 产物，轻量    |
| 仅做需求定义和规格固化      | `openspec-feature`               | 纯 OpenSpec CLI，不写代码 |
| 重要工作完成后          | `superpowers-learning`           | 沉淀项目记忆和可复用经验        |

### 1. openspec-superpowers（8步，完整功能交付）

| 步骤 | 调用的技能 | 说明 |
|------|-----------|------|
| 探索+澄清+方案比较 | brainstorming | Phase 1-3：探索项目上下文、逐一提问、2-3方案对比 |
| 编写设计文档 | brainstorming | Phase 4-8：输出 `docs/superpowers/specs/` |
| OpenSpec 产物 | openspec CLI | `proposal.md`、`design.md`、`specs/**/spec.md`、`tasks.md` |
| 实现计划 | writing-plans | 输出 `docs/superpowers/plans/`，分解为小任务 |
| TDD 实现 | using-git-worktrees + subagent-driven-development | 工作树隔离，子智能体按任务分发 |
| 每个任务内 | test-driven-development | RED → GREEN → REFACTOR 循环 |
| 每个任务后 | requesting-code-review | 分派 code-reviewer 子智能体审查 |
| 验证 | verification-before-completion | 全量跑测试+lint，确保零失败 |
| 收尾 | finishing-a-development-branch | 提交/PR/清理工作树 |

### 2. superpowers-openspec-execution（9步，三明治式）

| 步骤 | 调用的技能 | 说明 |
|------|-----------|------|
| 步骤 1-4 | brainstorming | 探索 → 澄清 → 方案 → 设计 |
| 步骤 5 | openspec CLI | 完成 OpenSpec 所有 artifact |
| 步骤 6 | writing-plans | 实现计划 |
| 步骤 7 | subagent-driven-development + test-driven-development | TDD 实现 |
| 步骤 8 | verification-before-completion | 全量验证 |
| 步骤 9 | openspec archive | 归档变更（代码、规格、测试三者对齐后） |

**节奏**：先探索收敛 → 用 OpenSpec 固化 → 回来实现验证 → 最后归档。

### 3. superpowers-feature（7步，轻量功能）

| 步骤 | 调用的技能 | 说明 |
|------|-----------|------|
| 步骤 1-4 | brainstorming | 探索 → 澄清 → 方案 → 设计 |
| 步骤 5 | writing-plans | 实现计划 |
| 步骤 6 | subagent-driven-development + test-driven-development | TDD 实现 |
| 步骤 7 | verification-before-completion + finishing-a-development-branch | 验证 + 收尾 |

**特点**：不生成任何 OpenSpec 产物，适合独立功能、不需要跨团队追踪的场景。

### 4. openspec-feature（5步，纯 OpenSpec）

| 步骤 | 说明 |
|------|------|
| 步骤 1 | 确认 kebab-case 变更名称 |
| 步骤 2 | `openspec status --change "<name>" --json` |
| 步骤 3 | 逐个运行 `openspec instructions <artifact>` |
| 步骤 4 | 完成 `proposal.md`、`design.md`、`specs/**/spec.md`、`tasks.md` |
| 步骤 5 | 重新跑 status 直到全部完成 |

**特点**：零 Superpowers 技能调用，纯 OpenSpec CLI 驱动，不包含设计文档、TDD 或验证。

### 5. superpowers-learning（5步，记忆沉淀）

| 步骤 | 说明 |
|------|------|
| 步骤 1 | 回顾最近的开发工作、决策和验证结果 |
| 步骤 2 | 分类：持久化事实 / 当前状态 / 会话产出 / 可复用经验 |
| 步骤 3 | 更新 `.superpowers-memory/PROJECT_CONTEXT.md`、`CURRENT_STATE.md`、`session-journal/` |
| 步骤 4 | 追加可复用模式到 `.superpowers-memory/LEARNING_BACKLOG.md` |
| 步骤 5 | 总结下次会话需要记住的内容 |

## Superpowers 记忆

如果仓库中存在 `.superpowers-memory/` 目录，请在每次会话开始时、询问项目背景之前先读取以下文件：

1. `.superpowers-memory/PROJECT_CONTEXT.md`
2. `.superpowers-memory/CURRENT_STATE.md`
3. `.superpowers-memory/session-journal/` 下最新的文件

使用它们来恢复项目上下文、最近的决策、进行中的工作以及可能的下一步。

在结束一次有意义的 Superpowers 相关会话之前，请更新：

- `.superpowers-memory/CURRENT_STATE.md`
- `.superpowers-memory/session-journal/` 下的一篇简短 markdown 笔记

不要将记忆文件视为自动启用 Superpowers 工作流的许可。工作流的激活仍需明确的主动选择。
