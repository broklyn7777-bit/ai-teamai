# 新成员接入指南

## 1. 安装

```bash
npm install -g teamai-cli        # 需要 Node.js 20+
teamai --version
```

## 2. 初始化

```bash
# 推荐用户级：跨项目共享团队规范
teamai init https://gitee.com/gitciyo/ai-teamai.git --scope user

# 或项目级：只装到当前项目
cd /path/to/your-project
teamai init https://gitee.com/gitciyo/ai-teamai.git
```

初始化时输入你的 git 用户名（如 `01374035`），CLI 会自动注册到 `members/` 并注入 SessionStart hook。

## 3. 验证

```bash
teamai doctor                    # 全部检查应通过
teamai status                    # 查看已同步的资源统计
ls ~/.claude/skills              # 应能看到 backend-service-spec-skill 等团队技能
```

## 4. 日常使用

| 场景 | 命令 |
|------|------|
| 同步最新资源 | `teamai pull`（AI 会话启动时自动执行） |
| 分享新技能/规则 | 写入 `~/.claude/skills/` 或 `~/.claude/rules/` 后 `teamai push` |
| 分享踩坑经验 | AI 会话结束提示后运行 `/teamai-share-learnings`，或 `teamai contribute --file <md>` |
| 检索团队知识 | `teamai recall "关键词"` |
| 排除不需要的技能 | `teamai skill exclude add <skill-name>` |
| 诊断问题 | `teamai doctor` |

## 5. 贡献规范

- **skills**：目录内必须有 `SKILL.md`（YAML frontmatter 含 `name` + `description`），push 时会自动补全缺失字段
- **rules**：Markdown 文件，按 `common/`（通用）或语言目录（`java/` 等）归类
- **learnings**：frontmatter 必须含 `title` / `author` / `date` / `tags`（2-5 个），正文写背景、解决方案、经验总结
- **不要提交**：密钥、内网账号、个人敏感信息

## 6. 常见问题

**Q：pull 之后我本地的某条规则不见了？**
团队仓库是规则的单一事实来源，本地多出的规则文件会被清理。需要保留就先 `teamai push` 入库。

**Q：push 报 MR 创建失败？**
仓库托管在 Gitee，teamai-cli 暂不支持 Gitee MR API。改动已保留在本地团队仓库克隆（`~/.teamai/team-repo`），人工提交推送即可。

**Q：想关掉知识召回提示？**
`teamai recall disable`（只影响本机，不改变团队默认）。
