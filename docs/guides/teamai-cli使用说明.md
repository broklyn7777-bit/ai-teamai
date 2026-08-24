# teamai-cli 使用说明

> 基于 teamai-cli **v0.20.0** 源码（`src/index.ts` 命令定义）编写。团队仓库：`https://gitee.com/gitciyo/ai-teamai.git`。

## 1. 安装与初始化

```bash
npm install -g teamai-cli        # Node.js ≥ 18（官方 usage-guide 要求）
teamai --version

# 用户级初始化（推荐，跨项目共享）
teamai init https://github.com/broklyn7777-bit/ai-teamai.git --scope user --agent claude

# gitee 目前不支持 
git remote set-url origin https://gitee.com/gitciyo/ai-teamai.git
cd /path/to/ai-teamai
teamai init . --scope user --agent claude

# 项目级（只装到当前项目）
cd /path/to/project
teamai init https://gitee.com/gitciyo/ai-teamai.git
```

常用 init 选项：

| 选项 | 作用 |
|------|------|
| `--scope user\|project` | 安装位置：`~/` 或 `<cwd>/`（默认 project） |
| `--agent claude,codex` | 指定要配置的 AI 工具，可重复/逗号分隔；省略则交互选择 |
| `--role <id>` | 非交互指定主角色 |
| `--inherit-user-scope` | project 模式同时继承 user scope 的安全资源与知识 |
| `--force` | 覆盖已有配置不确认 |

初始化自动完成：OAuth 登录、克隆团队仓到 `~/.teamai/team-repo`、注册成员、注入 SessionStart hook（每次 AI 会话启动自动 `pull`）。

## 2. 本团队两个关键行为（与默认不同）

团队仓 `teamai.yaml` 设了 `sharing.hooks.autoApply: false` 和 `sharing.mcp.autoApply: false`（源码 `resources/hooks.ts` / `mcp-reconcile.ts` 验证）。**`teamai pull` 不会自动应用团队 hooks 和 MCP，只提示**，需成员显式确认：

```bash
teamai hooks inject    # 应用团队 hooks 到各 AI 工具
teamai mcp inject      # 应用团队 MCP（mcp/mcp.yaml）到各 AI 工具
teamai hooks list      # 查看生效的 hooks
teamai mcp list        # 查看 MCP 及各工具安装状态
```

首次接入、或团队更新了 `hooks/hooks.yaml`、`mcp/mcp.yaml` 后，都要重新 `inject`。密钥类变量按 `mcp/mcp.yaml` 头部约定放 `~/.teamai/env`（`KEY=value` 每行一条，不入 git）。

## 3. 日常操作

| 场景 | 命令 |
|------|------|
| 同步最新资源 | `teamai pull`（SessionStart hook 自动跑；`--force` 强制全量） |
| 查看本地与团队差异 | `teamai status` |
| 推送新技能/规则 | 资源写入 `~/.claude/skills/`、`~/.claude/rules/` 等后 `teamai push` |
| 推送单个技能 | `teamai push --skill <path>` |
| 分享踩坑经验 | AI 会话结束提示后 `/teamai-share-learnings`，或 `teamai contribute --file <md>` |
| 检索团队知识 | `teamai recall "关键词"`（`--depth route\|context\|lookup`，默认 context） |
| 召回开关 | `teamai recall enable/disable/status`（团队默认开启，本机可覆盖） |
| 排除不需要的技能 | `teamai skill exclude add <name>`（只影响本机，不动团队仓） |
| 查看技能详情 | `teamai skill show <name>` |
| 列资源 | `teamai list [skills\|rules\|docs\|env\|agents\|hooks\|mcp]` |
| 团队环境变量 | `teamai env list\|add\|remove`（默认脱敏，`--reveal` 显示明文） |
| 诊断问题 | `teamai doctor` |
| 升级 CLI | `teamai update`（`--check` 只查不装） |

### ⚠️ Gitee 限制：push 的 MR 流程不可用

CLI 的 MR provider 仅支持 **github / tgit / cnb**（`src/providers/`）。本团队仓库托管在 Gitee，`teamai.yaml` 以 `provider: github` 降级配置：

- clone / pull / 直推正常
- `teamai push` 自动创建 MR 会失败，**改动保留在本地克隆 `~/.teamai/team-repo`**
- 处理：手动推送分支，在 Gitee 网页上创建 PR（默认评审人 `01374035`），或与评审人约定直推

## 4. 贡献规范

- **skills**：目录含 `SKILL.md`（YAML frontmatter 有 `name` + `description`），push 时自动补全缺失字段
- **rules**：Markdown，按 `common/`（通用）或语言目录（`java/`、`python/` 等）归类
- **learnings**：frontmatter 含 `title` / `author` / `date` / `tags`（2-5 个），正文写背景、方案、总结
- **禁止提交**：密钥、内网账号、个人敏感信息（一律 `${VAR}` 占位 + `~/.teamai/env`）
- **个人工具配置禁入库**：`.claude/settings.json` 等（常含密钥与个人权限）只留本机，不入团队仓

## 5. 命令全集（v0.20.0）

**核心**：`init` / `pull` / `push` / `status` / `remove <type> <names...>` / `doctor` / `update` / `uninstall`

**技能**：`skill list` / `skill show <name>` / `skill exclude add|remove|list`

**成员与角色**：`members list` / `roles list|set|init|add|remove|update`（*本团队未启用 roles*）

**标签过滤**：`tags list|subscribe|unsubscribe|add|remove`（*本团队未启用*）

**hooks / mcp**：`hooks list|inject|remove` / `mcp list|inject|remove`（inject 支持 `--dry-run`、`--force`）

**跨团队订阅**：`source add <repo> [--name]` / `source list` / `source browse <name>` / `source remove <name>` / `source add-http <endpoint> [--token]` / `source remove-http`

**知识库**：
- `recall <query...>`（`--depth`、`--check` 相关性预检）/ `recall enable|disable|status`
- `recall feedback --positive|--negative <docId>` — 召回结果反馈
- `recall maintenance --prune|--update-quality [--dry-run]` — 低置信度清理
- `recall promote [learningId] --category skills|rules|docs` — learning 升级为正式知识
- `import --dir|--from-repo|--from-repo-list|--from-org|--from-mr|--from-iwiki` — 导入知识建图谱（`--incremental`、`--skip-enrich`、`--cache-status`、`--cache-gc`）
- `codebase --lint|--status` — teamwiki 图谱健康检查

**会话与统计**：`session save [--push]` / `digest`（团队周报）/ `stats [--by-repo|--by-time]` / `dashboard [-p 3721]`（Web UI）

**CI**：`ci extract-mr --url <url> [--mode comment|write|both]`

**审阅**：`review [id] --apply|--reject|--all-apply [--max-risk]`（处理 `.teamai/pending-review.jsonl`）

全局选项：`--dry-run`、`-v/--verbose`

## 6. 常见问题

**pull 后本地某条规则/技能不见了？**
团队仓是单一事实来源，本地多出的文件会被清理。要保留先 `teamai push` 入库。

**hooks / mcp 更新了但没生效？**
本团队 `autoApply: false`，pull 只提示不应用。手动 `teamai hooks inject` / `teamai mcp inject`，再重启 AI 会话。

**想关掉知识召回提示？**
`teamai recall disable`（只影响本机，不改团队默认）。

**彻底卸载？**
`teamai uninstall`（`--agent <name>` 只卸某个工具的资源）。

**`settings.json` 的 permissions 要放进团队仓吗？**
不要。`permissions`（allow / deny / ask）是个人本地配置，teamai-cli v0.20.0 不分发（源码验证；仅"单仓模式"会把整份 `.claude/settings.json` 提交到 main，本团队非该模式）。`teamai hooks inject` / `mcp inject` 只写各自配置段，不会改动你的 `permissions`。`settings.json` 常含 API key，**严禁入仓**。
