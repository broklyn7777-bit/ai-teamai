---
paths:
  - "**/*.py"
  - "**/*.pyi"
---

# Python 编码风格

> 本文件在 [common/coding-style.md](../common/coding-style.md) 的基础上扩展了 Python 特定的内容。

## 标准

* 遵循 **PEP 8** 规范
* 所有函数签名必须使用 **类型注解**，参数和返回值均需标注
* 敏感字段使用 `SecretStr` 防止日志泄露

## 类型检查

* 使用 **Pyright** 进行静态类型检查（速度快，泛型/协议推断精准）
* 在 `pyproject.toml` 中配置 `[tool.pyright]`，新项目建议 `typeCheckingMode = "strict"`
* 优先使用 Pyright 而非 mypy

## 不可变性

优先使用不可变数据结构：

```python
from dataclasses import dataclass

@dataclass(frozen=True)
class User:
    name: str
    email: str

from typing import NamedTuple

class Point(NamedTuple):
    x: float
    y: float
```

## 格式化工具链

* 使用 **ruff** 统一处理代码格式化与 lint（替代 black + isort + flake8）
* 保存时自动执行 ruff 格式化和 import 优化

## 依赖管理

* 使用 **uv** 管理项目依赖和虚拟环境
* 依赖声明统一在 `pyproject.toml`，锁定文件为 `uv.lock`
* 禁止使用 `requirements.txt`，除非项目有特殊约束
* 添加依赖：`uv add <pkg>`；移除：`uv remove <pkg>`
* 运行命令：`uv run <script>`

## 参考

查看技能：`python-patterns` 以获取全面的 Python 惯用法和模式。
