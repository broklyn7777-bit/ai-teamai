# AI 编程武器库 — 技能包、MCP 与工作流精选清单 (2026 版)

> **简介**：整合技能包（Skills）、MCP 服务器与 AI 开发工作流的终极工具箱。覆盖架构分析、文档自动化、全栈开发、安全审计、创意设计、端到端工作流编排。
> **适用工具**：Claude Code, OpenCode, 及其他支持 SKILL.md 规范的 AI 助手。  
> **更新时间**：2026-07-23
> **验证说明**：所有条目均经实际 GitHub 仓库验证，标注星级、活跃度与兼容性。hyperframes 于 2026-07-23 深度验证（克隆仓库 + 逐文件分析）。  
> **真实性标识**：✅ 已验证存在并可用 | ⚠️ 存在但有兼容性限制 | ❌ 不存在/未实现 | 🔥 高热度推荐

---

## 第一部分：后端开发 (Backend Development)

*企业级后端架构、API 设计与代码精简*

### code-simplifier 代码精简器 🔥

| 字段 | 值 |
|------|---|
| **来源** | Anthropic 官方内置插件 |
| **仓库** | [anthropics/claude-code](https://github.com/anthropics/claude-code) |
| **状态** | ✅ 已验证，Claude Code 内置 |
| **活跃度** | 极高（Anthropic 官方维护，每周多次提交） |
| **核心功能** | 专家级代码简化，专注于提升代码可读性、一致性和可维护性，同时保持功能完全不变。适用于代码编写后的重构优化阶段。 |
| **安装方式** | 无需安装，Claude Code 内置。社区版：`npx skills add getsentry/skills --skill code-simplifier` |
| **注意** | 以 Agent 定义文件形式存在（非标准 SKILL.md），在 Skill 工具中显示为 Task 类型 |

### api-design-principles 接口规范专家 🔥

| 字段 | 值 |
|------|---|
| **来源** | [wshobson/agents](https://github.com/wshobson/agents) |
| **状态** | ✅ 已验证，SKILL.md 存在 |
| **Stars** | ⭐ 14.5k+ |
| **活跃度** | 极高（2026-04 更新 v0.4.0，182 个 Agent、149 个 Skill） |
| **核心功能** | 掌握 REST 和 GraphQL API 设计原则，构建直观、可扩展、可维护的接口。支持资源导向端点设计、API 重构、团队级 API 规范制定。附带 REST/GraphQL 最佳实践参考文档。 |
| **安装命令** | `npx skills add https://github.com/wshobson/agents --skill api-design-principles` |

---

## 第二部分：前端开发 (Frontend Development)

*视觉质感增强与 Web 设计规范*

### frontend-design 前端设计质感增强器 🔥

| 字段 | 值 |
|------|---|
| **来源** | [anthropics/skills](https://github.com/anthropics/skills) |
| **状态** | ✅ 已验证，Anthropic 官方技能 |
| **Stars** | 仓库 ⭐ 40k+ |
| **活跃度** | 高（2026-01 PR #210 改进技能清晰度与可操作性） |
| **核心功能** | **生成型技能**：指导 AI 创建生产级前端界面，强制追求大胆的美学方向、独特的排版、创意配色、动效与空间构图。**明确禁止**通用 AI 审美（Inter/Roboto 字体、紫色渐变白底、可预测布局）。 |
| **安装命令** | `npx skills add https://github.com/anthropics/skills --skill frontend-design` |

---

## 第三部分：Python 开发

### python-design-patterns Python 工程化设计模式

| 字段 | 值 |
|------|---|
| **来源** | [wshobson/agents](https://github.com/wshobson/agents) |
| **状态** | ✅ 已验证，SKILL.md 存在 |
| **Stars** | 仓库 ⭐ 14.5k+ |
| **活跃度** | 极高（2026-03 持续更新，Dependabot PR 2026-04-11） |
| **核心功能** | 指导编写可维护的 Python 代码，涵盖 KISS 原则、关注点分离、单一职责原则 (SRP)、组合优于继承等核心设计原则。帮助构建易于理解、测试和修改的系统。 |
| **安装命令** | `npx skills add https://github.com/wshobson/agents --skill python-design-patterns` |

---

## 第四部分：设计 (Design & UX)

### ui-ux-pro-max UI/UX 设计专家 🔥🔥

| 字段 | 值 |
|------|---|
| **来源** | [nextlevelbuilder/ui-ux-pro-max-skill](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill) |
| **状态** | ✅ 已验证，v2.1.0 发布 |
| **Stars** | ⭐ 63k+（**Claude Code 技能中最高星标**） |
| **活跃度** | 极高（每周更新，6,300+ forks） |
| **核心功能** | AI 编程助手的设计智慧数据库。包含 50+ UI 风格参考、161 种配色方案、57 组字体搭配、图表类型和 UX 最佳实践。兼容 Claude Code、Cursor、Windsurf。 |
| **安装命令** | `npx skills add https://github.com/nextlevelbuilder/ui-ux-pro-max-skill --skill ui-ux-pro-max` |

---

## 第五部分：PRD / 需求文档 (Product Requirements)

### prd-doc-writer PRD 文档撰写器 🔥

| 字段 | 值 |
|------|---|
| **来源** | [yunshu0909/yunshu_skillshub](https://github.com/yunshu0909/yunshu_skillshub) |
| **状态** | ✅ 已验证，SKILL.md 存在 |
| **Stars** | ⭐ 354 |
| **活跃度** | 中等（持续更新，新增多维度分析视角） |
| **核心功能** | 故事驱动的 PRD 编写，采用严格的分阶段确认流程（旅程图对齐 → 逐故事单点确认 → 最终生成门控）。支持 ASCII 线框图和 Mermaid 动态流程图。核心理念：「PRD 是故事集合」。 |
| **安装命令** | `npx skills add https://github.com/yunshu0909/yunshu_skillshub --skill prd-doc-writer` |

---

## 第六部分：架构图与文档 (Diagrams & Documentation)

### mermaid-diagrams 架构图可视化 🔥

| 字段 | 值 |
|------|---|
| **来源** | [softaworks/agent-toolkit](https://github.com/softaworks/agent-toolkit) |
| **状态** | ✅ 已验证，SKILL.md 存在 |
| **Stars** | ⭐ 1.5k+ |
| **活跃度** | 中等（117 forks，42 技能工具包） |
| **核心功能** | 使用 Mermaid 语法创建专业软件架构图，覆盖流程图、ERD、类图、时序图和 C4 架构图。文本转图，适合文档化系统架构。 |
| **安装命令** | `npx skills add https://github.com/softaworks/agent-toolkit --skill mermaid-diagrams` |

### ppt-master PPT 演示文稿生成 🔥🔥🔥

| 字段 | 值 |
|------|---|
| **来源** | [hugohe3/ppt-master](https://atomgit.com/hugohe3/ppt-master) |
| **平台** | AtomGit（国内代码托管） |
| **状态** | ✅ 已验证，已安装可用 |
| **核心功能** | AI 驱动的多格式 SVG 内容生成系统，支持 PDF/DOCX/URL/Markdown 等源文档一键转换为高质量 SVG 页面并导出为 PPTX。采用多角色协作模式（内容解析→SVG 生成→PPTX 导出），支持自定义主题、模板、排版。触发场景：「生成 PPT」「制作幻灯片」「做演示文稿」。 |
| **安装方式** | 手动安装（AtomGit 平台，不支持 `npx skills add`），需将 SKILL.md 复制到 `.claude/skills/ppt-master/` 目录 |
| **前置依赖** | 需安装 `pptx` 技能处理 Word/PPTX 文件交互 |
| **兼容平台** | Claude Code, OpenCode, 及其他支持 SKILL.md 规范的 AI 助手 |

### html-ppt-skill HTML 幻灯片生成 🔥🔥

| 字段       | 值                                                                                                                                                                                                                                 |
| -------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **来源**   | [lewislulu/html-ppt-skill](https://github.com/lewislulu/html-ppt-skill)                                                                                                                                                           |
| **状态**   | ✅ 已验证，GitHub 开源                                                                                                                                                                                                                   |
| **核心功能** | AI Agent 的幻灯片生成工具库，提供 36 套设计主题、47 种动画（27 种 CSS 动画 + 20 种 Canvas 特效）、14 套完整模板、31 种页面布局。采用纯静态 HTML+CSS+JS，零构建工具链。Token 驱动设计系统，换主题只需更换 `<link>` 标签。内置中英文字体优先支持（Noto Sans SC / Noto Serif SC），解决中文渲染问题。AI 不再自由发挥 CSS，而是在结构化设计系统内填充内容。 |
| **安装命令** | `npx skills add https://github.com/lewislulu/html-ppt-skill`                                                                                                                                                                      |
| **特色主题** | `neo-brutalism`（粗线条高饱和）、`glassmorphism`（毛玻璃渐变）、`xiaohongshu-white`（小红书白底风）、`tokyo-night`（暗色程序员风）、`swiss-grid`（瑞士网格设计）                                                                                                             |
| **特色动画** | CSS 类：typewriter/glitch-in/counter-up/card-flip-3d/parallax-tilt；Canvas 类：matrix-rain/knowledge-graph/firework/neural-net/galaxy-swirl                                                                                            |
| **内置模板** | pitch-deck（融资路演）、product-launch（产品发布）、tech-sharing（技术分享）、weekly-report（周报）、xhs-post（小红书图文）、course-module（课程教学）等 14 套                                                                                                              |
| **快捷键**  | `T` 切换主题，`O` 概览模式，`F` 全屏，`A` 播放当前页动画                                                                                                                                                                                              |
| **技术特点** | 零构建（无 webpack/vite/node_modules）、双击 HTML 直接运行、纯静态部署、AI 生成代码即插即用                                                                                                                                                                   |

### hyperframes HTML 原生视频渲染框架 🔥🔥🔥

| 字段 | 值 |
|------|---|
| **来源** | [heygen-com/hyperframes](https://github.com/heygen-com/hyperframes) |
| **状态** | ✅ 已验证，HeyGen 开源，Apache 2.0 许可证 |
| **活跃度** | 极高（最近更新 2026-07-22，日级提交节奏） |
| **核心功能** | **「Write HTML. Render video. Built for agents.」** 开源视频渲染框架，将 HTML/CSS/媒体/可定位动画转化为确定性 MP4 视频。19 个 AI Agent 技能，三层架构：路由器（`/hyperframes`）→ 10 个创作工作流 → 9 个原子领域能力。支持本地 CLI、AI Agent 调用、Docker 渲染和 AWS Lambda 分布式渲染。已在 HeyGen 生产环境使用，tldraw、TanStack 等团队也在用。 |
| **安装命令** | `npx skills add heygen-com/hyperframes --full-depth`（核心集）/ `npx skills add heygen-com/hyperframes --all --full-depth`（全部 19 个） |
| **技术栈** | Bun monorepo + TypeScript + Puppeteer + FFmpeg + Headless Chrome；14 个子包（cli/core/engine/producer/player/studio/shader-transitions/aws-lambda 等）；50+ 可安装 block 和 component |
| **vs Remotion** | HyperFrames 用纯 HTML（无构建步骤，`index.html` 直接可播放），Remotion 用 React（需 bundler）；HyperFrames 对 Agent 更友好（Agent 天然会写 HTML），Remotion 需要 JSX 项目；HyperFrames Apache 2.0，Remotion 为 source-available 许可 |
| **核心创新** | ① **HTML 原生**：composition 就是带 `data-*` 定时属性的 HTML 文件，`class="clip"` 标记片段；② **确定性渲染**：相同输入 → 相同帧 → 相同输出，天然适配 CI/回归测试；③ **Frame Adapter 模式**：动画运行时通过适配器接入，支持 GSAP（主适配器）/CSS/Lottie/Three.js/Anime.js/WAAPI/TypeGPU；④ **Intent Layer + Router**：意图面试 → 工作流路由 → 按需懒加载领域技能；⑤ **frame.md**：将 Web 设计系统反转为镜头语言，AI Agent 可据此组合视频而无需猜测尺度；⑥ **项目状态恢复**：通过 `BRIEF.md` / `hyperframes.json` / `STORYBOARD.md` 断点续作 |
| **10 个创作工作流** | `/product-launch-video`（网站 → 产品宣传视频）· `/faceless-explainer`（文本 → 无人出镜解说视频）· `/pr-to-video`（GitHub PR → 代码变更解说）· `/embedded-captions`（人声视频 → 嵌入字幕）· `/talking-head-recut`（访谈视频 → 叠加动态图形）· `/motion-graphics`（短动效 <10s）· `/music-to-video`（音乐 → 节拍同步视频）· `/slideshow`（演示/交互式幻灯片）· `/general-video`（万能兜底 + companion 共创模式）· `/remotion-to-hyperframes`（Remotion → HyperFrames 单向迁移） |
| **9 个原子领域能力** | `/hyperframes-core`（composition 契约）· `/hyperframes-animation`（动画知识 + 场景蓝图）· `/hyperframes-keyframes`（跨运行时 seek-safe 关键帧）· `/hyperframes-creative`（创意方向：配色/字体/旁白/节拍）· `/media-use`（媒体 OS：BGM/SFX/图片/TTS/去背景/字幕）· `/hyperframes-cli`（init/lint/check/preview/render/publish）· `/hyperframes-registry`（50+ block/component 注册表）· `/figma`（Figma → 重构运动） |
| **技能架构亮点** | **路由器模式**：`/hyperframes` 是入口技能，读取 `references/routes/<workflow>.md` 做意图分发，工作流按需安装（`npx hyperframes skills update <workflow>`），不预装全部 19 个；**优先级路由表**：10 个路由按优先级匹配（port > slideshow > captions > overlays > music > motion > PR > product > explainer > general）；**歧义消解**：明确定义常见输入冲突的裁决规则（如字幕 vs 叠加图形的区分、音乐驱动 vs 音乐背景的区分） |
| **兼容平台** | Claude Code, Cursor, Gemini CLI, Codex, 及支持 Skills 规范的 AI 助手 |

### zread 代码库 Wiki 文档生成器 🔥

| 字段 | 值 |
|------|---|
| **来源** | [ZreadAI/zread-skill](https://github.com/ZreadAI/zread-skill) |
| **状态** | ✅ 已验证，SKILL.md 存在，CLI 可用 |
| **核心功能** | **从代码库自动生成 Wiki 文档**。通过 LLM 分析当前工作区代码，生成结构化的 wiki 页面（TOC + 分页面 Markdown），输出到 `./.zread/wiki/` 目录。支持版本化管理（每次生成独立版本目录）， drafts 断点续作，`--stdio` JSON-line 机器协议适配 AI Agent 调用。公开仓库可在 https://zread.ai 在线浏览。 |
| **安装命令** | 从 [ZreadAI/zread-skill](https://github.com/ZreadAI/zread-skill) 安装 SKILL.md 到 `.claude/skills/zread/`，CLI 通过 `zread` 命令使用 |
| **核心命令** | `zread generate`（生成 wiki）、`zread browse`（本地浏览 http://localhost:9681）、`zread login`（OAuth 登录获取 API Key）、`zread config`（配置 LLM 提供商/语言/并发数） |
| **Agent 集成** | 所有命令支持 `--stdio` 模式（JSON-line 协议），AI Agent 可直接解析输出；现有 wiki 时 Agent 直接读取磁盘文件无需调用 CLI；支持 `mcp__zread__*` MCP 工具（`get_repo_structure`/`read_file`/`search_doc`）远程查阅公开仓库 |
| **磁盘布局** | `.zread/wiki/current`（当前版本 ID）→ `versions/<id>/wiki.json`（TOC 索引）→ `versions/<id>/<file>`（页面 Markdown）；`drafts/` 目录存在表示上次生成未完成，支持 `--draft resume\|clear\|cancel` |
| **安全特性** | 只写入 `./.zread/` 目录，不修改 git 跟踪文件；`generate` 消耗 LLM tokens（有实际成本），大仓库需数分钟；`drafts/` 可安全删除恢复卡死状态 |
| **兼容平台** | Claude Code, OpenCode, 及支持 SKILL.md 规范的 AI 助手 |

### codebase-knowledge-wiki 代码知识库构建技能库 🔥🔥

| 字段 | 值 |
|------|---|
| **来源** | [SYZ-Coder/codebase-knowledge-wiki](https://github.com/SYZ-Coder/codebase-knowledge-wiki) |
| **状态** | ✅ 已验证，SKILL.md × 2 存在，多平台安装脚本可用 |
| **核心功能** | **面向后端微服务和混合技术栈的代码知识梳理与中央知识库建设**。吸收 zread 和 sdd-riper 思路并大幅扩展，提供 5 大核心命令：`create_codemap`（全局服务版图）、`service_deep_dive`（单服务纵向分析）、`crate_router_map`（真实请求链/消息链追踪）、`build_domain_map`（业务领域知识沉淀）、`requirement_fact_map`（从代码提取事实需求）。严格基于代码事实输出，显式区分证据等级与闭环状态。产物输出到 `mydocs/` 目录（含 codemap/services/routermap/domains/requirements/context/validation/index 七层结构）。 |
| **双技能架构** | **backend-service-spec-skill**（主技能）：后端/微服务/遗留系统知识地图；**cross-tech-stack-spec-skill**（扩展技能）：移动端、H5、Python、混合栈适配，支持 8 个可选开关（契约映射、Gateway 分析、字段溯源、上下文传播、错误语义、异步契约、外部依赖档案、接口验证资产） |
| **安装命令** | `bash ./scripts/install.sh claude <target-project-dir>`（Claude Code）/ `bash ./scripts/install.sh codex`（Codex）/ `bash ./scripts/install.sh cursor <target-project-dir>`（Cursor）/ `bash ./scripts/install.sh opencode <target-project-dir>`（OpenCode） |
| **输出结构** | `mydocs/codemap/`（全局版图）→ `mydocs/services/`（单服务结构）→ `mydocs/routermap/`（链路追踪）→ `mydocs/domains/`（领域知识）→ `mydocs/requirements/`（事实需求）→ `mydocs/context/`（跨服务共享上下文）→ `mydocs/validation/`（证据闭环验证）→ `mydocs/index/`（索引与阅读顺序） |
| **分析模式** | 轻量完整（1-2 个高价值服务 + 1-2 条关键链路）/ 重型完整（多个服务 + 多条链路 + 领域沉淀 + 验证页面）/ 全量分析（开启全部 8 个可选开关） |
| **兼容平台** | Claude Code, Codex, Cursor, OpenCode（提供跨平台安装脚本 + 原生规则文件） |
| **vs zread** | zread 侧重**自动生成通用 wiki**（LLM 驱动，一键生成）；codebase-knowledge-wiki 侧重**结构化知识梳理**（命令驱动，按 codemap→deep-dive→router-map→domain-map 逐层深入），更适合团队级后端微服务和遗留系统，产物可直接沉淀为中央知识库 |

---

## 第七部分：代码审查 (Code Review)

### code-reviewer AI 审查员（Gemini CLI 版）⚠️

| 字段 | 值 |
|------|---|
| **来源** | [google-gemini/gemini-cli](https://github.com/google-gemini/gemini-cli) |
| **状态** | ✅ 已验证（但为 Gemini 原生技能） |
| **Stars** | ⭐ 100.8k+ |
| **活跃度** | 极高（日级更新，v0.37.1 发布于 2026-04-09） |
| **核心功能** | 结构化代码审查工作流，覆盖七大维度：正确性、可维护性、可读性、效率、安全性、边界条件/异常处理、可测试性。支持本地变更和远程 PR 审查。输出按严重等级（Critical/Improvements/Nitpicks）组织。 |
| **安装方式** | 需手动复制 SKILL.md 到 `.claude/skills/code-reviewer/` 目录，Gemini CLI 内置，不支持 `npx skills add` |
| **兼容性** | ⚠️ 部分兼容。SKILL.md 格式通用，但部分 gh CLI 工作流引用需适配 Claude Code 工具集 |

### sanyuan-skills SOLID 原则 + 安全 + 性能 🔥

| 字段 | 值 |
|------|---|
| **来源** | [sanyuan0704/sanyuan-skills](https://github.com/sanyuan0704/sanyuan-skills) |
| **状态** | ✅ 已验证，原生 Claude Code 技能 |
| **Stars** | ⭐ 3.1k+ |
| **活跃度** | 活跃（2026-03 持续更新） |
| **核心功能** | 资深工程师级代码审查，覆盖 SOLID 原则、安全性、性能、错误处理、边界条件。含 code-review 主技能 + sigma AI 教学技能 + skill-forge 元技能创建工具。 |
| **安装命令** | `npx skills add https://github.com/sanyuan0704/sanyuan-skills` |
| **兼容性** | ✅ 完全兼容，原生 Claude Code 技能 |

---

## 第八部分：测试 (Testing & QA)

### webapp-testing Playwright 自动化测试

| 字段        | 值                                                                            |
| --------- | ---------------------------------------------------------------------------- |
| **来源**    | [anthropics/skills](https://github.com/anthropics/skills)                    |
| **状态**    | ✅ 已验证，Anthropic 官方技能                                                         |
| **Stars** | 仓库 ⭐ 101k+                                                                   |
| **活跃度**   | 极高（2026-03~04 持续更新）                                                          |
| **核心功能**  | 基于 Playwright 的 Web 应用自动化测试。支持功能验证、UI 行为调试、截图对比。覆盖本地 Web 应用的端到端测试场景。         |
| **安装命令**  | `npx skills add https://github.com/anthropics/skills --skill webapp-testing` |

### audit-website 网站体检专家 🔥

| 字段 | 值 |
|------|---|
| **来源** | [squirrelscan/skills](https://github.com/squirrelscan/skills) |
| **状态** | ✅ 已验证，SKILL.md + OUTPUT-FORMAT.md |
| **Stars** | ⭐ 42.5k+ |
| **活跃度** | 活跃（2026-02 更新） |
| **核心功能** | 230+ 审计规则覆盖 SEO、性能、可访问性、内容质量、安全性，以及 96 种泄露密钥/机密检测。集成 SquirrelScan CLI 工具。 |
| **安装命令** | `npx skills add https://github.com/squirrelscan/skills --skill audit-website` |

---

## 第九部分：调研与信息获取 (Research & Information)

### agent-browser 浏览器自动化代理 🔥

| 字段 | 值 |
|------|---|
| **来源** | [vercel-labs/agent-browser](https://github.com/vercel-labs/agent-browser) |
| **状态** | ✅ 已验证，SKILL.md 存在 |
| **Stars** | ⭐ 28.7k+ |
| **活跃度** | 极高（2026-04-06 更新） |
| **核心功能** | Rust 实现的浏览器自动化 CLI，采用「快照引用」交互模式（非传统 CSS 选择器），脚本稳定性更高。覆盖 50+ 能力：导航、表单填写、点击、截图、网络捕获。适合复杂业务场景自动化。 |
| **安装命令** | `npx skills add https://github.com/vercel-labs/agent-browser --skill agent-browser` |

### web-access 全平台内容访问

| 字段 | 值 |
|------|---|
| **来源** | [eze-is/web-access](https://github.com/eze-is/web-access) |
| **状态** | ✅ 已验证，SKILL.md 存在 |
| **Stars** | ⭐ 3.9k+（快速增长中） |
| **活跃度** | 极高（2026-04 持续更新） |
| **核心功能** | 为 Claude Code 提供完整联网能力：搜索、网页抓取、登录后操作、CDP Proxy 浏览器控制。**关键优势**：支持小红书、B站、微信公众号等反爬严格平台的公开内容抓取。通过 CDP Proxy 直连 Chrome，天然携带登录态。 |
| **安装命令** | `npx skills add https://github.com/eze-is/web-access --skill web-access` |
| **前置要求** | Node.js 22+，Chrome 需开启远程调试（`chrome://inspect/#remote-debugging`） |

### rtk AI 开发助手工具包 🔥

| 字段 | 值 |
|------|---|
| **来源** | [rtk-ai/rtk](https://github.com/rtk-ai/rtk) |
| **状态** | ✅ 已验证，提供多平台二进制包 |
| **核心功能** | 为 AI 代理提供系统级工具支持：剪贴板操作、屏幕截图、文件管理、系统通知等。通过 MCP 服务器协议与 Claude Code 集成，让 AI 能直接操作用户环境。 |
| **安装方式** | 从 [GitHub Releases](https://github.com/rtk-ai/rtk/releases) 下载对应平台的二进制包，放置到 PATH 目录 |
| **MCP 配置** | `"rtk": { "command": "rtk", "args": ["mcp"] }` |
| **支持平台** | macOS、Windows、Linux（提供 amd64/arm64 架构包） |

---

## 第十部分：任务管理与工作流 (Task Management & Workflow)

### planning-with-files 文件式任务管理 🔥🔥🔥

| 字段 | 值 |
|------|---|
| **来源** | [OthmanAdi/planning-with-files](https://github.com/othmanadi/planning-with-files) |
| **状态** | ✅ 已验证，11.7k+ Stars，Manus 同款上下文工程 |
| **Stars** | ⭐ 11.7k+（爆发式增长，2026-01 出圈） |
| **活跃度** | 极高（16K+ 开发者使用，多平台适配持续更新） |
| **核心功能** | 用持久化 Markdown 文件扩展 AI 上下文窗口，解决"重启即忘"问题。通过"3 文件 + 4 钩子"模式实现 Manus 式任务管理：task_plan.md（任务规划）、findings.md（研究记录）、progress.md（进度追踪），配合 SessionStart/PreToolUse/PostToolUse/Stop 四个 Hook 自动注入上下文。防止目标漂移（Goal Drift），让 AI 具备永久记忆。 |
| **安装命令** | `npx skills add OthmanAdi/planning-with-files --skill planning-with-files -g` |
| **触发命令** | `/plan` 或 `/planning-with-files:start` 启动规划，`/plan:status` 查看进度 |
| **核心理念** | "文件系统是终极上下文：大小无限、本质持久、可由智能体直接操作" — Manus 官方博客 |
| **三文件模式** | `task_plan.md`🧠 大脑：阶段拆解+待办清单；`findings.md`📚 知识库：调研结论+参考资料；`progress.md`📝 日志：会话记录+下一步计划 |
| **四条铁律** | ① 开工前必须有 plan；② 每 2 次浏览器操作后保存 findings；③ 重大决策前重读 plan；④ 每个阶段完成后更新进度并勾选完成 |
| **兼容平台** | Claude Code, Cursor, OpenCode, Codex, KiloCode, OpenClaw 等（提供多平台配置文档） |
| **注意** | 需要 Claude Code settings.json 配置 hooks 才能发挥最大效用；简单任务不需要使用，仅推荐复杂长任务 |

---

## 第十二部分：MCP 服务器配置 (MCP Servers)

*扩展 AI 能力边界的 Model Context Protocol 服务器生态*

> **说明**：以下 MCP 服务器通过 `settings.json` 配置，为 AI 助手提供浏览器控制、网络抓取、文件系统访问、代码索引等底层能力。与技能包（Skill）互补——Skill 定义「怎么做」，MCP 提供「用什么做」。
> **配置位置**：`~/.claude/settings.json` 的 `mcpServers` 字段

### chrome-devtools Chrome 开发者工具 🔥

| 字段 | 值 |
|------|---|
| **仓库** | [anthropics/skills](https://github.com/anthropics/skills) |
| **包名** | `chrome-devtools-mcp` |
| **启动方式** | `npx -y chrome-devtools-mcp@latest --headless` |
| **类型** | stdio |
| **核心能力** | 让 AI 直接操控 Chrome DevTools 协议（CDP），实现无头浏览器调试、DOM 检查、网络请求拦截、性能分析。比 Playwright 更底层，可精确控制页面生命周期。 |
| **适用场景** | 深度浏览器自动化、前端性能调试、网络请求分析 |
| **配置** | `"command": "npx", "args": ["-y", "chrome-devtools-mcp@latest", "--headless"]` |

### fetch 网络内容获取

| 字段 | 值 |
|------|---|
| **仓库** | [modelcontextprotocol/servers](https://github.com/modelcontextprotocol/servers) |
| **包名** | `mcp-server-fetch` |
| **启动方式** | `npx -y mcp-server-fetch@latest` |
| **类型** | stdio |
| **核心能力** | Anthropic 官方 MCP 服务器，提供安全的 HTTP/HTTPS 请求能力。AI 可发起 GET/POST 请求获取网页内容或 API 响应，是所有 MCP 中成本最低、最通用的联网方案。 |
| **适用场景** | API 调用、网页内容抓取、Webhook 触发 |
| **配置** | `"command": "npx", "args": ["-y", "mcp-server-fetch@latest"]` |

### context7 最新文档实时查询 🔥

| 字段 | 值 |
|------|---|
| **仓库** | [upstash/context7](https://github.com/upstash/context7) |
| **包名** | `@upstash/context7-mcp` |
| **启动方式** | `npx -y @upstash/context7-mcp@latest` |
| **类型** | stdio |
| **核心能力** | Upstash 出品，实时查询各类库和框架的**最新版本文档**。解决 AI 训练数据截止导致的 API 知识过时问题。支持 `resolve-library-id` → `query-docs` 两步式文档检索，返回带版本号的权威示例。 |
| **适用场景** | 查询最新 API 用法、框架迁移、版本兼容性确认 |
| **配置** | `"command": "npx", "args": ["-y", "@upstash/context7-mcp@latest"]` |
| **互补技能** | 与 `docs-lookup` 子代理配合使用效果最佳 |

### filesystem 文件系统访问

| 字段 | 值 |
|------|---|
| **仓库** | [modelcontextprotocol/servers](https://github.com/modelcontextprotocol/servers) |
| **包名** | `@modelcontextprotocol/server-filesystem` |
| **启动方式** | `npx -y @modelcontextprotocol/server-filesystem@latest ~/Projects` |
| **类型** | stdio |
| **核心能力** | Anthropic 官方 MCP 服务器，提供受控的文件系统读写能力。支持目录指定（如 `~/Projects`），AI 可在限定范围内进行文件探索、创建、编辑。沙箱式设计确保安全。 |
| **适用场景** | 跨项目文件操作、批量文件处理、文档生成 |
| **配置** | `"args": ["-y", "@modelcontextprotocol/server-filesystem@latest", "~/Projects"]`（路径可自定义） |
| **安全提示** | 通过路径参数限定可访问范围，避免暴露敏感目录 |

### firecrawl 深度网页抓取 🔥

| 字段 | 值 |
|------|---|
| **仓库** | [mendableai/firecrawl](https://github.com/mendableai/firecrawl) |
| **包名** | `firecrawl-mcp` |
| **启动方式** | `npx -y firecrawl-mcp` |
| **类型** | stdio（需环境变量） |
| **核心能力** | 专业级网页抓取 MCP，支持单页抓取、整站爬取、Markdown 格式输出。比 `fetch` 更智能：自动处理 JavaScript 渲染、反爬绕过、内容提取。适合需要结构化网页数据的场景。 |
| **适用场景** | 竞品分析、大规模网页数据采集、文档站点全量抓取 |
| **配置** | 需设置 `FIRECRAWL_API_KEY` 环境变量 |
| **环境变量** | `"FIRECRAWL_API_KEY": "${FIRECRAWL_API_KEY}"` |
| **vs fetch** | `fetch` 是基础 HTTP 请求，`firecrawl` 是智能网页解析（JS 渲染 + 反爬 + 结构化输出） |
| **vs web-access** | `firecrawl` 侧重数据抓取，`web-access` 侧重带登录态的交互式浏览 |

### codegraph 代码图谱索引 🔥🔥

| 字段 | 值 |
|------|---|
| **仓库** | [nicepkg/codegraph](https://github.com/nicepkg/codegraph) |
| **命令** | `codegraph serve --mcp` |
| **类型** | stdio |
| **核心能力** | 代码库语义索引工具，将项目代码构建为可查询的知识图谱。通过 `codegraph_explore` 和 `codegraph_node` 两个 MCP 工具，AI 可一次性获取符号源码、调用链和文件上下文，替代低效的 grep/find 搜索。 |
| **适用场景** | 大型代码库导航、符号引用分析、架构理解 |
| **配置** | `"command": "codegraph", "args": ["serve", "--mcp"]` |
| **使用前提** | 项目根目录需有 `.codegraph/` 索引目录（用户主动执行 `codegraph` 生成） |
| **效率提升** | 一次 `codegraph_explore` 调用 ≈ 多次 grep + Read 的信息量，大幅减少上下文消耗 |

### sequential-thinking 链式推理

| 字段 | 值 |
|------|---|
| **仓库** | [modelcontextprotocol/servers](https://github.com/modelcontextprotocol/servers) |
| **包名** | `@modelcontextprotocol/server-sequential-thinking` |
| **启动方式** | `npx -y @modelcontextprotocol/server-sequential-thinking@latest` |
| **类型** | stdio |
| **核心能力** | Anthropic 官方 MCP 服务器，提供结构化的分步推理能力。AI 将复杂问题拆解为逐步思考链（Thought Chain），每一步可修正前一步结论，支持回溯和分支探索。适合数学证明、逻辑推导、多步决策。 |
| **适用场景** | 复杂问题分析、逻辑推理、决策树探索、数学计算 |

### tavily AI 搜索引擎 🔥

| 字段 | 值 |
|------|---|
| **仓库** | [tavily-ai/tavily-mcp](https://github.com/tavily-ai/tavily-mcp) |
| **类型** | HTTP（远程服务，非 stdio） |
| **URL** | `https://mcp.tavily.com/mcp/?tavilyApiKey=${TAVILY_API_KEY}` |
| **核心能力** | 专为 AI 优化的搜索引擎 MCP，提供精准的搜索结果和网页摘要。比 `fetch` 盲目抓取更高效：先搜索定位 → 再精准获取。返回结构化结果，包含标题、摘要、相关性评分。 |
| **适用场景** | 信息检索、事实核查、竞品调研、技术选型 |
| **配置** | 纯 HTTP 类型，无需本地命令，直接通过 URL 连接 |
| **环境变量** | 需设置 `TAVILY_API_KEY` |
| **vs firecrawl** | `tavily` 是搜索引擎（找信息），`firecrawl` 是爬虫（取内容） |

### mysql MySQL 数据库访问 🔥

| 字段       | 值                                                                         |
| -------- | ------------------------------------------------------------------------- |
| **仓库** | [designcomputer/mysql_mcp_server](https://github.com/designcomputer/mysql_mcp_server) |
| **包名**   | `mysql-mcp-server`（PyPI，可执行入口 `mysql_mcp_server`；PEP 503 归一化，连字符/下划线等价，二者为同一分发） |
| **启动方式** | `uvx --from mysql-mcp-server==0.4.4 mysql_mcp_server`（版本钉住，防上游变更静默影响全员） |
| **类型**   | stdio（需环境变量）                                                              |
| **核心能力** | MySQL 数据库 MCP 服务器：SQL 查询、Schema 探索、数据采样。支持 SSL 模式、SSH 隧道、多数据库模式（省略 `MYSQL_DATABASE` 即启用）、SSE transport、MCP prompts（`explore_database`/`analyze_table`）；标识符白名单防 SQL 注入、日志自动脱敏密码，附 SECURITY.md 最小权限指南 |
| **适用场景** | SQL 查询调试、数据验证、表结构分析、迁移脚本测试                                                |
| **配置**   | `"command": "uvx", "args": ["--from", "mysql-mcp-server==0.4.4", "mysql_mcp_server"]` |
| **关键参数** | `MYSQL_HOST`、`MYSQL_PORT`、`MYSQL_USER`、`MYSQL_PASSWORD`、`MYSQL_DATABASE`（与原 npm 版环境变量名完全兼容） |
| **安全提示** | 数据库账号须只读（`GRANT SELECT`），避免在配置中硬编码密码，使用环境变量引用；`execute_sql` 允许 DML，只读账号是最后防线 |
| **选型依据** | 2026-08 实测：PyPI 月下载 82.7k vs 原 `@benborla29/mcp-server-mysql`（npm）53.4k，迭代活跃（v0.4.4）⚠️ npm 上存在同名包 `mysql-mcp-server`（他人项目 dpflucas），command 必须保持 `uvx`，切勿改为 `npx` |

### postgres PostgreSQL 数据库访问 🔥

| 字段           | 值                                                                                                        |
| ------------ | -------------------------------------------------------------------------------------------------------- |
| **仓库** | [modelcontextprotocol/servers](https://github.com/modelcontextprotocol/servers) |
| **包名**       | `mcp-postgres`                                                                                           |
| **启动方式**     | `npx -y mcp-postgres`                                                                                    |
| **类型**       | stdio（需环境变量）                                                                                             |
| **核心能力**     | PostgreSQL 数据库 MCP 服务器，通过 `DATABASE_URL` 连接串直接接入 PG 实例。支持 SQL 查询、Schema 探索、数据导出。与 mysql MCP 形成关系型数据库全覆盖。 |
| **适用场景**     | PG 查询调试、数据验证、JSONB 字段操作分析、PostGIS 空间查询                                                                   |
| **配置**       | `"command": "npx", "args": ["-y", "mcp-postgres"]`                                                       |
| **关键参数**     | `DATABASE_URL`（PostgreSQL 连接串，格式：`postgresql://user:password@host:port/dbname`）                          |
| **vs mysql** | `mysql` 连接 MySQL 实例，`postgres` 连接 PostgreSQL 实例，两者互补覆盖主流关系型数据库                                           |
| **安全提示**     | 连接串中的特殊字符需 URL 编码（如 `@` → `%40`），生产环境使用只读账号                                                              |

### nacos 配置中心管理

| 字段       | 值                                                                              |
| -------- | ------------------------------------------------------------------------------ |
| **仓库**   | [jeweis/jewei-mcp-nacos](https://github.com/jeweis/jewei-mcp-nacos)                    |
| **命令**   | `uvx jewei-mcp-nacos`                                                          |
| **类型**   | stdio（Python 实现，通过 uvx 运行）                                                     |
| **核心能力** | Nacos 配置中心 MCP 服务器，让 AI 直接读写 Nacos 配置、查看服务注册信息、管理命名空间。支持 Nacos 2.x 协议，可配置读写模式。 |
| **适用场景** | 微服务配置管理、环境变量调整、服务发现查询                                                          |
| **配置**   | 需配置 Nacos 连接信息（Host/Port/Username/Password/Namespace）                          |
| **关键参数** | `NACOS_HOST`、`NACOS_NAMESPACE`、`NACOS_READ_ONLY`（false 可读写）                    |
| **环境示例** | `gis-ibs-nacos.sit.sf-express.com`（SIT 环境）                                     |
| **安全提示** | 生产环境务必设置 `NACOS_READ_ONLY: true`                                               |

### MCP 配置速查

将以下配置添加到 `~/.claude/settings.json` 的 `mcpServers` 字段：

```json
{
  "mcpServers": {
    "chrome-devtools": {
      "command": "npx",
      "args": ["-y", "chrome-devtools-mcp@latest", "--headless"],
      "type": "stdio"
    },
    "fetch": {
      "command": "npx",
      "args": ["-y", "mcp-server-fetch@latest"],
      "type": "stdio"
    },
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp@latest"],
      "type": "stdio"
    },
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "~/Projects"],
      "type": "stdio"
    },
    "firecrawl": {
      "command": "npx",
      "args": ["-y", "firecrawl-mcp"],
      "env": { "FIRECRAWL_API_KEY": "${FIRECRAWL_API_KEY}" }
    },
    "codegraph": {
      "type": "stdio",
      "command": "codegraph",
      "args": ["serve", "--mcp"]
    },
    "sequential-thinking": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-sequential-thinking"],
      "type": "stdio"
    },
    "tavily": {
      "type": "http",
      "url": "https://mcp.tavily.com/mcp/?tavilyApiKey=${TAVILY_API_KEY}"
    },
    "mysql": {
      "type": "stdio",
      "command": "uvx",
      "args": ["--from", "mysql-mcp-server==0.4.4", "mysql_mcp_server"],
      "env": {
        "MYSQL_HOST": "your-mysql-host",
        "MYSQL_PORT": "3306",
        "MYSQL_USER": "your-user",
        "MYSQL_PASSWORD": "your-password",
        "MYSQL_DATABASE": "your-database"
      }
    },
    "postgres": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "mcp-postgres"],
      "env": {
        "DATABASE_URL": "postgresql://user:password@host:port/dbname"
      }
    },
    "nacos": {
      "type": "stdio",
      "command": "uvx",
      "args": ["jewei-mcp-nacos"],
      "env": {
        "NACOS_HOST": "your-nacos-host",
        "NACOS_API_PORT": "8848",
        "NACOS_CONSOLE_PORT": "8080",
        "NACOS_USERNAME": "nacos",
        "NACOS_PASSWORD": "nacos",
        "NACOS_NAMESPACE": "your-namespace",
        "NACOS_VERSION": "2",
        "NACOS_READ_ONLY": "false"
      }
    },
    "rtk": {
      "type": "stdio",
      "command": "rtk",
      "args": ["mcp"]
    }
  }
}
```

> **按需启用**：不必全部配置。推荐最小集：`fetch` + `context7` + `filesystem`（零成本、零 API Key）。按需添加：浏览器自动化加 `chrome-devtools`，深度抓取加 `firecrawl`，代码导航加 `codegraph`，搜索加 `tavily`。

---

## 第十三部分：AI 开发工作流 (AI Development Workflows)

*端到端 AI 辅助开发流程框架，定义从需求到交付的完整协作模式*

### Comet 阶段感知开发工作流 🔥🔥🔥

| 字段 | 值 |
|------|---|
| **来源** | [rpamis/comet](https://github.com/rpamis/comet) |
| **仓库** | [rpamis/comet](https://github.com/rpamis/comet) |
| **核心理念** | 阶段感知的 AI 开发工作流，防止长上下文漂移，确保每个阶段的产物完整性和可追溯性 |
| **五阶段模型** | `open` → `design` → `build` → `verify` → `archive` |
| **核心创新** | **阶段守卫机制**：每个阶段有明确的进入条件和退出守卫，禁止跳阶段（如 `open` 阶段禁止写源代码）；**自洽性校验**：写源代码前必查 `phase` 字段与产物是否自洽（如 `design_doc` 为空却处于 `build` 阶段则判定为非法空跳）；**硬拦截 Hook**：通过 `comet-guard` 脚本实现白名单式硬拦截，防止 AI 绕过阶段约束 |
| **阶段详解** | **open**：创建 proposal/design/tasks 三件套，明确需求和范围，禁止写源代码；**design**：brainstorming 探索、创建 Design Doc，通过 guard 后进入 build；**build**：写源代码和测试，支持多种执行模式（单智能体/子智能体驱动），每个 task 必须验收并提交；**verify**：运行验证脚本（测试/lint/构建），失败则回退到 build 阶段修复；**archive**：生成归档摘要，更新规格文档，清理临时产物 |
| **预设工作流** | **hotfix**：紧急修复，跳过 design 直接 build；**tweak**：小调整，类似 hotfix；若触发升级信号（质变/文件数过多）可升级为 full 工作流 |
| **上下文恢复** | 通过 `comet-state check <name> <phase> --recover` 脚本检测上下文压缩，自动恢复执行状态；支持子智能体驱动开发时的检查点恢复 |
| **Skill 集成** | 每个阶段自动加载对应 Skill：open → `comet-open`；design → `comet-design` + `brainstorming`；build → `comet-build` + `writing-plans` + `executing-plans`；verify → `comet-verify` + `verification-before-completion`；archive → `comet-archive` |
| **状态管理** | 通过 `.comet.yaml` 文件追踪工作流状态（phase/workflow/design_doc 等），禁止手动编辑，必须通过 `comet-state set` 命令更新 |
| **适用场景** | 大型功能开发、跨团队协作、需要严格规格追踪的项目、合规/审计场景 |
| **vs Superpowers** | Comet 侧重**阶段控制和产物完整性**，Superpowers 侧重**智能体编排和技能复用**；Comet 有明确的阶段守卫，Superpowers 更灵活 |

### Superpowers OpenSpec Team Skills 多智能体协作工作流 🔥🔥

| 字段 | 值 |
|------|---|
| **来源** | [SYZ-Coder/superpowers-openspec-team-skills](https://github.com/SYZ-Coder/superpowers-openspec-team-skills) |
| **仓库** | [SYZ-Coder/superpowers-openspec-team-skills](https://github.com/SYZ-Coder/superpowers-openspec-team-skills) |
| **核心理念** | 基于 OpenSpec 规格驱动的多智能体协作开发框架，通过 20+ 专业子智能体分工协作，实现从需求到交付的完整开发生命周期 |
| **OpenSpec 集成** | **规格驱动开发**：所有工作基于 `openspec/specs/` 中的规格文档，确保需求、设计、代码、测试四者对齐；**变更管理**：通过 `openspec changes` 追踪功能变更，支持 proposal → design → tasks 的完整产物链；**归档机制**：开发完成后通过 `openspec archive` 归档变更，更新主规格文档 |
| **20+ 专业子智能体** | **planner**：实现规划，拆解复杂功能为可执行任务；**architect**：系统设计，评估架构决策和技术选型；**tdd-guide**：测试驱动开发，强制 RED → GREEN → REFACTOR 循环；**code-reviewer**：代码审查，检查质量、安全性和可维护性；**security-reviewer**：安全分析，检测 OWASP Top 10 漏洞和密钥泄露；**build-error-resolver**：构建错误修复，分析编译失败和依赖问题；**e2e-runner**：端到端测试，使用 Playwright 验证关键用户流程；**refactor-cleaner**：死代码清理，识别未使用的导入、变量和函数；**doc-updater**：文档更新，生成代码映射和技术文档 |
| **工作流模式** | **openspec-superpowers**（8步）：完整规格 + 设计双保险，适合大型跨团队功能；**superpowers-openspec-execution**（9步）：三段式三明治工作流，先探索 → OpenSpec 固化 → 实现验证 → 归档；**superpowers-feature**（7步）：轻量功能开发，不生成 OpenSpec 产物；**openspec-feature**（5步）：纯 OpenSpec CLI 驱动，不写代码；**superpowers-learning**（5步）：记忆沉淀，更新项目上下文和可复用模式 |
| **核心技能** | **brainstorming**：探索、澄清、方案比较，输出 Design Doc；**using-git-worktrees**：工作树隔离，支持并行开发；**writing-plans**：实现计划编写，拆解为小任务；**executing-plans** / **subagent-driven-development**：计划执行，子智能体按任务分发；**test-driven-development**：TDD 循环；**requesting-code-review**：代码审查请求；**finishing-a-development-branch**：分支提交/PR/清理；**verification-before-completion**：全量验证；**systematic-debugging**：系统性调试 |
| **记忆系统** | 通过 `.superpowers-memory/` 目录持久化项目知识：**PROJECT_CONTEXT.md**：项目背景、技术栈、架构决策；**CURRENT_STATE.md**：当前状态、进行中的工作、下一步计划；**session-journal/**：会话日志，记录关键决策和验证结果；**LEARNING_BACKLOG.md**：可复用模式和经验教训 |
| **适用场景** | 独立功能开发、快速迭代、不需要跨团队追踪的场景（superpowers-feature）；需要严格规格对齐的合规项目（openspec-superpowers）；团队协作开发（superpowers-openspec-execution） |
| **vs Comet** | Superpowers 侧重**智能体分工和技能复用**，更灵活；Comet 侧重**阶段控制和产物完整性**，更严格；Superpowers 有记忆系统，Comet 有阶段守卫 |

---

## 附录 C：Top 10 必装组合（2026-04 更新）

基于验证后的真实活跃度、社区热度和实用价值排序：

| 排名  | 技能                               | 类别  | 理由                                |
| --- | -------------------------------- | --- | --------------------------------- |
| 1   | **ui-ux-pro-max** ⭐63k           | 设计  | Claude 技能中最高星标，设计智慧数据库            |
| 2   | **hyperframes** 🔥 HeyGen 出品      | 视频  | 19 技能三层架构，HTML 原生视频渲染，生产级框架       |
| 3   | **planning-with-files** ⭐11.7k   | 工作流 | Manus 同款上下文工程，解决 AI 重启即忘         |
| 4   | **frontend-design**              | 前端  | Anthropic 官方出品，消除 AI 审美同质化        |
| 5   | **web-access** ⭐3.9k             | 调研  | 国内平台抓取唯一方案，CDP Proxy 方案成熟         |
| 6   | **api-design-principles**        | 后端  | 接口设计规范，wshobson 生态核心              |
| 7   | **sanyuan-skills** ⭐3.1k         | 审查  | 原生 Claude Code 技能，SOLID + 安全 + 性能 |
| 8   | **prd-doc-writer**               | PRD | 中文友好，故事驱动的 PRD 编写                 |
| 9   | **mermaid-diagrams**             | 架构  | 文本转架构图，文档化必备                      |
| 10  | **ppt-master** 🔥                 | 演示  | 多格式 SVG 生成，支持自定义主题和模板             |
