# Step 04: 精准 Rebase

**执行者**：主Agent
**输入来源**：根提交 hash、upstream/main
**输出目标**：rebase 后的提交历史

## 执行说明

**关键技巧**：跳过根提交，只 rebase 后续的定制提交。根提交包含完整代码库，rebase 它会产生巨量冲突。

### 4.1 执行 Rebase

```bash
# 核心命令：跳过根提交，将后续定制提交变基到 upstream/main 之上
# <root-commit> = Step 03 识别的根提交 hash
# <branch> = 当前分支名
git rebase --onto upstream/main <root-commit> <branch>
```

### 4.2 理解命令语义

```
Before:
  root-commit → commit-A → commit-B → commit-C (HEAD, branch)
  upstream-main → ... → upstream-tip

After:
  upstream-tip → commit-A' → commit-B' → commit-C' (HEAD, branch)
```

- `--onto upstream/main`：目标基底
- `<root-commit>`：**排除**这个提交及其之前的所有内容
- `<branch>`：要 rebase 的分支

### 4.3 检查执行结果

```bash
# 检查 rebase 状态
git status

# 如果显示 "rebase in progress" → 有冲突，跳转到 Step 05
# 如果显示 "nothing to commit, working tree clean" → 成功，继续 Step 06
```

## 输入文件列表

| 文件 | 来源 | 说明 |
|------|------|------|
| 根提交 hash | Step 03 输出 | rebase 起点（排除） |
| upstream/main | Step 02 输出 | 新的基底 |

## 输出文件列表

| 产出 | 格式 | 说明 |
|------|------|------|
| 新的提交历史 | Git commit chain | 定制提交在新基底之上 |
| 新的 commit hash | 多个 | rebase 后 hash 会变化 |

## 验证检查点

- [ ] Rebase 执行完成（无 "rebase in progress"）
- [ ] 工作区干净（`git status` 无冲突文件）
- [ ] 提交数量正确：定制提交数量应与 rebase 前一致

## 中止命令（备用）

如果 rebase 过程中出现问题需要中止：

```bash
git rebase --abort
# 回到 rebase 前的状态，可以从备份恢复
```

## 下一步

- **无冲突** → 进入 **Step 06: 验证结果**
- **有冲突** → 进入 **Step 05: 冲突处理**
