# ECC Harness 使用指南（总结）

> 本文总结自项目 `docs/ecc-doc/`（agent说明 / claude说明 / rules说明 / hooks说明 / commands说明 / skills说明 / CLAUDE-ecc），描述团队 AI 编码 harness 的核心理念与使用方法。已随团队仓库分发的资源见各章节标注。

## 一、核心哲学（按优先级）

1. **智能体优先** — 领域任务委托给专业子代理（planner、architect、code-reviewer 等），无需用户提示主动使用
2. **测试驱动** — 先写测试再实现，覆盖率 80%+
3. **安全第一** — 安全绝不妥协，验证所有输入
4. **不可变性** — 创建新对象，不修改现有对象
5. **先规划后执行** — 复杂功能先出计划再编码
6. **并行执行** — 独立操作使用 Task 工具并行调度多个代理

## 二、智能体编排矩阵

团队仓库 `agents/` 已分发 14 个子代理：

| 场景 | 使用代理 |
|------|---------|
| 复杂功能请求 / 大型重构 | **planner** |
| 架构决策 / 技术选型 | **architect** |
| 刚编写/修改的代码 | **code-reviewer**（Java 项目用 **java-reviewer**） |
| 错误修复或新功能 | **tdd-guide** |
| 安全敏感代码 / 提交前 | **security-reviewer** |
| SQL / 模式设计 / 查询优化 | **database-reviewer** |
| Python / TypeScript 代码 | **python-reviewer** / **typescript-reviewer** |
| 构建失败 | **build-error-resolver** |
| 端到端测试 | **e2e-runner** |
| 死代码清理 | **refactor-cleaner** |
| 文档同步 / 文档查询 | **doc-updater** / **docs-lookup** |

**独立操作始终并行执行** —— 同时启动多个代理。

## 三、强制开发工作流

1. **研究与复用**（必须）：代码搜索 → 库文档 → 包注册中心；寻找能解决 80% 问题的现成方案
2. **规划**：planner 代理，识别依赖与风险，分阶段推进
3. **TDD**：tdd-guide 代理 —— RED（测试先失败）→ GREEN（最小实现）→ REFACTOR（覆盖率 80%+）
4. **代码审查**：code-reviewer 立即审查，解决 CRITICAL/HIGH 问题
5. **记录知识**：团队知识进项目文档结构；踩坑经验用 `/teamai-share-learnings` 沉淀到团队仓库 `learnings/`
6. **提交**：约定式提交（feat/fix/refactor/docs/test/chore/perf/ci），完整分析提交历史后写摘要，附测试计划

## 四、规则系统

团队仓库 `rules/` 已分发，按 `common/`（通用）+ `java/`、`python/`、`typescript/`（语言特化）组织。**冲突时语言专用规则优先**。要点：

- 编码风格：简洁优先、零过度设计、精准修改、函数 <50 行、文件 <800 行
- 测试：TDD、80% 覆盖率、单测/集成/端到端三层
- 安全：无硬编码密钥、参数化查询、输入验证、提交前安全检查清单
- 性能：模型选择、上下文管理
- `java/*` 规则是核心约束摘要，详细代码模板指向 `skills/uac/` 对应技能

## 五、代码质量标准

- **不可变性**：返回带更改的新副本，不修改入参
- **错误处理**：fail fast，严禁吞异常
- **输入验证**：系统边界验证所有用户输入
- **提交前安全检查清单**：无硬编码密钥 / 输入已验证 / 参数化查询防注入 / XSS 净化 / CSRF 保护 / 鉴权完整 / 速率限制 / 错误信息不泄露敏感数据

## 六、Hooks 机制

Claude Code hooks 按事件触发自动化（SessionStart / PreToolUse / PostToolUse / Stop / PreCompact / SessionEnd 等）。团队仓库通过 `hooks/hooks.yaml` 声明、`teamai pull` 分发（当前为空骨架，显式同意后 `teamai hooks inject` 生效）。

teamai 自带内置 hooks：会话启动自动 `teamai pull`、Stop 时按摩擦信号提示分享经验。

## 七、关于 commands 与 scripts

原项目 `commands/`（44 个斜杠命令）与 `scripts/` 属于本机/项目级资产，**不是 teamai 资源类型**，不随团队仓库分发。等价能力对照：

| 命令场景 | 团队仓库等价物 |
|---------|--------------|
| /code-review、/python-review | agents: code-reviewer / python-reviewer |
| /tdd | skills: tdd-workflow、springboot-tdd + agent: tdd-guide |
| /verify | skills: verification-loop、springboot-verification |
| /e2e | skill: e2e-testing + agent: e2e-runner |
| /plan | agent: planner |
| /build-fix | agent: build-error-resolver |
| /refactor-clean | agent: refactor-cleaner |
| /learn（经验沉淀） | 内置 skill: teamai-share-learnings |
| superpowers/openspec 工作流 | skills: workflow/、superpowers/ 命名空间 |

## 八、文件命名规范（AI 生成文件）

格式：`[文件夹标识]-[序号]-[时间戳].[后缀]`，如 `PRD-001-202603211639.md`。

| 目录 | 标识 | 用途 |
|------|------|------|
| docs/prd | PRD | 需求文档 |
| docs/plans | PLAN | 实现计划 |
| docs/codereview | CR | 审查报告 |
| docs/database | DB | 数据库变更 |
| docs/config | CONF | 配置文件 |

序号 3 位递增；时间戳 12 位（YYYYMMDDHHMM）；禁止特殊字符。

## 九、禁止事项

- 硬编码配置（中间件地址、第三方接口 URL）
- 在文档/提交中出现密码、凭证
- 读取 yml/yaml 中的中间件链接和密码
- 读取 .gitignore 排除的文件
- 代码/注释/文档中使用表情符号

## 十、思考原则

- 不盲从指令，保持批判性思考，不合理指令要反驳并给优化方案
- 关键逻辑模糊时主动询问，不擅自假设
- 交互用中文，代码和注释用英文
