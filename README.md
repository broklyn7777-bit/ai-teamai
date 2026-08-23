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
├── skills/                  # 团队技能（61 个，按命名空间分组，详见 docs/skills-index.md）
│   ├── spec/        (2)     #   代码知识梳理：backend-service-spec / cross-tech-stack-spec
│   ├── uac/        (10)     #   UAC 平台规范（被 rules/java/* 引用）
│   ├── springboot/  (6)     #   Spring Boot 栈（被 java-reviewer 引用）
│   ├── engineering/ (7)     #   通用工程 + 安全扫描 + 编写期质量
│   ├── workflow/    (6)     #   superpowers/openspec 工作流编排 + 验证闭环
│   ├── superpowers/(12)     #   Superpowers 基础技能（工作流技能的依赖）
│   ├── python/      (2)     #   Python 模式与测试
│   ├── frontend/    (3)     #   前端模式 / 演示文稿 / 浏览器 QA
│   ├── session/     (5)     #   会话管理：上下文预算 / 压缩 / 评估 / 学习
│   ├── tooling/     (6)     #   浏览器自动化 / 研究 / 写作 / PRD / 提示词优化
│   └── dikm/        (2)     #   DIKM 跨仓库同步与项目复刻
├── rules/                   # 编码规则（pull 后同步到各工具 rules/）
│   ├── common/              #   通用：编码风格、测试、安全、性能、智能体编排
│   ├── java/                #   Java：API 设计、数据库、Redis、Kafka、定时任务、国际化等
│   ├── python/              #   Python
│   └── typescript/          #   TypeScript
├── agents/                  # 14 个子代理（pull 后部署到各工具 agents/）
│                            #   评审：java / database / security / code / python / typescript-reviewer
│                            #   流程：planner / architect / tdd-guide / e2e-runner / refactor-cleaner
│                            #   支持：build-error-resolver / doc-updater / docs-lookup
├── docs/                    # 团队文档（同步到 sharing.docs.localDir）
│   ├── onboarding.md        #   新成员指南
│   ├── harness-guide.md     #   ECC harness 使用指南（哲学/工作流/智能体编排）
│   ├── skills-index.md      #   全部技能索引（按命名空间）
│   ├── superpowers-workflow.md      # Superpowers/OpenSpec 工作流选型与路由
│   ├── uac-skills-analysis.md       # UAC 技能体系评估报告
├── learnings/               # 知识库：会话经验沉淀（带 frontmatter，供 teamai recall 检索）
├── hooks/hooks.yaml         # 团队 hooks（3 条：禁 --no-verify / 敏感文件拦截 / Spring 格式化，显式同意后生效）
├── mcp/mcp.yaml             # 团队 MCP（8 个：浏览器/抓取/文档检索/代码图谱/搜索/MySQL/Nacos，凭据全占位符，显式同意后生效）
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

- **rules/**：整理自团队既有工程规范（Java 后端为主），命名空间结构与 [teamai-hub/template-backend](https://github.com/teamai-hub/template-backend) 社区模板对齐。`java/*` 规则与 `skills/uac/` 配套使用——规则是核心约束，skill 是详细模板与排障指南。
- **agents/**：14 个生产子代理——评审类（java/database/security/code/python/typescript-reviewer）、流程类（planner/architect/tdd-guide/e2e-runner/refactor-cleaner）、支持类（build-error-resolver/doc-updater/docs-lookup）。
- **skills/spec/**：团队代码知识梳理方法论（`create_codemap` / `service_deep_dive` / `build_domain_map` 等工作流）。
- **skills/uac/**、**skills/springboot/**：UAC 平台规范与 Spring Boot 栈最佳实践，源自项目实战（gis-lbc-ibs-demo），被 rules/reviewers 直接引用。
- **skills/engineering/**、**skills/workflow/**、**skills/superpowers/**：通用工程、工作流编排与 Superpowers 基础技能（整理自项目与 ECC 社区内容）。
- **skills/python/、frontend/、session/、tooling/、dikm/**：语言专项、会话管理、工具平台与跨仓库协同技能（源自项目 .claude，`agent-browser` 已排除 1.8MB 示例图片）。
- **docs/**：harness 指南、技能索引、superpowers 工作流为总结文档；UAC 技能评估报告原文入库。
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
