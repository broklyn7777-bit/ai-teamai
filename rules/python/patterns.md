---
paths:
  - "**/*.py"
  - "**/*.pyi"
---

# Python 模式

> 本文档扩展了 [common/patterns.md](../common/patterns.md)，补充了 Python 特定的内容。

## 项目结构

使用 `src` 布局，源码放在 `src/<package>/` 下，测试放在 `tests/` 下：

```
project/
├── pyproject.toml
├── uv.lock
├── .env.example
├── src/
│   └── my_package/
│       ├── __init__.py      # 定义 __version__、__all__，重导出公共 API
│       ├── core/            # 配置、日志、异常等基础设施
│       ├── services/        # 业务逻辑
│       └── api/             # 接口层（FastAPI 路由等）
└── tests/
    ├── unit/
    └── integration/
```

`src` 布局强制 Python 从安装包路径导入，避免本地开发与打包行为不一致。

## 协议（鸭子类型）

```python
from typing import Protocol

class Repository(Protocol):
    def find_by_id(self, id: str) -> dict | None: ...
    def save(self, entity: dict) -> dict: ...
```

## 数据类作为 DTO

```python
from dataclasses import dataclass

@dataclass
class CreateUserRequest:
    name: str
    email: str
    age: int | None = None
```

## 配置管理

使用 `pydantic-settings` 集中管理配置，禁止硬编码敏感信息：

```python
from pydantic import Field, SecretStr
from pydantic_settings import BaseSettings, SettingsConfigDict

class AppSettings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", case_sensitive=False)

    APP_NAME: str = Field(default="App")
    LOG_LEVEL: str = Field(default="INFO")
    SECRET_KEY: SecretStr = Field(...)  # 必填，无默认值
```

* 敏感字段用 `SecretStr`，日志中自动脱敏
* 提供 `.env.example` 模板提交到 Git，`.env` 加入 `.gitignore`
* 通过 `@model_validator` 校验跨字段一致性（如生产环境禁止 DEBUG 日志）

## 结构化日志

使用 `loguru` 替代 `print()` 和标准库 `logging`：

```python
from loguru import logger

logger.add("app_{time:YYYY-MM-DD}.log",
           rotation="00:00", retention="14 days",
           level="DEBUG", encoding="utf-8", enqueue=True)
```

* 应用启动时统一调用 `setup_logging()` 配置全局日志
* 使用 `contextvars` + 中间件注入 `request_id`，实现调用链追踪
* 生产环境日志级别不低于 INFO

## 上下文管理器与生成器

* 使用上下文管理器（`with` 语句）进行资源管理
* 使用生成器进行惰性求值和内存高效迭代

## 参考

查看技能：`python-patterns`，了解包括装饰器、并发和包组织在内的综合模式。
