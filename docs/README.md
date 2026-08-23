# docs — 团队文档索引

> 本目录随 `teamai pull` 同步到成员本机（`sharing.docs.localDir`，默认 `~/.teamai/docs`）。
> 文档按三类组织，新增文档请放入对应子目录。

## team/ — 团队体系与流程

描述本团队 AI 辅助开发体系本身的文档：架构、工作流、资源索引。**新成员建议按顺序通读。**

| 文档 | 内容 | 建议读者 |
|------|------|---------|
| [AI 辅助开发架构全景文档](team/AI%20辅助开发架构全景文档.md) | 总体架构：工作流路由（4 条）→ Superpowers 编排引擎（5 阶段）→ 15 个智能体 → rules/skills/MCP 支撑层；OpenSpec × Superpowers 双引擎协同 | 全员（先读，建立全局认知） |
| [ECC Harness 使用指南](team/ECC%20Harness%20使用指南.md) | ECC harness 使用指南：核心哲学、智能体编排矩阵、强制开发工作流、规则系统、质量与安全标准、hooks 机制 | 全员 |
| [superpowers-workflow](team/superpowers-workflow.md) | 12 个 Superpowers 基础技能 + 4 个工作流的选型表、任务类型→技能序列路由、决策树速查 | 全员（干活前查路由表） |
| [skills-index](team/skills-index.md) | 团队全部 61 个技能的索引，按命名空间分组（spec / uac / springboot / engineering / workflow / superpowers 等） | 全员（按需查技能） |

## guides/ — 工具使用指南

具体工具的使用手册，与团队体系无关的通用知识也可放这里。

| 文档 | 内容 | 适用工具/版本 |
|------|------|--------------|
| [teamai-cli使用说明](guides/teamai-cli使用说明.md) | 本团队 CLI：安装、init 接入、pull/push、hooks/mcp inject、recall、经验沉淀（原新成员指南） | teamai-cli v0.20.0 |
| [OMP开发者使用说明](guides/OMP开发者使用说明.md) | Oh My Pi 终端 AI 编码代理：30+ 工具、Rules/Skills/MCP/子代理/扩展六大机制、LSP/DAP/浏览器集成 | OMP |
| [Zed 编辑器完全指南](guides/Zed%20编辑器完全指南.md) | Zed 编辑器实用手册：快捷键、配置系统、Java/Python 开发配置、任务/调试/Git/AI 功能、从 IntelliJ/VS Code 迁移 | Zed v0.197+ |

## resources/ — 外部资源精选

对外部生态（社区 Skills、MCP、工作流）的调研与精选清单，非团队自产资源。

| 文档 | 内容 | 备注 |
|------|------|------|
| [AI编程武器库](resources/AI编程武器库.md) | 技能包 / MCP / 工作流精选清单（2026 版）：覆盖后端、前端、文档、安全、创意设计、端到端编排，全部条目经仓库验证并标注星级与兼容性 | 引用外部仓库前先核对文中"更新时间" |

## 归类约定

- 写**本团队体系**（架构、流程、规范、索引）→ `team/`
- 写**某个工具怎么用**（编辑器、CLI、代理）→ `guides/`
- 写**外部资源调研/清单**（非本仓库资产）→ `resources/`
- 提交前同步更新本索引表与根 `README.md` 的 `docs/` 树
