---
paths:
  - "**/*.py"
  - "**/*.pyi"
---

# Python 钩子

> 本文档扩展了 [common/hooks.md](../common/hooks.md) 中关于 Python 的特定内容。

## PostToolUse 钩子

在 `~/.claude/settings.json` 中配置：

* **ruff**：编辑后自动格式化 `.py` 文件并优化 import
* **pyright**：编辑 `.py` 文件后运行类型检查

## 警告

* 对编辑文件中的 `print()` 语句发出警告（应使用 `loguru` 的 `logger` 替代）
* 对源码中 `os.getenv()` 直接读取配置发出警告（应使用 `pydantic-settings`）
