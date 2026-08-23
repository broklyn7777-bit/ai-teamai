# Step 06: 验证结果

**执行者**：主Agent
**输入来源**：rebase 后的提交历史
**输出目标**：验证报告

## 执行说明

**铁律：验证必须通过。** 三项验证全部通过才算成功。

### 6.1 验证历史结构

```bash
# 查看最新的提交历史
git log --oneline -15

# 确认结构正确：
# 1. 最新的提交应该是本地定制提交（不是 upstream 的）
# 2. 历史中应该能看到 upstream/main 的提交
# 3. 提交数量应该 = upstream 提交数 + 本地定制提交数
```

### 6.2 验证本地改动完整性

```bash
# 查看相对于 upstream/main 的差异
git diff --stat upstream/main..HEAD

# 确认本地定制的文件仍然存在
# 对比 Step 03 的差异规模，确认文件数量一致

# 查看具体的本地提交
git log --oneline upstream/main..HEAD
```

### 6.3 验证工作区状态

```bash
# 确认工作区干净
git status

# 确认无 rebase 残留
ls .git/rebase-apply/ 2>/dev/null && echo "警告：有 rebase 残留"
ls .git/rebase-merge/ 2>/dev/null && echo "警告：有 rebase 残留"
```

### 6.4 五层验证（完整检查）

| 层级 | 验证内容 | 命令 | 通过条件 |
|------|---------|------|---------|
| L1 | 文件存在 | `git status` | 无冲突文件 |
| L2 | 格式正确 | `git log --oneline -5` | 提交历史可读 |
| L3 | 字段完整 | `git diff --stat upstream/main..HEAD \| grep "files changed"` | 文件数量 > 0 |
| L4 | 值范围有效 | `git log --oneline upstream/main..HEAD \| wc -l` | 等于预期定制提交数 |
| L5 | 业务逻辑通过 | 项目测试（如有） | 测试通过 |

## 输入文件列表

| 文件 | 来源 | 说明 |
|------|------|------|
| rebase 后的提交历史 | Step 04/05 输出 | 需要验证的状态 |

## 输出文件列表

| 产出 | 格式 | 说明 |
|------|------|------|
| 验证报告 | 文本输出 | 三层验证结果 + 后续建议 |

## 验证报告模板

```
=== Rebase 验证报告 ===

✅ 历史结构验证：通过
   - 最新提交：<commit-hash> - <message>
   - 总提交数：N 个（upstream + M 个本地定制）

✅ 本地改动验证：通过
   - 变更文件数：X 个（与 rebase 前一致）
   - 本地提交数：M 个（与 rebase 前一致）

✅ 工作区验证：通过
   - 状态：clean
   - 无 rebase 残留

=== 后续操作建议 ===

1. 如需推送到远程：
   git push --force-with-lease origin <branch>

2. 后续同步（已有共同历史）：
   git fetch upstream
   git rebase upstream/main

3. 清理备份（确认无误后）：
   git branch -d backup-YYYYMMDD-<branch>
```

## 验证检查点

- [ ] 三层验证全部通过
- [ ] 验证报告已生成
- [ ] 后续操作建议已告知用户

## 完成条件

所有验证通过后，整个跨仓库 rebase 同步流程完成。
