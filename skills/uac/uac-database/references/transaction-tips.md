# 声明式事务 快速参考

## 事务配置模板

```yaml
orion:
  transactional:
    enabled: true  # 默认开启，禁止关闭
    # 事务拦截规则：拦截 Service 层的所有方法
    customize-transaction-expressions: execution(* com..*.service.*Service.*(..))
    # 只读事务匹配规则：以 exist、select、query、get 开头的方法
    customize-read-only-method-rule-transaction-attributes: exist*,select*,query*,get*
    # 可传播事务匹配规则：以 pay、do、build 开头的方法走可传播事务
    customize-required-method-rule-transaction-attributes: pay*,do*,build*
```

---

## 方法命名规则速查表

| 方法前缀 | 事务类型 | 是否只读 | 说明 |
|---|---|---|---|
| exist*, select*, query*, get* | 声明式 | 只读 ✅ | 查询方法，自动走只读事务 |
| pay*, do*, build*, save*, insert*, update*, delete* | 声明式 | 可读写 | 写入方法，自动走可传播事务 |
| 其他方法 | 声明式 | 可读写 | 默认可读写 |

---

## 常见错误和解决方案

**错误1** ❌：关闭全局事务开关或自定义事务切面

```yaml
# ⛔ 禁止！
orion:
  transactional:
    enabled: false  # 禁止关闭！
```

**解决**：必须保持框架默认的全局事务开启

```yaml
# ✅ 正确！
orion:
  transactional:
    enabled: true
```

---

**错误2** ❌：同类内部方法调用事务失效

```java
@Service
public class UserService {
    public void saveUser(User user) {
        insertUser(user);  // ❌ 内部方法调用，事务注解失效
    }

    public void insertUser(User user) {
        // ... 此方法的事务不会生效
    }
}
```

**解决**：同类内部调用必须注入自身并通过代理调用

```java
@Service
public class UserService {
    @Resource
    private UserService userService;  // 注入自身

    public void saveUser(User user) {
        userService.insertUser(user);  // ✅ 通过代理调用，事务生效
    }

    public void insertUser(User user) {
        // ... 事务正常生效
    }
}
```

---

## 事务失效排查清单

- [ ] 方法是否是 public？（private/protected 方法事务不生效）
- [ ] 是否在同类内部调用？（改用注入自身 + 代理调用）
- [ ] 是否捕获了异常但没有抛出？（异常捕获导致事务不回滚）
- [ ] 是否调用了非 transactional 的方法？（内部调用的方法也要遵循命名规则）
- [ ] 是否禁用了全局事务开关？（检查配置，enabled 必须为 true）
