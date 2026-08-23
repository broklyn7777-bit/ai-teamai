# Spring Boot 2.x → 3.x 完整迁移清单

> 仅当执行主版本升级时读取此文件。
> 基于 Spring Boot 官方迁移指南 + gis-lbc-ibs-base 项目实战经验整理。

## 前置条件

- **JDK 17+**：Spring Boot 3.x 不再支持 JDK 11 及以下（本项目使用 JDK 21）
- **Spring Framework 6.x**：底层自动升级，注意 AOT 和 GraalVM 原生镜像支持是新增能力
- **Maven 3.6.3+**：确保支持最新的 plugin 版本

## 破坏性变更清单

### 1. Jakarta EE 命名空间

所有 `javax.*` 包名替换为 `jakarta.*`：

| 旧包名 | 新包名 | 本项目影响文件数 |
|--------|--------|----------------|
| `javax.servlet.*` | `jakarta.servlet.*` | ~80 文件 |
| `javax.persistence.*` | `jakarta.persistence.*` | ~50 文件 |
| `javax.validation.*` | `jakarta.validation.*` | ~40 文件 |
| `javax.annotation.*` | `jakarta.annotation.*` | ~20 文件 |
| `javax.transaction.*` | `jakarta.transaction.*` | ~5 文件 |
| `javax.mail.*` | `jakarta.mail.*` | ~3 文件 |

**不受影响的**：`javax.xml.*`、`javax.crypto.*`、`javax.net.*`、`javax.sql.*`、`javax.management.*`、`javax.swing.*`、`javax.imageio.*`、`javax.security.*`、`javax.naming.*`

> 自动迁移工具：推荐使用 OpenRewrite 的 `org.openrewrite.java.migrate.jakarta.JavaxMigrationToJakarta` 配方，或 IDE 的全局替换功能。替换后务必检查是否有第三方库不支持 Jakarta 命名空间。

**本项目经验**：使用 IDE 全局替换 + `grep` 验证残留。替换后仍有 3 个文件遗漏导致运行时异常，建议完成后执行：
```bash
grep -r "import javax\." --include="*.java" | grep -v "javax.crypto\|javax.net\|javax.sql\|javax.management\|javax.xml\|javax.swing\|javax.imageio\|javax.security\|javax.naming"
```

### 2. Spring Security

- **`WebSecurityConfigurerAdapter` 已移除**：不再支持继承此类，改用 `@Bean` 方式定义 `SecurityFilterChain`
- **`@EnableWebSecurity` 保持不变**，但配置方式完全改变
- **默认行为变更**：所有请求默认需要认证（移除了 permitAll 的隐式默认）
- **`authorizeRequests()` 废弃**：使用 `authorizeHttpRequests()` 替代
- **`antMatchers()` 废弃**：使用 `requestMatchers()` 替代
- CSRF 保护默认启用，如需关闭需显式配置
- **`@EnableGlobalMethodSecurity` 已移除**：使用 `@EnableMethodSecurity` 替代

**本项目经验**：
- 安全配置从 1 个类拆分为多个 `SecurityFilterChain` Bean
- 使用 `@Order` 控制匹配优先级：授权服务器(1) < 资源服务器(2) < 表单登录(3)
- 排序错误会导致请求匹配到错误的 FilterChain，返回 401 或 403

### 3. OAuth2 架构重构

**旧架构**（已停止维护）：
- `spring-security-oauth2` (2.5.2.RELEASE)
- `@EnableAuthorizationServer`
- `AuthorizationServerConfigurerAdapter`
- `JwtTokenStore` / `TokenEnhancer`
- 端点路径：`/oauth/token`, `/oauth/authorize`

**新架构**：
- `spring-security-oauth2-authorization-server` (1.4.2)
- 独立 `SecurityFilterChain` Bean
- `JwtGenerator` + `OAuth2TokenCustomizer`
- `OAuth2TokenGenerator<?>`
- 端点路径：`/oauth2/token`, `/oauth2/authorize`, `/oauth2/jwks`

**数据库变更**：
| 新表 | 替代旧表 | 说明 |
|------|---------|------|
| `oauth2_registered_client` | `oauth_client_details` | 客户端注册 |
| `oauth2_authorization` | `oauth_access_token`, `oauth_refresh_token` | 授权数据 |
| `oauth2_authorization_consent` | `oauth_approvals` | 用户同意 |

**配置前缀变更**：`security.oauth2.*` → `spring.security.oauth2.*`

### 4. Auto-Configuration

- **`spring.factories` 不再用于自动配置注册**：改用 `META-INF/spring/org.springframework.boot.autoconfigure.AutoConfiguration.imports` 文件
- **注意路径是 `spring/` 而非 `spring-boot/`**：这是最常见的拼写错误
- 自定义 starter 需要迁移注册方式
- 部分 `@ConditionalOnXxx` 条件的行为有细微调整

**本项目经验**：12 个 Starter 模块完成迁移。旧的 `spring.factories` 文件保留为注释占位（未删除），新增 `.imports` 文件。

### 5. 配置属性变更

| 旧配置 | 新配置 | 说明 |
|--------|--------|------|
| `server.context-path` | `server.servlet.context-path` | 上下文路径 |
| `server.error.include-stacktrace` | 默认值变更 | 错误页 |
| `spring.redis.*` | `spring.data.redis.*` | Redis 配置 |
| `spring.neofox.*` | 已移除 | 不再支持 |
| `management.health.defaults.enabled` | `management.endpoint.health.probes.enabled` | 健康探针 |
| `@EnableGlobalMethodSecurity` | `@EnableMethodSecurity` | 方法级权限 |

### 6. Actuator

- 健康端点路径变更：`/actuator/health` 成为标准
- 自定义 HealthIndicator 接口签名有调整
- Prometheus 指标端点默认行为变更
- 新增健康探针：`liveness` 和 `readiness`

### 7. 数据层

- **Hibernate 6.x**：HQL 语法更严格，部分旧语法不再支持
- `spring.jpa.properties.hibernate.*` 部分属性名变更
- 数据库方言（Dialect）类名变更（如 `MySQL5Dialect` → `MySQLDialect`）
- `@Type` 注解的使用方式变化（`@Type(type = "...")` → `@Type(value = XxxType.class)`）

**本项目经验**：使用 MyBatis-Plus 3.5.15 而非 Hibernate，影响较小。但 JSqlParser 从 4.2 升级到 5.2，影响数据权限 SQL 处理器：
- `SubJoin` → `ParenthesedFromItem`
- `InExpression.getRightItemsList()` → `getRightExpression()`
- `ValuesList` → `Values`
- `ExpressionList` → `ParenthesedExpressionList`（括号场景）

### 8. API 文档

- **Springfox (springfox-swagger2) 不再兼容**：必须迁移
- 替代方案：springdoc-openapi-starter-webmvc-ui (2.8.9)
- 注解迁移：`@Api` → `@Tag`, `@ApiOperation` → `@Operation`, `@ApiModelProperty` → `@Schema`
- Knife4j 4.5.0 与 Spring Boot 3.5 不兼容，需注释排除

### 9. HTTP 客户端

- Apache HttpClient 5.x 成为主流，4.x 可能产生传递依赖冲突
- SSL 配置方式变化：`setSSLContext()` → `PoolingHttpClientConnectionManagerBuilder`
- 连接池配置方式变化

### 10. 已移除的模块

- Spring Boot Starter for Jersey 已移除
- 部分旧版数据库驱动不再内置支持
- `spring-boot-starter-data-rest` 的部分行为变更

## 升级步骤（本项目验证有效）

```
1. 确认 JDK >= 17（推荐 21）
2. 更新 Spring Boot 父 POM 版本号
3. 同步更新 Spring Cloud / Spring Cloud Alibaba BOM
4. 运行 openrewrite javax → jakarta 迁移（或 IDE 全局替换）
5. 检查并更新依赖版本（mvn dependency:tree）
6. 迁移 spring.factories → AutoConfiguration.imports
7. 重构 Security 配置（WebSecurityConfigurerAdapter → SecurityFilterChain）
8. 迁移 OAuth2 架构（如使用）
9. 更新配置文件（application.yml）
10. 修复编译错误
11. mvn clean compile 验证
12. 运行测试
13. 检查运行时行为
```

**每步完成后执行 `mvn clean compile`，编译通过后再进入下一步。不要跳步。**
