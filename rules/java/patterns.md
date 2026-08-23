---
paths:
  - "**/*.java"
---

# Java 模式

> 本文档扩展了 [common/patterns.md](../common/patterns.md) 中的内容，增加了 Java 特有的模式。项目级架构模式详见 Skill `uac-project-architecture`。

## 仓储模式

将数据访问封装在接口之后，具体实现处理存储细节（JPA、JDBC、MyBatis 等）：

```java
public interface OrderRepository {
    Optional<Order> findById(Long id);
    List<Order> findAll();
    Order save(Order order);
    void deleteById(Long id);
}
```

## 构造函数注入

始终使用构造函数注入 —— 绝不使用字段注入。项目使用 `private final` 配合 `@RequiredArgsConstructor`。

## 服务层与分层

- 业务逻辑放在 Service 类中
- Controller 只做参数校验和调用 Service
- 禁止跨层直接访问

具体分层铁律、Entity 基类、DTO 映射等规范参见 Skill `uac-project-architecture`。

### API 响应格式
本项目使用 `RestResponse<T>` 作为统一返回体。具体实现见 Skill `uac-api-design` 和 `uac-project-architecture`。