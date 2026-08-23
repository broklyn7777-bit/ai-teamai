# Step 01: 备份当前分支

**执行者**：主Agent
**输入来源**：当前分支状态
**输出目标**：备份分支 `backup-YYYYMMDD-<branch-name>`

## 执行说明

在 rebase 之前**必须**创建备份，这是不可跳过的一步。

```bash
# 获取当前分支名和日期
BRANCH=$(git branch --show-current)
DATE=$(date +%Y%m%d)
BACKUP_NAME="backup-${DATE}-${BRANCH}"

# 创建备份分支
git branch "${BACKUP_NAME}"

# 验证备份创建成功
git branch --list "backup-*"
```

## 输入文件列表

无（从当前 Git 状态读取）

## 输出文件列表

| 产出 | 格式 |
|------|------|
| 备份分支 | Git ref: `refs/heads/backup-YYYYMMDD-<branch>` |

## 验证检查点

- [ ] 备份分支已创建：`git rev-parse backup-YYYYMMDD-<branch>` 有输出
- [ ] 备份分支指向当前 HEAD：`git rev-parse backup-YYYYMMDD-<branch>` 等于 `git rev-parse HEAD`

## 恢复命令（备用）

如果后续步骤失败，使用以下命令恢复：

```bash
git checkout <original-branch>
git reset --hard backup-YYYYMMDD-<branch>
```

## 下一步

完成备份后，进入 **Step 02: 添加远程并 Fetch**。
