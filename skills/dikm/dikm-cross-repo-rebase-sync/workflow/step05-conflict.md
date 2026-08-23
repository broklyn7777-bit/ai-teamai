# Step 05: 冲突处理

**执行者**：主Agent
**输入来源**：冲突文件列表
**输出目标**：解决后的状态

## 执行说明

**铁律：冲突即停，不猜测。** 除非用户明确授权，否则不自动解决冲突。

### 5.1 识别冲突文件

```bash
# 查看所有冲突文件
git status

# 只查看冲突文件列表
git diff --name-only --diff-filter=U
```

### 5.2 报告冲突（必须）

向用户报告以下信息：

```
冲突文件列表（共 N 个）：
- path/to/file1.py
- path/to/file2.js
- ...

冲突类型：
- 内容冲突（双方修改同一行）
- 重命名冲突（一方重命名，另一方修改）
- 添加/修改冲突（一方添加文件，另一方也添加同名文件）

建议处理方式：
- [根据冲突文件类型给出建议]
```

### 5.3 解决冲突（用户授权后）

```bash
# 方式1：手动编辑冲突文件，解决 <<<<<<< 标记
# 编辑文件...
# 标记为已解决
git add <resolved-file>

# 方式2：选择保留某一方
git checkout --ours <file>    # 保留当前分支（定制）
git checkout --theirs <file>  # 保留 upstream（上游）
git add <file>

# 所有冲突解决后，继续 rebase
git rebase --continue
```

### 5.4 冲突无法解决

如果冲突过于复杂或数量过多：

```bash
# 中止 rebase
git rebase --abort

# 从备份恢复
git checkout <original-branch>
git reset --hard backup-YYYYMMDD-<branch>

# 告知用户：建议改用其他策略
# - 改用 git merge --allow-unrelated-histories
# - 或 cherry-pick 关键提交
# - 或手动合并
```

## 输入文件列表

| 文件 | 来源 | 说明 |
|------|------|------|
| 冲突文件列表 | Step 04 执行中产生 | `git diff --diff-filter=U` |

## 输出文件列表

| 产出 | 格式 | 说明 |
|------|------|------|
| 解决后的文件 | 已编辑的文件 | 冲突标记已清除 |
| 继续的 rebase | Git 状态 | `rebase --continue` 成功 |

## 验证检查点

- [ ] 所有冲突文件已解决（`git status` 无冲突）
- [ ] `git rebase --continue` 成功完成
- [ ] 工作区干净

## 下一步

冲突解决后，进入 **Step 06: 验证结果**。
