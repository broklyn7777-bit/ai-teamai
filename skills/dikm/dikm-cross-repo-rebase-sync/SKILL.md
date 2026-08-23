---
name: dikm-cross-repo-rebase-sync
description: "跨仓库 Git 同步：处理无共同历史时使用 rebase --onto 安全合并本地定制提交"
user-invocable: true
origin: auto-extracted
---

# 跨仓库 Rebase 同步

**上下文：** 当需要从外部仓库（如上游开源项目）同步代码到本地定制分支，且两个仓库没有共同 Git 历史时。

## 问题

两个独立 Git 仓库需要合并代码，但：
- `git merge` 因无共同祖先失败（或需要 `--allow-unrelated-histories`，结果混乱）
- 本地仓库有少量定制提交叠加在完整的初始代码库之上
- 需要保留本地定制，同时引入上游全部更新

典型场景：fork 开源项目后做了本地定制，需要定期同步上游更新。

## 解决方案

### 第一步：添加本地路径远程并 Fetch

```bash
# 用本地路径作为远程，避免网络依赖
git remote add upstream /path/to/source/repo
git fetch upstream
```

### 第二步：评估差异，识别根提交

```bash
# 确认无共同祖先
git merge-base HEAD upstream/main
# 若无输出 → 无共同历史

# 找到本地根提交（包含完整初始代码库的那个）
git log --oneline --reverse | head -5

# 评估差异规模
git diff --stat HEAD upstream/main | tail -3
```

### 第三步：精准 Rebase（跳过根提交）

关键技巧：根提交包含完整代码库，rebase 它会产生巨量冲突。只 rebase 根提交之后的定制提交：

```bash
# <root-commit> 是包含初始代码库的根提交 hash
# 效果：跳过根提交，将后续 N 个定制提交变基到 upstream/main 之上
git rebase --onto upstream/main <root-commit> <local-branch>
```

### 第四步：验证结果

```bash
# 确认历史结构正确
git log --oneline -10

# 确认本地改动保留完整
git diff --stat upstream/main..HEAD

# 确认工作区干净
git status
```

## 何时使用

- 从外部开源仓库同步代码到本地定制分支
- 两个独立仓库需要合并且无共同历史
- 本地只有少量定制提交需要保留在大量上游代码之上
- 需要定期同步上游更新（rebase 后可重复执行）

## 注意事项

- 如果定制提交数量多且改动大，先备份分支：`git branch backup-$(git branch --show-current)`
- Rebase 成功后，本地 commit hash 会变化，如需推送到远程需用 `--force-with-lease`
- 后续同步：直接 `git fetch upstream && git rebase upstream/main`（此时已有共同历史）
