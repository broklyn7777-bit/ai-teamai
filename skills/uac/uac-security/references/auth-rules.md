# 接口鉴权与权限控制

## 一、强制基础规范

1. **接口鉴权强制**：所有业务接口必须权限控制，禁止匿名访问业务接口（登录接口、健康检查、公网开放接口除外）
2. **权限标识规范**：统一使用 `@PreAuthorize("@per.hasPermission('xxx:xxx:xxx')")` 注解，权限标识遵循 **业务域:模块:操作** 格式（如 `system:user:add`、`org:dept:delete`），见名知意，禁止重复乱定义
3. **敏感操作防护**：增删改、批量导出、核心配置修改等敏感接口需额外做数据归属校验，防止越权操作

## 二、Token 认证配置

```yaml
orion:
  security:
    # 放开登录用户的token信息详细校验，但仍校验token有效性
    # 适用于需要token但不做权限校验的接口（如外部用户接口）
    userTokenCheckPath: /system/user/registerExternalUser

    # 完全放开所有检查（包括token有效性）
    # 仅限于健康检查、服务发现等不需要任何认证的公网接口
    ignorePath: /bdus/distribution,/health
```

| 配置项 | 说明 | 使用场景 |
|--------|------|---------|
| `userTokenCheckPath` | 放开token详细校验，仅校验token有效性 | 外部用户接口、跨域请求 |
| `ignorePath` | 完全放开所有校验（包括token） | 健康检查、公网开放接口 |
| 无配置 | 严格鉴权，校验token+权限 | 普通业务接口（默认） |

配置类：`com.sf.gis.orion.security.common.properties.SecurityProperties`

## 三、SecurityUtils 方法速查表

| 方法 | 返回值 | 说明 | 应用场景 |
|------|--------|------|---------|
| `getLoginAuthDto()` | UserTokenDto | 基础用户信息（token对应） | Token验证、用户名展示 |
| `getLoginAuthInfo()` | UserAuthInfo | 完整用户信息（含权限、租户） | 权限校验、数据隔离 |
| `hasPermission(perm)` | boolean | 检查权限 | **禁止使用**，改用 `@PreAuthorize` |
| `getUserName()` | String | 当前用户名 | 日志记录、操作审计 |
| `getTenantId()` | Long | 当前租户ID | 多租户数据隔离 |
| `getClientId()` | String | 当前应用ID | 多应用数据隔离 |
| `getUserTenantIds()` | Set<Long> | 用户所有租户ID | 跨租户权限校验 |
| `getHighDataScope()` | Integer | 用户最高数据权限范围 | 数据范围隔离 |
| `getHighRoleLevel()` | Integer | 用户最高角色等级 | 角色权限隔离 |

## 四、标准示例

### 4.1 权限注解标准

```java
@PostMapping("/add")
@PreAuthorize("@per.hasPermission('system:user:add')")
public RestResponse<?> addUser(@RequestBody UserDTO userDTO) {
    return userService.addUser(userDTO) ?
        RestResponse.ok() :
        RestResponse.error(BaseExceptionEnum.UPDATE_DATABASE_ERROR, "新增用户失败");
}
```

### 4.2 数据隔离示例

```java
@GetMapping("/orders")
@PreAuthorize("@per.hasPermission('system:order:query')")
public RestResponse<List<OrderVO>> getUserOrders() {
    Long tenantId = SecurityUtils.getTenantId();
    String userName = SecurityUtils.getUserName();
    // 确保查询结果与当前用户/租户隔离
    List<OrderVO> orders = userService.queryOrdersByTenantAndUser(tenantId, userName);
    return RestResponse.ok(orders);
}
```

### 4.3 敏感操作防护（数据归属校验）

```java
@DeleteMapping("/{userId}")
@PreAuthorize("@per.hasPermission('system:user:delete')")
public RestResponse<?> deleteUser(@PathVariable Long userId) {
    Long currentTenantId = SecurityUtils.getTenantId();
    // 额外校验：被删除的用户必须属于当前租户
    UserEntity user = userService.getById(userId);
    if (user == null || !user.getTenantId().equals(currentTenantId)) {
        return RestResponse.error(BaseExceptionEnum.FORBIDDEN, "无权限删除此用户");
    }
    return userService.deleteUser(userId) ?
        RestResponse.ok() :
        RestResponse.error(BaseExceptionEnum.UPDATE_DATABASE_ERROR, "删除失败");
}
```

### 4.4 获取用户信息（必须做 null 校验）

```java
@GetMapping("/detail")
public RestResponse<UserDetailVO> getCurrentUserDetail() {
    UserAuthInfo userAuthInfo = SecurityUtils.getLoginAuthInfo();
    if (userAuthInfo == null) {
        return RestResponse.error(BaseExceptionEnum.UNAUTHORIZED);
    }
    // 安全使用
    Long tenantId = SecurityUtils.getTenantId();
    String userName = SecurityUtils.getUserName();
    // ...
}
```
