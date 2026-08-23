# 多租户隔离 快速入门

## 5 步快速配置

### 第 1 步：开启全局开关

```yaml
orion:
  tenant:
    enabled: true  # SaaS 项目强制开启，非 SaaS 项目保持关闭
```

### 第 2 步：实现 TenantHelper（继承框架类）

```java
@Component
public class MyTenantHelper extends TenantHelper {

    public MyTenantHelper() {
        super();
        // 只添加系统基础表，禁止随意添加业务表
        this.addIgnoreTenantTables("sys_user");
        this.addIgnoreTenantTables("sys_role");
        this.addIgnoreTenantTables("sys_menu");
        this.addIgnoreTenantTables("sys_permission");
        this.addIgnoreTenantTables("sys_file");
    }

    @Override
    public StringValue getTenantId() {
        Long tenantId = SecurityUtils.getTenantId();
        if (tenantId == null) {
            throw new BusinessException("当前请求无有效租户信息，禁止访问");
        }
        return new StringValue(tenantId.toString());
    }
}
```

### 第 3 步：业务表添加 tenant_id 字段

每张业务表都必须包含 `tenant_id` 字段：

```sql
ALTER TABLE biz_order ADD COLUMN tenant_id BIGINT NOT NULL DEFAULT 0;
CREATE INDEX idx_tenant_id ON biz_order(tenant_id);
```

### 第 4 步：Mapper 方法级忽略租户拦截（仅系统表）

```java
@Mapper
public interface SysUserMapper extends BaseMapper<SysUser> {

    // 全局查询用户，忽略租户拦截
    // 仅超级管理员、系统初始化场景使用
    @InterceptorIgnore(tenantLine = "true")
    @Select("SELECT * FROM sys_user WHERE user_name = #{userName}")
    SysUser selectByUserNameGlobal(@Param("userName") String userName);
}
```

### 第 5 步：数据隔离验证

```java
// ✅ 这个查询会自动添加 tenant_id = 当前用户租户ID
List<Order> orders = orderMapper.selectList(null);

// ✅ 跨租户查询会被拦截
// 尝试访问租户 2 的数据时，如果当前用户属于租户 1，会被框架自动过滤
```

---

## 忽略规则清单

| 场景 | 方式 | 说明 |
|---|---|---|
| 系统基础表 | 方法级 @InterceptorIgnore | sys_user、sys_role、sys_permission 等 |
| 全局公共表 | 类级 @InterceptorIgnore | 完全不需要租户隔离的表 |
| 业务表 | 禁止忽略 | 所有业务表都必须走租户拦截 |

**原则**：最小化忽略范围，禁止业务表忽略租户拦截。

---

## 常见错误清单

- [ ] ❌ 业务表遗漏 tenant_id 字段
- [ ] ❌ 没有在 TenantHelper 中添加忽略表
- [ ] ❌ 禁止滥用 @InterceptorIgnore(tenantLine = "true")，仅系统表使用
- [ ] ❌ 非 SaaS 项目误开启租户开关
- [ ] ❌ 在 Service 层手动拼接 tenant_id = xxx（应该让框架自动处理）

---

## 验证步骤

```java
// 1. 确保当前用户属于租户 1
Long tenantId = SecurityUtils.getTenantId();  // 应该返回 1

// 2. 插入数据（框架自动填充 tenant_id = 1）
Order order = new Order();
order.setOrderName("Test Order");
orderMapper.insert(order);  // tenant_id 会自动设为 1

// 3. 查询数据（框架自动添加 WHERE tenant_id = 1）
List<Order> orders = orderMapper.selectList(null);
// 实际执行的 SQL：SELECT * FROM biz_order WHERE tenant_id = 1

// 4. 切换租户（模拟租户 2 的用户）
// SecurityUtils 返回租户 ID 2

// 5. 再查询（应该看不到租户 1 的数据）
List<Order> orders2 = orderMapper.selectList(null);
// 实际执行的 SQL：SELECT * FROM biz_order WHERE tenant_id = 2
```
