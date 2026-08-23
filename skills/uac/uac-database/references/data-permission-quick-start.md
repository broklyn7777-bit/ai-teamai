# 数据权限拦截 快速入门

## 5 步快速配置

### 第 1 步：定义 DataScope（机构维度示例）

```java
@Configuration
public class DataPermissionConfig {

    public static final String RESOURCE_ORG = "org";

    @Bean
    public DataScope orgDataScope() {
        return new DataScope() {
            final String columnId = "org_id";

            @Override
            public String getResource() {
                return RESOURCE_ORG;
            }

            // 定义哪些表需要进行数据权限过滤
            @Override
            public Collection<String> getTableNames() {
                Set<String> tableNames = new TreeSet<>(String.CASE_INSENSITIVE_ORDER);
                tableNames.add("sys_user_org");
                tableNames.add("biz_org_data");
                return tableNames;
            }

            // 构建权限过滤 SQL
            @Override
            public Expression getExpression(String tableName, Alias tableAlias) {
                UserAuthInfo userAuth = SecurityUtils.getLoginAuthInfo();
                if (userAuth == null || userAuth.getAllOrgIds() == null) {
                    throw new BusinessException("当前用户无有效数据权限");
                }

                Set<Long> userOrgIds = userAuth.getAllOrgIds();
                if (userOrgIds.isEmpty()) {
                    userOrgIds.add(-99L);  // 无权限时设置无效值，阻断全表查询
                }

                List<Expression> orgIds = userOrgIds.stream()
                        .map(LongValue::new)
                        .collect(Collectors.toList());

                Column column = new Column(tableAlias == null ? columnId : tableAlias.getName() + "." + columnId);
                ExpressionList expressionList = new ExpressionList();
                expressionList.setExpressions(orgIds);
                return new InExpression(column, expressionList);
            }
        };
    }
}
```

```java
//多条件or查询过滤(... AND (org_id IN ('1') OR pm_id IN ('5')))
@Override
public Expression getExpression(String tableName, Alias tableAlias) {
	String userName = SecurityUtils.getUserName();
	if (StringUtils.isBlank(userName)) {
		throw new BusinessException("用户信息获取失败");
	}

    String orgColumnId = "org_id";
    Column orgColumn = new Column(orgColumnId);

    List<Long> orgIds = Lists.newArrayList();
    orgIds.add(1L);
    List<Expression> orgIdList = orgIds.stream().map(id -> new StringValue(String.valueOf(id)))
            .collect(Collectors.toList());

    ExpressionList orgExpressionList = new ExpressionList();
    orgExpressionList.setExpressions(orgIdList);
    // 条件1: org_id IN ('org1', 'org2', ...)
    Expression orgCondition = new InExpression(orgColumn, orgExpressionList);

    String pmColumnId = "pm_id";
    Column pmColumn = new Column(pmColumnId);

    List<Long> pmIds = Lists.newArrayList();
    pmIds.add(5L);
    List<Expression> pmIdList = pmIds.stream().map(id -> new StringValue(String.valueOf(id)))
            .collect(Collectors.toList());
    // 条件2: pm_id in (5)
    ExpressionList pdExpressionList = new ExpressionList();
    pdExpressionList.setExpressions(pmIdList);
    Expression pmCondition = new InExpression(pmColumn,pdExpressionList);
    Expression orExpression = new OrExpression(orgCondition, pmCondition);
    // 使用 Parenthesis 包裹 OR 表达式，确保生成 (... AND (org_id IN ('1') OR pm_id IN ('5')))
    Expression finalExpression = new Parenthesis(orExpression);
    return finalExpression;
}
```

### 第 2 步：配置权限处理器（管理员豁免）

```java
@Component
public class MyDataPermissionHandler extends DefaultDataPermissionHandler {

    public MyDataPermissionHandler(List<DataScope> dataScopes) {
        super(dataScopes);
    }

    @Override
    public List<DataScope> filterDataScopes(String mappedStatementId) {
        List<DataScope> dataScopes = super.filterDataScopes(mappedStatementId);
        UserAuthInfo userAuth = SecurityUtils.getLoginAuthInfo();

        if (userAuth != null) {
            Integer scope = userAuth.getHighDataScope();
            // 超管/租户管理员不做权限过滤
            if (scope <= SysConstant.Scope.TENANT.getValue()) {
                dataScopes = dataScopes.stream()
                        .filter(x -> !x.getResource().equals(DataPermissionConfig.RESOURCE_ORG))
                        .collect(Collectors.toList());
            }
        }
        return dataScopes;
    }
}
```

### 第 3 步：注册权限处理器

```java
@Bean
public DataPermissionHandler dataPermissionHandler(List<DataScope> dataScopeList) {
    return new MyDataPermissionHandler(dataScopeList);
}
```

### 第 4 步：方法级权限控制

```java
@Mapper
public interface UserOrgMapper extends BaseMapper<UserOrg> {

    // 忽略数据权限：全局查询用户（仅管理员使用）
    @InterceptorIgnore(tenantLine = "true")
    @DataPermission(ignore = true)
    SysUser selectUserGlobal(@Param("userId") Long userId);

    // 指定资源维度过滤：按机构权限过滤
    @DataPermission(resource = DataPermissionConfig.RESOURCE_ORG)
    List<UserOrgVO> queryUserOrgList(@Param("userId") Long userId);
}
```

### 第 5 步：权限验证

```java
// ✅ 这个查询会自动添加 WHERE org_id IN (用户可访问的机构)
List<UserOrgVO> userOrgs = userOrgMapper.queryUserOrgList(userId);

// ✅ 管理员查询不受限制
SysUser user = userOrgMapper.selectUserGlobal(userId);  // 忽略权限过滤
```

---

## 权限豁免规则清单

| 用户类型 | 豁免规则 | 说明 |
|---|---|---|
| 超级管理员 | 豁免所有权限过滤 | scope ≤ TENANT |
| 租户管理员 | 豁免所有权限过滤 | scope ≤ TENANT |
| 应用管理员 | 豁免所有权限过滤 | scope ≤ TENANT |
| 普通用户 | 严格按权限拦截 | 只能访问分配给他的资源 |

---

## 常见错误清单

- [ ] ❌ DataScope 配置逻辑混乱，多资源维度冲突
- [ ] ❌ 普通用户被误设为管理员豁免
- [ ] ❌ 滥用 @DataPermission(ignore = true) 导致数据越权
- [ ] ❌ 手写 SQL 拼接权限条件，绕过框架拦截
- [ ] ❌ 无权限用户返回空结果，而非明确抛出异常

---

## 配置检查清单

- [ ] DataScope 中的 getTableNames() 包含所有需要权限过滤的表
- [ ] 权限处理器中的豁免规则明确（超管、租管判断条件清晰）
- [ ] 业务 Mapper 中的 @DataPermission 注解明确指定 resource
- [ ] 敏感接口（如全局查询）添加了 @DataPermission(ignore = true)
- [ ] 普通接口没有添加 ignore = true（确保权限生效）

