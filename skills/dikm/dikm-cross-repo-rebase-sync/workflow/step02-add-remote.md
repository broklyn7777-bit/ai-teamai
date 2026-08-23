# Step 02: 添加远程并 Fetch

**执行者**：主Agent
**输入来源**：源仓库的本地路径
**输出目标**：`upstream` 远程引用

## 执行说明

使用本地路径作为远程，避免网络依赖问题。

```bash
# 添加源仓库为 upstream 远程（本地路径）
git remote add upstream /path/to/source/repo

# 或者如果 upstream 已存在，先删除再添加
git remote remove upstream 2>/dev/null
git remote add upstream /path/to/source/repo

# Fetch 所有分支和标签
git fetch upstream

# 验证 fetch 成功
git branch -r | grep upstream
```

## 输入文件列表

| 文件 | 来源 | 说明 |
|------|------|------|
| 源仓库路径 | 用户提供 | 本地绝对路径，如 `/home/user/source-repo` |

## 输出文件列表

| 产出 | 格式 |
|------|------|
| upstream 远程配置 | Git remote: `upstream` |
| upstream/main 分支引用 | `refs/remotes/upstream/main` |
| 所有远程标签 | `refs/tags/*` |

## 验证检查点

- [ ] 远程已添加：`git remote -v | grep upstream` 有输出
- [ ] Fetch 成功：`git branch -r | grep upstream/main` 有输出
- [ ] 无 fetch 错误信息

## 下一步

完成远程添加后，进入 **Step 03: 评估差异，识别根提交**。
