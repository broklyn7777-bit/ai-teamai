---
paths:
  - "**/*.py"
  - "**/*.pyi"
---

# Python 测试

> 本文件在 [通用/测试.md](../common/testing.md) 的基础上扩展了 Python 特定的内容。

## 框架

使用 **pytest** 作为测试框架，异步测试使用 **pytest-asyncio**。

## 覆盖率

```bash
pytest --cov=src --cov-report=term-missing
```

## 测试组织

使用 `pytest.mark` 进行测试分类：

```python
import pytest

@pytest.mark.unit
def test_calculate_total():
    ...

@pytest.mark.integration
def test_database_connection():
    ...
```

## 异步测试

```python
import pytest

@pytest.mark.asyncio
async def test_async_service():
    result = await some_async_function()
    assert result is not None
```

## Mock 与依赖注入

* 使用 `unittest.mock.patch` 模拟外部依赖
* FastAPI 测试使用 `TestClient` 或 `httpx.AsyncClient`
* 避免在单元测试中连接真实数据库或外部服务

## 参考

查看技能：`python-testing` 以获取详细的 pytest 模式和夹具信息。
