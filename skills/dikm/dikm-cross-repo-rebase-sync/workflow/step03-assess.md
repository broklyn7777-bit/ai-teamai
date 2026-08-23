# Step 03: 评估差异，识别根提交

**执行者**：主Agent
**输入来源**：`upstream/main` 分支引用
**输出目标**：根提交 hash、差异规模报告

## 执行说明

### 3.1 确认无共同祖先

```bash
# 检查是否有共同祖先
git merge-base HEAD upstream/main
```

- **无输出** → 无共同历史，继续此流程
- **有输出** → 有共同历史，**停止此流程**，改用普通 rebase

### 3.2 识别根提交

```bash
# 方法1：查找最早的提交（适用于单根提交场景）
git log --oneline --reverse | head -5

# 方法2：验证是否为真正的根提交（无父提交）
git cat-file -p <candidate-commit> | grep "^parent"
# 无输出 = 确认是根提交

# 方法3：查找最早的添加文件的提交
git log --oneline --reverse --diff-filter=A -- . | head -1
```

### 3.3 评估差异规模

```bash
# 查看差异统计
git diff --stat HEAD upstream/main | tail -5

# 查看变更文件总数
git diff --stat HEAD upstream/main | grep "files changed"

# 检查核心配置文件差异（高优先级）
git diff --name-only HEAD upstream/main | grep -E "\.env|docker-compose|pyproject|package\.json|requirements"
```

## 输入文件列表

| 文件 | 来源 | 说明 |
|------|------|------|
| upstream/main | Step 02 输出 | 远程分支引用 |

## 输出文件列表

| 产出 | 格式 | 说明 |
|------|------|------|
| 根提交 hash | `<commit-hash>` | 用于 rebase --onto 的起点 |
| 差异规模 | 文本报告 | 文件数、增删行数 |
| 核心配置变更列表 | 文件路径列表 | 需要重点关注的配置 |

## 验证检查点

- [ ] 根提交已识别且验证无父提交
- [ ] 差异规模已评估（文件数、行数）
- [ ] 核心配置变更已识别

## 决策点

根据评估结果决定策略：

| 定制提交数 | 差异规模 | 建议策略 |
|-----------|---------|---------|
| < 5 个 | < 100 文件 | 直接 rebase --onto |
| 5-20 个 | 100-500 文件 | rebase --onto，准备处理冲突 |
| > 20 个 | > 500 文件 | 考虑 cherry-pick 或手动合并 |

## 下一步

评估完成后，进入 **Step 04: 精准 Rebase**。
