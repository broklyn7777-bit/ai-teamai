# Oh My Pi (OMP) 开发者使用说明

> 基于官方源码文档整理，面向开发程序员，覆盖所有核心功能

---

## 一、快速开始

### 1.1 安装

```bash
# Windows (推荐预编译)
irm https://omp.sh/install.ps1 | iex
# macOS / Linux
curl -fsSL https://omp.sh/install | sh
# npm (源码安装，部分旧版 Extension 可能加载失败)
npm install -g @oh-my-pi/pi-coding-agent
# 从源码构建
git clone https://github.com/can1357/oh-my-pi && cd oh-my-pi && bun install && bun run build
```

### 1.2 启动

```bash
omp                        # 交互模式
omp "一句话任务"            # 单次执行
omp --model claude-sonnet-4-5 --plan-yolo "迁移到 ESM"
omp join "<collab-link>"   # 加入协作会话
```

---

## 二、核心工具一览（30+ 工具）

| 类别 | 工具 | 说明 |
|------|------|------|
| **文件** | `read` | 文件/目录/SQLite/URL读取，支持行选择器 `:50-200` |
| | `write` | 创建/覆盖文件，支持写入 `.db:table` 行 |
| | `edit` | Hashline 编辑——用内容哈希锚定行，编辑成功率 10x |
| **搜索** | `grep` | 正则搜索（Rust regex + PCRE2） |
| | `glob` | 文件模式匹配 |
| | `ast_edit` / `ast_grep` | AST 感知重构，跨文件安全 |
| **运行时** | `bash` | 命令执行，内置安全检测（rm -rf / 等） |
| | `eval` | Python/JS 持久化内核执行 |
| | `ssh` | 远程文件读写 |
| **代码智能** | `lsp` | 14 种操作：definition/references/rename/diagnostics 等 |
| | `debug` | DAP 调试器：breakpoint/step/variables 等 28 操作 |
| **协作** | `task` | 子代理编排（默认 task、scout、reviewer、librarian） |
| | `hub` | 子代理消息/进程/作业控制 |
| | `browser` | Puppeteer 浏览器自动化 |
| **记忆** | `retain` / `recall` / `reflect` | 跨会话持久记忆（Hindsight） |
| **其他** | `web_search` | 多引擎搜索 |
| | `inspect_image` | 视觉模型分析图片 |
| | `todo` | 任务追踪（阶段式 todo list） |
| | `ask` | 向用户提问澄清 |
| | `generate_image` | 图片生成 |
| | `tts` | 文本转语音 |
| | `rewind` | 回滚到之前的会话状态 |
| | `checkpoint` | 会话检查点/分支/恢复 |

---

## 三、Rules 规则系统

### 3.1 概念

Rules 是注入到每次对话 system prompt 的行为约束。分两类：

- **Sticky Rules**（`RULES.md`）：始终附在当前 turn 附近，不被 context 增长稀释
- **Context Files**（`CLAUDE.md`、`AGENTS.md`）：作为 `<context>` 块注入，作为背景参考

### 3.2 发现优先级（从高到低）

```
项目级（cwd → repo root）:
  .claude/
    CLAUDE.md              # 项目级指令（最常用）
    RULES.md               # Sticky rules（永不被稀释）
    agents/                # 子代理定义
    rules/                 # 规则文件
    tools/                 # 自定义工具
    skills/                # 技能目录
    hooks/                 # 钩子脚本
  .omp/agent/
    config.yml             # 项目级设置
    RULES.md               # 仅认这个位置的 RULES.md
    mcp.json               # 项目级 MCP

用户级（~/.omp/agent/ 和 ~/.claude/）:
  ~/.omp/agent/config.yml  # 全局设置
  ~/.omp/agent/models.yml  # 自定义 Provider/模型（见第二十三章）
  ~/.claude/CLAUDE.md      # 全局指令
  ~/.claude/rules/         # 全局规则
  ~/.claude/skills/        # 全局技能
  ~/.claude/tools/         # 全局工具
```

### 3.3 CLAUDE.md 示例

```markdown
# 项目:my-app
## 语言
- 使用中文交流，技术术语保留英文

## 编码规范
- TypeScript strict 模式
- 函数 camelCase, 类型 PascalCase
- 优先 const, 禁止 var
- 必须 try-catch 处理错误

## 禁止事项
- 禁止修改 .env 文件
- 禁止直接操作生产数据库
```

### 3.4 `@` 引用规则

OMP 支持在对话中引用规则文件：
```
@docs/skills.md 查看技能文档的 3.2 节
@AGENTS.md 的 Package Structure 部分
```
语法：`<path>:<line-selector>` — 如 `CLAUDE.md:1-50`、`AGENTS.md#raw`

---

## 四、Skills 技能系统

### 4.1 概念

Skills 是**被动内容包**，在启动时或按需通过 `skill://` URL 加载。包含 `name` + `description` + 指令内容。AI 根据用户描述自动匹配。

### 4.2 目录布局

```
~/.claude/skills/
+-- graphify/SKILL.md     # 代码知识图谱
+-- web-access/SKILL.md   # 浏览器自动化
+-- frontend-patterns/SKILL.md
+-- backend-patterns/SKILL.md
+-- ...
```

项目级：`.claude/skills/<name>/SKILL.md`

### 4.3 触发方式

```
# 显式：斜杠命令
/graphify 分析这个项目的架构

# 隐式：AI 根据描述自动匹配
用户: 帮我写一个前端组件
AI: 自动匹配 frontend-patterns skill
```

### 4.4 内置 Skill 分类

| 类别 | Skills |
|------|--------|
| **开发模式** | frontend-patterns, backend-patterns, springboot-patterns, python-patterns |
| **安全** | security-review, springboot-security, uac-security |
| **测试** | tdd-workflow, python-testing, e2e-testing, springboot-tdd |
| **架构** | architecture-analyzer, domain-analyzer, understand, understand-domain |
| **文档** | codebase-documenter, doc-coauthoring, article-writing, zread |
| **运维** | spring-boot-upgrade-expert, nacos-installer |

### 4.5 自定义 Skill

创建 `~/.claude/skills/my-skill/SKILL.md`：

```markdown
---
name: my-skill
description: 当用户需要 X 时使用
---
# My Skill 指令
## 步骤
1. 先读取相关文件
2. 按以下模式实现...
3. 验证...
```

---

## 五、MCP 扩展系统

### 5.1 概念

MCP (Model Context Protocol) 是连接外部工具/服务的标准协议。OMP 原生支持 MCP，可接入数据库、API、第三方服务等。

### 5.2 配置位置（优先级高→低）

```
~/.claude/.mcp.json              # 跨工具兼容
~/.claude/mcp.json               # 跨工具兼容
~/.omp/agent/mcp.json            # OMP 原生（推荐）
~/.omp/mcp.json                  # 兼容旧版
.omp/agent/mcp.json              # 项目级
~/.codex/mcp.json                # Codex 兼容
```

### 5.3 配置示例

```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": { "DATABASE_URL": "postgresql://user:pass@host/db" }
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": { "GITHUB_TOKEN": "ghp_xxxx" }
    },
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/home/user/docs"]
    }
  }
}
```

### 5.4 使用

```
用户: 查询 users 表最近注册的用户
AI: 调用 postgres MCP 执行 SQL
返回: [{ id: 1, name: "...", created_at: "..." }]
```

---

## 六、Sub-agent 子代理编排

### 6.1 核心概念

`task` 工具将复杂任务拆分为多个**并行子代理**，每个在隔离的 git worktree 中独立工作。

### 6.2 Agent 类型

| 类型 | 用途 | 工具集 |
|------|------|--------|
| `task` | 通用执行（默认） | 全工具集 |
| `scout` | 只读探索，快速调研 | read/grep/glob |
| `reviewer` | 代码审查 | read/edit/grep/lsp |
| `librarian` | 研究外部库和 API | read/grep/web_search |
| `designer` | UI/UX 设计实现 | read/write/edit/browser |
| `sonic` | 机械性更新/数据收集 | 最小工具集 |

### 6.3 调用示例

```python
task(
    context="项目使用 React + TypeScript",
    tasks=[
        {
            name: "ScanAuth",
            agent: "scout",
            task: "分析 src/auth/ 的认证流程,列出关键文件"
        },
        {
            name: "ScanAPI",
            agent: "scout",
            task: "分析 src/api/ 的所有接口定义"
        },
        {
            name: "RefactorAuth",
            agent: "task",
            task: "把 auth 模块重构为函数式组件"
        }
    ]
)
```

### 6.4 并发与限制

- 最多 **32 个子代理**并行，超出排队
- 子代理以 `yolo` 模式运行（不等待 UI 审批）
- 父 `task` 工具是审批边界
- 深度 > 1 的子代理不能再 spawn（防止无限递归）
- 隔离 worktree：每个子代理在独立 git worktree 工作，避免文件冲突

### 6.5 hub 协作

子代理之间可通过 `hub` 通信：

```python
# 向特定子代理发消息
hub(op="send", to="AuthLoader", message="还需要 auth 模块的 token 刷新逻辑")

# 等待所有子代理完成
hub(op="wait")

# 查看子代理状态
hub(op="jobs")

# 取消卡住的子代理
hub(op="cancel", ids=["bash_a1b2"])
```

### 6.6 Agent 定义（`.claude/agents/`）

项目可在 `.claude/agents/` 下定义自定义 agent：

```markdown
<!-- .claude/agents/review-architect.md -->
# Review Architect

专门审查系统架构设计的子代理。

## Tools
- read, grep, lsp
- task（可进一步分派）

## 约束
- 只读分析，不修改代码
- 输出 Mermaid 架构图
```

---

## 七、LSP 代码智能

### 7.1 14 种操作

| 操作 | 说明 | 典型场景 |
|------|------|----------|
| `definition` | 跳转到定义 | 查看函数/类型定义 |
| `type_definition` | 跳转到类型定义 | 查看泛型类型约束 |
| `implementation` | 查找实现 | 找接口实现类 |
| `references` | 查找所有引用 | 重命名前检查影响范围 |
| `rename` | 安全重命名 | 跨文件统一重命名 |
| `diagnostics` | 获取错误/警告 | 查看编译错误 |
| `code_actions` | 快速修复/重构 | 自动导入、提取函数 |
| `hover` | 悬停类型信息 | 查看变量类型 |
| `symbols` | 列出符号 | 文件/工作区符号搜索 |
| `capabilities` | 服务器能力 | 查看支持的操作 |
| `status` | 服务器状态 | 检查 LSP 是否就绪 |
| `reload` | 重启服务器 | LSP 卡住时重启 |

### 7.2 使用示例

```
用户: 把 UserService 重命名为 AccountService
OMP 行为:
1. lsp references 找到所有引用（含 re-export、barrel file）
2. lsp rename 统一更新
3. 不会遗漏任何调用点

用户: 这个文件有什么错误？
OMP: lsp diagnostics → 返回所有 errors/warnings → 自动修复可修复项
```

### 7.3 语言支持

LSP 需要本地安装对应语言服务器：
- TypeScript/JS → TypeScript Language Server
- Java → Eclipse JDT LS / Java Language Support
- Python → Pyright / Pylance
- Go → gopls
- Rust → rust-analyzer

---

## 八、DAP 调试器集成

### 8.1 支持的语言

| 语言 | 调试器 |
|------|--------|
| C/C++ | lldb |
| Go | dlv |
| Python | debugpy |
| TypeScript/JS | 内置 |
| Rust | rdbg / CodeLLDB |

### 8.2 28 种操作

核心：`launch` / `attach` / `set_breakpoint` / `remove_breakpoint` /
`step_in` / `step_out` / `step_over` / `continue` / `pause` / `terminate` /
`stack_trace` / `variables` / `scopes` / `evaluate` / `threads` /
`read_memory` / `write_memory` / `disassemble`

### 8.3 使用示例

```
用户: 运行 test 并调试失败的用例
OMP:
1. debug launch → 启动测试
2. set_breakpoint → 在失败测试处设断点
3. step_over → 单步执行
4. variables → 查看变量值
5. 定位根因并修复
```

---

## 九、Hashline 编辑机制

### 9.1 原理

传统 AI 编辑用 `str_replace`，需要模型精确复现原文（空格、缩进错一个就失败）。

OMP 用**内容哈希**锚定行：
```
旧方式: "把 `const x = 1` 替换为 `const x = 2`"
  → 模型记错空格就匹配失败

新方式: "把行 [abc123] 替换为 ..."
  → 系统校验哈希，确保行内容一致
```

### 9.2 关键约束

- **编辑前必须 read/eval**：哈希来自最近一次 read 的 `#TAG`
- **范围紧密**：只覆盖变化的行，宽范围会"切碎"未变行
- **每次编辑后哈希刷新**：不能复用旧 tag
- **内容不匹配时自动拒绝**：防止覆盖他人修改

### 9.3 编辑操作

```
SWAP N.=M:       # 替换第 N 到 M 行（含）
SWAP.BLK N:      # 替换从 N 行开始的完整语法块
DEL N.=M         # 删除第 N 到 M 行
DEL.BLK N        # 删除从 N 行开始的完整语法块
INS.PRE N:       # 在 N 行前插入
INS.POST N:      # 在 N 行后插入
INS.HEAD:        # 文件头插入
INS.TAIL:        # 文件尾插入
MV <path>        # 移动/重命名文件
REM              # 删除整个文件
```

### 9.4 优势

- 编辑成功率提升 **10 倍**
- Token 消耗减少 **61%**
- 内容不匹配时自动拒绝

---

## 十、浏览器控制

### 10.1 概念

内置 Puppeteer 浏览器自动化，支持 JS 执行、认证、交互操作。

### 10.2 操作

```
open     → 打开 URL（默认隐身模式）
run      → 在标签页执行 JS
close    → 关闭标签页/浏览器
```

### 10.3 常用场景

```
用户: 打开 localhost:3000, 点击登录, 截图
OMP:
1. open "http://localhost:3000"
2. run "tab.click('[aria-label=Login]')"
3. run "tab.screenshot()"
```

- E2E 测试验证
- UI 截图对比
- 网页数据抓取
- 自动化表单填写

---

## 十一、Advisor 副代理

### 11.1 概念

Advisor 是可选的**第二模型**，在每次主 agent turn 结束后审查 transcript，注入建议。不是第二个执行者，而是审查者。

### 11.2 启用

```yaml
# ~/.omp/agent/config.yml
modelRoles:
  advisor: anthropic/claude-sonnet-4-5:medium
advisor:
  enabled: true
```

```bash
omp -p --advisor "Review this task."   # 单次启用
```

### 11.3 审查级别

| 级别 | 效果 |
|------|------|
| `nit` | 非中断建议，批量注入 |
| `concern` | 中断性提醒，有实质性风险 |
| `blocker` | 中断性阻止，继续会浪费工作 |

### 11.4 命令

```
/advisor          # 切换
/advisor on/off   # 开启/关闭
/advisor status   # 状态
/advisor dump     # 复制审查记录
```

---

## 十二、Hindsight 记忆系统

### 12.1 概念

跨会话持久记忆，项目级隔离。自动从历史会话提取知识，注入未来会话。

### 12.2 启用

```yaml
# config.yml
memory:
  backend: local
```

或通过 `/settings` 面板启用。

### 12.3 使用

```
会话 1: 用户告诉 OMP "项目用 pnpm，不用 npm"
OMP: retain 写入记忆
会话 2: OMP 自动 recall → 知道要用 pnpm
```

| 工具 | 说明 |
|------|------|
| `retain` | 写入事实到记忆 |
| `recall` | 检索相关记忆 |
| `reflect` | 综合分析记忆 |
| `memory_edit` | 编辑已有记忆 |

---

## 十三、Collab 实时协作

### 13.1 概念

`/collab` 将运行中的会话实时共享给其他 OMP 实例。**Guest 在自己终端原生渲染同一会话**——流式文本、工具卡、footer 状态全部同步。

### 13.2 使用

```
# Host 端
/collab                    # 开始共享（完整控制）
/collab view               # 只读共享

# 输出
Collab session started!
• Join: omp join "mgAYTZw..."
• Browser: my.omp.sh/#mgAYTZw...

# Guest 端（任何机器）
omp join "mgAYTZw..."
```

### 13.3 权限模型

| 链接类型 | 权限 |
|----------|------|
| 完整链接（48 bytes） | 读 + prompt + interrupt + 子代理控制 |
| 只读链接（32 bytes） | 仅实时读取 |

### 13.4 安全

- **AES-256-GCM 端到端加密**
- Relay 只看到房间 ID 和密文帧大小
- 链接即信任边界

### 13.5 Web 客户端

浏览器访问 `my.omp.sh/#<link>` 即可加入，无需安装 OMP。

---

## 十四、Approval Mode 审批模式

### 14.1 工具分级

| 级别 | 含义 | 示例 |
|------|------|------|
| `read` | 读取数据 | read, grep, glob |
| `write` | 修改文件/状态 | write, edit, ast_edit |
| `exec` | 执行代码/shell | bash, eval, browser, task |

### 14.2 模式

| 模式 | 自动批准 | 需要确认 |
|------|----------|----------|
| `always-ask` | read | write, exec |
| `write` | read, write | exec |
| `yolo`（默认） | 全部 | 无 |

```bash
omp --yolo                  # 全自动
omp --auto-approve          # 同 --yolo
```

### 14.3 安全覆盖

```yaml
tools:
  approvalMode: yolo
  approval:
    bash: prompt             # 即使 yolo 模式也需确认 bash
    mcp__filesystem__delete: deny  # 禁止删除
```

---

## 十五、模型角色路由

### 15.1 角色

| 角色 | 用途 | 配置 |
|------|------|------|
| `default` | 日常对话/编码 | `--model` |
| `smol` | 廉价子代理 | `--smol` |
| `slow` | 深度推理 | `--slow` |
| `plan` | 规划模式 | `--plan` |
| `commit` | Changelog/提交信息 | 自动 |
| `advisor` | 审查副代理 | config.yml |

### 15.2 配置示例

```yaml
# ~/.omp/agent/config.yml
modelRoles:
  default: anthropic/claude-sonnet-4-5
  smol: anthropic/claude-haiku
  slow: anthropic/claude-opus
  plan: anthropic/claude-sonnet-4-5
  advisor: anthropic/claude-sonnet-4-5:medium
```

```bash
omp --model claude-sonnet-4-5 --smol haiku --slow opus
```

> 本机实际生产配置（内网网关接入）完整示例见第二十三章「常用配置」。

### 15.3 40+ Provider 支持

| 类别 | Provider |
|------|----------|
| 前沿 API | Anthropic, OpenAI, Gemini, xAI, Mistral, Groq, Perplexity... |
| 编程订阅 | Cursor, GitHub Copilot, GitLab Duo, Kimi Coder... |
| 本地模型 | Ollama, LM Studio, vLLM, Jan... |
| 网关 | OpenRouter, LiteLLM, Cloudflare AI... |

### 15.4 Fallback 链

主模型 429 限流时自动切换备用模型，冷却后恢复。

---

## 十六、自定义工具（Custom Tools）

### 16.1 概念

Custom Tool 是模型可直接调用的 TypeScript 函数，注册到工具执行管线中。

### 16.2 发现位置

```
~/.omp/agent/tools/      # OMP 原生
.claude/tools/            # 跨工具兼容
.codex/tools/             # Codex 兼容
~/.claude/tools/          # 跨工具兼容
~/.omp/plugins/           # 插件目录
```

### 16.3 模块合约

```typescript
import type { CustomToolFactory } from "@oh-my-pi/pi-coding-agent";

const factory: CustomToolFactory = (pi) => ({
  name: "repo_stats",
  label: "Repo Stats",
  description: "统计项目 TypeScript 文件数",
  parameters: pi.zod.object({
    glob: pi.zod.string().optional().default("**/*.ts"),
  }),

  async execute(toolCallId, params, onUpdate, ctx, signal) {
    const result = await pi.exec("git", ["ls-files", params.glob], {
      signal, cwd: pi.cwd
    });
    const files = result.stdout.split("\n").filter(Boolean);
    return {
      content: [{ type: "text", text: `Found ${files.length} files` }],
    };
  },
});

export default factory;
```

---

## 十七、Extensions 扩展

### 17.1 概念

Extension 是比 Custom Tool 更强大的扩展机制，可同时注册工具、事件处理器、slash 命令和 UI 渲染器。

### 17.2 模块合约

```typescript
import type { ExtensionAPI } from "@oh-my-pi/pi-coding-agent";

export default function myExtension(pi: ExtensionAPI) {
  // 事件处理
  pi.on("tool_result", (event) => {
    if (event.toolName !== "read") return;
    // 审查/修改工具结果
  });

  // 注册工具
  pi.registerTool({ name: "my_tool", ... });

  // 注册命令
  pi.registerCommand({ name: "my-cmd", handler: ... });
}
```

### 17.3 发现位置

```
~/.omp/agent/extensions/   # OMP 原生
.claude/extensions/         # 跨工具兼容
```

---

## 十八、Hooks 钩子系统

### 18.1 概念

Hooks 是事件驱动的运行时拦截器，可在执行期间阻断/修改 AI 行为。

### 18.2 类型

| 类型 | 说明 |
|------|------|
| `pre` | 工具执行前拦截 |
| `post` | 工具执行后拦截 |
| `context` | 修改 LLM 调用上下文 |

### 18.3 示例（敏感信息脱敏）

```typescript
import type { HookAPI } from "@oh-my-pi/pi-coding-agent/extensibility/hooks";

export default function redactHook(pi: HookAPI) {
  pi.on("tool_result", async (event) => {
    if (event.toolName !== "read" || event.isError) return;
    const redacted = event.content.map((chunk) => {
      if (chunk.type !== "text") return chunk;
      return {
        ...chunk,
        text: chunk.text.replaceAll(/API_KEY=\S+/g, "API_KEY=[REDACTED]"),
      };
    });
    return { content: redacted };
  });
}
```

---

## 十九、Plan 模式

### 19.1 启用

```bash
omp --plan-yolo "把项目从 CommonJS 迁移到 ESM"
```

### 19.2 工作流程

```
1. Plan 模型分析任务 → 输出详细方案（plan file）
2. 用户确认方案
3. 切换执行模型 → 按方案逐步实施
4. 每步验证，确保正确
```

Plan 模式下子代理工具集受限（只读 + ast_grep），不能直接修改文件。

---

## 二十、实用命令速查

```bash
# 基础
omp                              # 交互模式
omp "一句话任务"                  # 单次执行
omp -p "任务"                    # print 模式（无 TUI）

# 模型
omp --model <name>               # 指定主模型
omp --smol <name>                # 指定子代理模型
omp --slow <name>                # 指定推理模型
/model                           # 会话内切换模型（Ctrl+P 循环）

# 计划
omp --plan-yolo "任务"           # 规划 + 自动执行

# 协作
omp join "<link>"                # 加入协作会话

# 配置
omp config list                  # 列出所有配置项
omp config get <key>             # 获取配置值
omp config set <key> <value>     # 设置配置值
/settings                        # 交互式设置面板

# 记忆
/memory status                   # 记忆状态
/memory clear                    # 清除记忆

# 分享
/share                           # 分享会话快照

# 会话
/compact                         # 压缩上下文
/branch                          # 分支当前会话
/resume                          # 恢复会话
/fresh                           # 重置 provider 状态
```

---

## 二十一、最佳实践

1. **先写规则再开工**：`CLAUDE.md` 写入项目约定，避免每次重复
2. **善用 Skills**：特定领域任务先查是否有对应 Skill
3. **复杂任务用 task**：自动并行，效率翻倍
4. **LSP 优先于 grep**：重命名/查引用用 `lsp`，比 grep 准确
5. **Plan 模式处理大重构**：先规划确认再执行
6. **模型分层**：日常 sonnet，子代理 haiku，复杂推理 opus
7. **Advisor 审查关键任务**：`/advisor on` 让第二个模型把关
8. **Collab 结对编程**：`/collab` 实时共享会话
9. **自定义工具扩展能力**：`Custom Tools` 封装领域逻辑
10. **Hindsight 记忆**：跨会话自动记住项目约定

---

## 二十二、已知限制

- 部分旧版 Pi Extension（CommonJS 依赖）在 npm/source 安装下可能加载失败，预编译二进制不受影响
- LSP/DAP 依赖本地语言服务器和调试器可用性
- Collab v1 限制：加入时正在 stream 的 turn 从下一个 message boundary 才可见
- 子代理深度 > 1 不能再 spawn（防止无限递归）

---

## 二十三、常用配置（config.yml / models.yml 实战参考）

> 以下为 `~/.omp/agent/` 下两个核心配置文件的**本机实际配置**，可直接对照修改。
> 修改后重启 `omp` 生效；会话内临时切换模型用 `/model`（Ctrl+P）。

### 23.1 config.yml 完整示例（用户级）

```yaml
# ~/.omp/agent/config.yml
setupVersion: 1               # 配置格式版本，固定为 1，勿删

# 模型角色路由（各角色指定模型，详见第十五章）
modelRoles:
  default: qwen3.8-max        # 主力模型：日常对话/编码
  smol: deepseek-v4-flash     # 轻量子代理模型（scout/sonic 等）
  slow: deepseek-v4-flash     # 深度推理模型（可按需换更强模型）
  plan: qwen3.8-max           # Plan 模式规划模型
  advisor: deepseek-v4-flash  # Advisor 审查副代理模型

# Advisor 副代理（详见第十一章）
advisor:
  enabled: true               # 全局开启；/advisor on|off 会话内切换

# Hindsight 记忆系统（详见第十二章）
memory:
  backend: local              # 记忆本地存储

# 项目记忆
memories:
  enabled: true               # 跨会话项目记忆总开关

# 开发者选项
dev:
  autoqaConsent: granted      # 自动 QA 已授权（避免逐项确认）
```

### 23.2 models.yml 自定义 Provider（内网网关接入）

自定义 Provider 配置在 `~/.omp/agent/models.yml`（注意是**复数** `models`）。
以下为公司内网网关（Anthropic Messages 协议）的实际接入配置：

```yaml
# ~/.omp/agent/models.yml
providers:
  sf-claudecode:                                    # provider 名称（自定义）
    baseUrl: https://claudecode.sf-express.com/ccr  # 网关地址
    api: anthropic-messages                         # API 协议（另支持 openai-chat / openai-responses 等）
    apiKey: "01374035"                              # 网关鉴权凭证（员工号）
    authHeader: true                                # 使用 Authorization: Bearer 而非默认的 x-api-key
    models:
      - id: qwen3.8-max                             # 模型 id，modelRoles 中引用此名称
        name: qwen3.8-max                           # 显示名
        contextWindow: 1000000                      # 上下文窗口（100 万 token）
        maxTokens: 65536                            # 单次输出上限
        input:                                      # 支持的输入模态
          - text
          - image                                   # 支持图片输入
      - id: deepseek-v4-flash
        name: deepseek-v4-flash
        contextWindow: 1000000
        maxTokens: 65536
        input:
          - text
```

### 23.3 常用配置项速查

| 配置项 | 文件 | 说明 | 本机值 |
|--------|------|------|--------|
| `modelRoles.default` | config.yml | 主力编码模型 | `qwen3.8-max` |
| `modelRoles.smol` | config.yml | 子代理/轻量任务模型 | `deepseek-v4-flash` |
| `modelRoles.slow` | config.yml | 深度推理模型 | `deepseek-v4-flash` |
| `modelRoles.plan` | config.yml | Plan 模式规划模型 | `qwen3.8-max` |
| `modelRoles.advisor` | config.yml | Advisor 审查模型 | `deepseek-v4-flash` |
| `advisor.enabled` | config.yml | Advisor 全局开关 | `true` |
| `memory.backend` | config.yml | Hindsight 记忆后端 | `local` |
| `memories.enabled` | config.yml | 项目记忆开关 | `true` |
| `dev.autoqaConsent` | config.yml | 自动 QA 授权 | `granted` |
| `providers.<name>.baseUrl` | models.yml | 自定义网关地址 | 内网网关 |
| `providers.<name>.api` | models.yml | API 协议 | `anthropic-messages` |
| `providers.<name>.authHeader` | models.yml | 改用 Bearer 鉴权头 | `true` |
| `providers.<name>.models[].contextWindow` | models.yml | 模型上下文窗口 | `1000000` |
| `providers.<name>.models[].maxTokens` | models.yml | 单次输出上限 | `65536` |
| `tools.approvalMode` | config.yml | 审批模式（见第十四章） | `yolo`（默认） |

### 23.4 配置注意事项

1. **文件名是 `models.yml`**（复数），写成 `model.yml` 不会生效
2. **模型名引用**：`modelRoles` 中填写 `models.yml` 里的模型 `id`（自定义 provider），或官方 provider 的模型名（如 `anthropic/claude-sonnet-4-5`）
3. **authHeader: true**：第三方/内网网关通常要求 `Authorization: Bearer`，而非 Anthropic 默认的 `x-api-key`，接入非官方网关时优先检查此项
4. **凭证安全**：`models.yml` 含 apiKey，勿提交到 git 仓库
5. **配置优先级**：项目级 `.omp/agent/config.yml` 覆盖用户级 `~/.omp/agent/config.yml`
6. **命令行覆盖**：`--model` / `--smol` / `--slow` 优先于配置文件（见 15.1）

---

> **一句话总结**：OMP 把 IDE 的代码理解（LSP 14操作）、调试（DAP 28操作）、浏览器控制、子代理编排、实时协作（Collab）、副代理审查（Advisor）、跨会话记忆（Hindsight）全部集成在终端里。对开发者而言，**Rules + Skills + MCP + Sub-agent + Extensions + Hooks** 六大机制构成了完整的可扩展体系。
