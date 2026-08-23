# 团队技能索引

> 共 61 个技能，按命名空间组织于 `skills/`。`teamai pull` 后安装到各工具的 skills 目录。

## spec — 代码知识梳理（2）

| 技能 | 说明 |
|------|------|
| `backend-service-spec-skill` | 用于旧系统、微服务、平台型仓库的代码知识梳理与中央知识库沉淀。统一支持跨服务 create_codemap、跨服务业务域梳理、crate_router_m... |
| `cross-tech-stack-spec-skill` | Explicit extension skill for cross-tech-stack project analysis and documentat... |

## uac — UAC 平台规范（10）

| 技能 | 说明 |
|------|------|
| `uac-api-design` | RESTful API 设计专家。用于设计 RESTful API、实现 Controller 端点、创建 DTO/VO、配置参数验证、处理 API 文档... |
| `uac-database` | 数据库设计专家。用于设计数据库 schema、创建 Entity 模型、编写 MyBatis mapper、实现 DAO 层、配置多数据源路由、处理分库分... |
| `uac-excel-processing` | Excel 处理专家。用于实现 Excel 导入/导出功能、处理批量数据操作、设计大规模数据导出模式、构建数据迁移和报表功能。 覆盖 EasyExcel ... |
| `uac-file-storage` | 文件存储安全卫士。用于实现文件上传/下载功能、配置分布式文件存储、设计安全的文件处理模式、管理文件访问控制和生命周期。 覆盖 OSS（对象存储服务）集成、... |
| `uac-internationalization` | 国际化专家。用于实现多语言支持和国际字符处理、管理多个时区、为 API 响应和错误消息配置本地化。 覆盖通过远程 UAC 服务进行消息包配置、特定语言的格... |
| `uac-kafka-messaging` | 消息队列专家。用于实现 Kafka 消息队列、设计生产者/消费者架构、配置最佳实践、实现可靠消息投递。 聚焦 Kafka 使用规范、Topic/消费者组命... |
| `uac-project-architecture` | 项目架构守护者 — Java 后端项目的架构和规范专家。定义四层模块结构（Model→Biz→Controller→Provider）、分层架构约束、包命... |
| `uac-redis-cache` | 缓存优化专家。用于实现 Redis 缓存策略、配置分布式锁、构建多级缓存（Redis + Caffeine 本地缓存）、优化应用性能。 覆盖缓存穿透/击穿... |
| `uac-schedule-tasks` | 分布式调度专家。用于实现分布式定时任务、配置 Cron 表达式、设计分片策略以支持跨多个实例的并行任务执行、管理任务生命周期和重试策略。 提供 Satur... |
| `uac-security` | 安全防护卫士。用于实现身份认证/授权、数据加密、敏感数据脱敏、密钥管理、访问控制和审计日志配置。 覆盖使用 @PreAuthorize 进行接口权限验证、... |

## springboot — Spring Boot 栈（6）

| 技能 | 说明 |
|------|------|
| `java-coding-standards` | Spring Boot 服务的 Java 编码规范：命名、不可变性、Optional 用法、流、异常、泛型和项目布局。 |
| `spring-boot-upgrade-expert` | 协助开发者完成 Spring Boot 项目的版本升级（2.x→3.x 主版本升级、3.x 次版本升级）。包含依赖兼容性评估、外部配置中心（Nacos/A... |
| `springboot-patterns` | Spring Boot 架构模式、REST API 设计、分层服务、数据访问、缓存、异步处理和日志记录。用于 Java Spring Boot 后端开发。 |
| `springboot-security` | Spring Boot 服务中的认证/授权、输入校验、CSRF、密钥管理、安全头、限流和依赖安全的最佳实践。 |
| `springboot-tdd` | 使用 JUnit 5、Mockito、MockMvc、Testcontainers 和 JaCoCo 进行 Spring Boot 测试驱动开发。用于添加... |
| `springboot-verification` | Spring Boot 项目的验证闭环：构建、静态分析、带覆盖率的测试、安全扫描和差异审查，适用于发布或 PR 前。 |

## engineering — 通用工程（7）

| 技能 | 说明 |
|------|------|
| `backend-patterns` | 后端架构模式、API设计、数据库优化以及适用于Node.js、Express和Next.js API路由的服务器端最佳实践。 |
| `coding-standards` | 适用于TypeScript、JavaScript、React和Node.js开发的通用编码标准、最佳实践和模式。 |
| `e2e-testing` | Playwright E2E 测试模式、页面对象模型、配置、CI/CD 集成、工件管理和不稳定测试策略。 |
| `plankton-code-quality` | 使用Plankton进行编写时代码质量强制执行——通过钩子在每次文件编辑时自动格式化、代码检查和Claude驱动的修复。 |
| `security-review` | 在添加身份验证、处理用户输入、处理机密信息、创建API端点或实现支付/敏感功能时使用此技能。提供全面的安全检查清单和模式。 |
| `security-scan` | 使用AgentShield扫描您的Claude代码配置（.claude/目录），以发现安全漏洞、配置错误和注入风险。检查CLAUDE.md、setting... |
| `tdd-workflow` | 在编写新功能、修复错误或重构代码时使用此技能。强制执行测试驱动开发，确保单元测试、集成测试和端到端测试的覆盖率超过80%。 |

## workflow — 开发工作流编排（6）

| 技能 | 说明 |
|------|------|
| `openspec-feature-workflow` | Use when a feature needs an OpenSpec change with proposal, design, specs, and... |
| `openspec-superpowers-workflow` | Use when the user explicitly wants the full OpenSpec plus Superpowers path fr... |
| `superpowers-feature-workflow` | Use when feature work needs the Superpowers stages before or during implement... |
| `superpowers-learning-workflow` | Use when the user explicitly wants to capture lessons from completed work, pe... |
| `superpowers-openspec-execution-workflow` | Use when a feature should follow four explicit steps: Superpowers exploration... |
| `verification-loop` | Claude Code 会话的全面验证系统。 |

## superpowers — Superpowers 基础技能（12）

| 技能 | 说明 |
|------|------|
| `brainstorming` | You MUST use this before any creative work - creating features, building comp... |
| `dispatching-parallel-agents` | Use when facing 2+ independent tasks that can be worked on without shared sta... |
| `executing-plans` | Use when you have a written implementation plan to execute in a separate sess... |
| `receiving-code-review` | Use when receiving code review feedback, before implementing suggestions, esp... |
| `requesting-code-review` | Use when completing tasks, implementing major features, or before merging to ... |
| `subagent-driven-development` | Use when executing implementation plans with independent tasks in the current... |
| `systematic-debugging` | Use when encountering any bug, test failure, or unexpected behavior, before p... |
| `test-driven-development` | Use when implementing any feature or bugfix, before writing implementation code |
| `using-git-worktrees` | Use when starting feature work that needs isolation from current workspace or... |
| `using-superpowers` | Use when starting any conversation - establishes how to find and use skills, ... |
| `verification-before-completion` | Use when about to claim work is complete, fixed, or passing, before committin... |
| `writing-plans` | Use when you have a spec or requirements for a multi-step task, before touchi... |

## python — Python（2）

| 技能 | 说明 |
|------|------|
| `python-patterns` | Pythonic 惯用法、PEP 8 标准、类型提示以及构建稳健、高效且可维护的 Python 应用程序的最佳实践。 |
| `python-testing` | 使用pytest的Python测试策略，包括TDD方法、夹具、模拟、参数化和覆盖率要求。 |

## frontend — 前端（3）

| 技能 | 说明 |
|------|------|
| `browser-qa` | 浏览器自动化视觉测试与交互验证：功能部署到 staging 后、发布前或审查前端改动 PR 时使用。 |
| `frontend-patterns` | React、Next.js、状态管理、性能优化和UI最佳实践的前端开发模式。 |
| `frontend-slides` | 从零开始或通过转换PowerPoint文件创建令人惊艳、动画丰富的HTML演示文稿。当用户想要构建演示文稿、将PPT/PPTX转换为网页格式，或为演讲/推... |

## session — 会话与学习（5）

| 技能 | 说明 |
|------|------|
| `context-budget` | 审核Claude Code上下文窗口在代理、技能、MCP服务器和规则中的消耗情况。识别膨胀、冗余组件，并提供优先的令牌节省建议。 |
| `continuous-learning-v2` | 基于本能的学习系统，通过钩子观察会话，创建带置信度评分的原子本能，并将其进化为技能/命令/代理。v2.1版本增加了项目范围的本能，以防止跨项目污染。 |
| `eval-harness` | 克劳德代码会话的正式评估框架，实施评估驱动开发（EDD）原则 |
| `skill-stocktake` | 用于审计Claude技能和命令的质量。支持快速扫描（仅变更技能）和全面盘点模式，采用顺序子代理批量评估。 |
| `strategic-compact` | 建议在逻辑间隔处手动压缩上下文，以在任务阶段中保留上下文，而非任意的自动压缩。 |

## tooling — 工具与平台（6）

| 技能 | 说明 |
|------|------|
| `agent-browser` | Browser automation CLI for AI agents. Use when the user needs to interact wit... |
| `article-writing` | 根据提供的示例或品牌指导，以独特的语气撰写文章、指南、博客帖子、教程、新闻简报等长篇内容。当用户需要超过一段的精致书面内容时使用，尤其是当语气一致性、结构... |
| `deep-research` | 使用firecrawl和exa MCPs进行多源深度研究。搜索网络、综合发现并交付带有来源引用的报告。适用于用户希望对任何主题进行有证据和引用的彻底研究时。 |
| `documentation-lookup` | 通过 Context7 MCP 使用最新的库和框架文档，而非训练数据。当用户提出设置问题、API参考、代码示例或命名框架（例如 React、Next.js... |
| `prd-doc-writer` | Write and iteratively refine PRD/需求文档 with a story-driven structure and stric... |
| `prompt-optimizer` | 分析原始提示，识别意图和差距，匹配ECC组件（技能/命令/代理/钩子），并输出一个可直接粘贴的优化提示。仅提供咨询角色——绝不自行执行任务。触发时机：当用... |

## dikm — DIKM 跨仓库协同（2）

| 技能 | 说明 |
|------|------|
| `dikm-cross-repo-rebase-sync` | 跨仓库 Git 同步：处理无共同历史时使用 rebase --onto 安全合并本地定制提交 |
| `dikm-project-replication` | 将功能从一个项目复制/移植/迁移到技术栈不同的另一个项目。 当用户想要跨项目移植功能、适配架构模式时使用 （如"把 Multica 的 Issue 管理复... |
