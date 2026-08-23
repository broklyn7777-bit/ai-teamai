# ai-teamai — 团队 AI 资源共享仓库

基于 [teamai-cli](https://github.com/Tencent/teamai-cli) 的团队 Harness 仓库：把团队的 **skills / rules / agents / docs / 经验知识** 集中在一个 git 仓库，通过 `teamai pull/push` 分发到每位成员的 AI 编码工具（Claude Code / Codex / Cursor / CodeBuddy）。

## 快速开始

### 安装 CLI

```bash
npm install -g teamai-cli
teamai --version
```

### 管理员初始化（已完成，见下方接入方式）

### 成员接入

```bash
# 项目级（默认）：资源装到 <项目>/.claude/ 等目录
cd /path/to/your-project
teamai init https://gitee.com/gitciyo/ai-teamai.git

# 用户级：资源装到 ~/（跨项目通用规范，推荐用于本仓库）
teamai init https://gitee.com/gitciyo/ai-teamai.git --scope user
```

接入后每次 AI 会话启动会自动 `teamai pull`，始终拿到最新团队资源。

## 目录结构

```
├── teamai.yaml              # 团队配置（评审人、共享策略、recall 开关）
├── culture.md               # 团队文化（注入各工具 CLAUDE.md）
├── skills/                  # 团队技能（按命名空间分组）
│   └── spec/                #   代码知识梳理
│       ├── backend-service-spec-skill/    # 后端服务 codemap / 领域梳理 / 需求事实抽取
│       └── cross-tech-stack-spec-skill/   # 混合技术栈（移动端/H5/Python）扩展
├── rules/                   # 编码规则（pull 后同步到各工具 rules/）
│   ├── common/              #   通用：编码风格、测试、安全、性能、智能体编排
│   ├── java/                #   Java：API 设计、数据库、Redis、Kafka、定时任务、国际化等
│   ├── python/              #   Python
│   └── typescript/          #   TypeScript
├── agents/                  # 评审子代理（pull 后部署到各工具 agents/）
│   ├── java-reviewer.md
│   ├── database-reviewer.md
│   ├── security-reviewer.md
│   └── code-reviewer.md
├── docs/                    # 团队文档（同步到 sharing.docs.localDir）
│   └── onboarding.md        #   新成员指南
├── learnings/               # 知识库：会话经验沉淀（带 frontmatter，供 teamai recall 检索）
├── hooks/hooks.yaml         # 团队 hooks 声明（默认空，显式同意后生效）
├── mcp/mcp.yaml             # 团队 MCP Server 声明（默认空）
├── env/env.yaml             # 团队环境变量（禁止放密钥）
└── members/                 # 成员注册（teamai init 自动写入）
```

## 日常工作流

```bash
teamai pull                    # 拉取最新团队资源（会话启动时自动执行）
teamai push                    # 把本地新增/修改的资源推送为 MR
teamai status                  # 查看本地与团队仓库差异
teamai recall "关键词"          # 检索团队知识库（BM25 + 图谱加权）
teamai contribute --file x.md  # 直接贡献一篇经验文档到 learnings/
teamai doctor                  # 配置诊断
```

经验自动沉淀：会话结束时 Stop hook 按"摩擦信号"评分，踩坑会话会提示运行 `/teamai-share-learnings` 生成经验文档。

## 内容来源

- **rules/**、**agents/**：整理自团队既有工程规范（Java 后端为主），命名空间结构与 [teamai-hub/template-backend](https://github.com/teamai-hub/template-backend) 社区模板一致。
- **skills/spec/**：团队代码知识梳理方法论（`create_codemap` / `service_deep_dive` / `build_domain_map` 等工作流）。
- CLI 内置 skills（`teamai-share-learnings`、`team-wiki-codebase` 等）由 teamai-cli 自动部署，**不要**手动放进本仓库。

## 注意事项

1. **规则同步是覆盖式的**：`teamai pull` 会清理本地 `rules/` 中团队仓库没有的文件。个人私有规则请先 `teamai push` 入库，否则会在下次 pull 时被删除。
2. **Gitee 限制**：teamai-cli 的 MR 提供方仅支持 github / tgit / cnb。本仓库托管在 Gitee，clone / pull / 直接推送正常，但 `teamai push` 自动建 MR 会失败——改动会保留在本地克隆，需人工提交推送。如需完整 MR 流程，可将仓库镜像到 GitHub。
3. **hooks / MCP 默认显式同意**：`sharing.hooks.autoApply: false`、`sharing.mcp.autoApply: false`，成员需手动 `teamai hooks inject` / `teamai mcp inject`。
4. **密钥管理**：`env/env.yaml` 与 `mcp/mcp.yaml` 中禁止明文密钥；MCP 用 `${VAR}` 占位，值来自成员本机环境变量。
5. **角色（可选）**：未来如需按角色分发 skills，用 `teamai roles init` 生成 `manifest/roles.yaml`；未启用角色时所有资源全量同步。

## 参考资料

- [teamai-cli README](https://github.com/Tencent/teamai-cli)
- [使用指南（中文）](https://github.com/Tencent/teamai-cli/blob/main/docs/usage-guide.zh-CN.md)
- [社区模板：teamai-hub](https://github.com/teamai-hub)
