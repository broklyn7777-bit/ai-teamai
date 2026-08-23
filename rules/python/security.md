---
paths:
  - "**/*.py"
  - "**/*.pyi"
---

# Python 安全

> 本文档基于 [通用安全指南](../common/security.md) 扩展，补充了 Python 相关的内容。

## 密钥管理

* **禁止**硬编码敏感信息（API Key、密码、Token）到源码中
* 使用 `pydantic-settings` 管理配置，敏感字段用 `SecretStr` 类型
* 环境变量文件 `.env` 必须加入 `.gitignore`，仅提交 `.env.example` 模板

```python
from pydantic_settings import BaseSettings
from pydantic import SecretStr, Field

class AppSettings(BaseSettings):
    SECRET_KEY: SecretStr = Field(...)
    DB_PASSWORD: SecretStr = Field(...)
```

## 安全扫描

* 使用 **bandit** 进行静态安全分析：
  ```bash
  bandit -r src/
  ```
* 使用 `uv tree` 审查依赖树，排查已知 CVE
* 生产环境禁止 DEBUG 日志级别，防止敏感信息泄露到日志

## 参考

查看技能：`django-security` 以获取 Django 特定的安全指南（如适用）。
