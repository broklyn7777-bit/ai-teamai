---
name: spring-boot-upgrade-expert
description: 协助开发者完成 Spring Boot 项目的版本升级（2.x→3.x 主版本升级、3.x 次版本升级）。包含依赖兼容性评估、外部配置中心（Nacos/Apollo/Disconf）扫描、Jakarta EE 命名空间迁移、SQL 影响分析及标准化升级方案制定。触发场景：用户提到"升级 Spring Boot"、"Spring Boot 3"、"javax 转 jakarta"、"框架升级"、"版本迁移"、"评估升级难度"、"依赖更新"。
version: 2.0.0
source: real-project-experience
analyzed_commits: 23
references:
  - references/spring-boot-2-to-3.md
  - references/common-breaking-changes.md
---

# Spring Boot 升级专家

专注于 Spring Boot 版本升级的安全、系统性执行。升级是一个高风险操作——依赖不兼容、配置失效、运行时异常是最常见的三种失败模式。

## 铁律

1. **不要跳步**——升级按阶段推进，每个阶段验证通过后再进入下一步
2. **不要猜测兼容性**——遇到不确定的依赖，告知用户"需要确认该库对目标版本的兼容性"
3. **不要在没有备份的情况下修改代码**——提醒用户创建分支或备份
4. **不要跳过验证**——每个阶段结束后运行 `mvn clean compile` 确认编译通过
5. **外部配置中心的配置必须单独处理**——代码扫描无法覆盖 Nacos/Apollo 中的配置

## 何时使用

- 升级 Spring Boot 主版本（2.x → 3.x）或次版本（3.x → 3.y）
- 迁移到 Jakarta EE 命名空间（javax.* → jakarta.*）
- 评估升级对现有依赖、配置、SQL 的影响
- 规划多模块项目的分批升级策略
- 用户想"先看看升级难度"再做决策

## 快速决策树

根据用户的升级目标选择路径：

```
用户要升级到什么？
├─ "升级到 Spring Boot 3" ──→ 走完整升级流程（阶段 0-6）
│   ├─ 从 2.x 升级 ──→ 极高风险，全量执行
│   └─ 从 3.0-3.3 升级 ──→ 中风险，跳过 Jakarta 和 Security 大改
├─ "升级到 3.5.x" ──→ 走完整升级流程，目标版本锁定 3.5.0
├─ "javax 转 jakarta" ──→ 走 Jakarta 迁移专项（阶段 4 细化）
├─ "评估升级难度" ──→ 走阶段 0-2 扫描，输出评估报告
└─ "升级某个依赖" ──→ 走单依赖升级流程（读取 common-breaking-changes.md）
```

## 核心流程

### 阶段 0：确认目标与项目上下文

**1. 确认目标版本**：如果用户未指定，先提问。不同目标版本的破坏性变更差异很大：
   - Spring Boot 3.0：引入 Jakarta EE，最大破坏性变更
   - Spring Boot 3.2：auto-configuration 包结构调整
   - Spring Boot 3.5：当前项目目标版本

**2. 确认 JDK 版本**：Spring Boot 3.x 最低 JDK 17，推荐 JDK 21。双重跳跃（Spring Boot + JDK 同时升级）风险远高于渐进式升级。

**3. 扫描项目结构**：
   ```
   读取根 pom.xml → 识别模块层级 → 确认 BOM 管理模式 → 标记升级顺序
   ```

**4. 确认配置中心**：检测 Nacos/Apollo/Disconf 依赖。如果有，告知用户：
   > "检测到项目使用了外部配置中心。请确认本地配置文件是否完整，或提供配置中心的配置备份路径。"

### 阶段 1：扫描依赖并生成版本矩阵

读取 `pom.xml` 或 `build.gradle`，提取所有版本属性。重点关注：

| 关注项 | 为什么重要 |
|--------|-----------|
| Spring 生态组件 | Security、Data、Cloud 有版本对齐要求 |
| Jakarta 兼容性 | Hibernate 6.x、Validation API 等需确认 |
| 已知不兼容库 | 需要替换方案（如 Springfox → SpringDoc） |
| 传递性旧依赖 | `mvn dependency:tree` 排查残留 |

**当前项目版本矩阵**（已升级后状态，可作为升级目标参考）：

| 组件 | 目标版本 | 风险等级 | 说明 |
|------|---------|---------|------|
| Spring Boot | 3.5.0 | 极高 | 主版本升级 |
| JDK | 21 | 极高 | 8→21 双重跳跃 |
| Spring Cloud | 2025.0.1 | 高 | 需与 Boot 3.5 对齐 |
| Spring Cloud Alibaba | 2025.0.0.0 | 高 | Nacos 等 |
| Spring Security | 6.x | 极高 | 内置于 Boot 3.x |
| Spring Authorization Server | 1.4.2 | 极高 | 替代旧 spring-security-oauth2 |
| MyBatis-Plus | 3.5.15 | 中 | JSqlParser 5.2 API 变更 |
| ShardingSphere | 5.5.3 | 中 | SPI 接口变化 |
| Jackson | 2.18.4 | 中 | 替代 FastJSON |
| HttpClient | 5.4.2 | 高 | 4.x→5.x API 大改 |
| Druid | 1.2.27 | 低 | 连接池 |
| springdoc-openapi | 2.8.9 | 高 | 2.8.4 有兼容性 bug |
| MapStruct | 1.6.3 | 低 | 需 lombok-mapstruct-binding |
| Lombok | 1.18.36 | 低 | 注解处理器 |

### 阶段 2：配置项扫描

**1. 定位所有配置文件**：
   - `application.yml` / `application.properties`
   - profile 配置文件（`application-dev.yml` 等）
   - 外部配置中心（Nacos namespace/group）

**2. 当前项目的 Nacos 配置结构**（参考用）：

   - Namespace: `orion-cloud-boot3`
   - 四环境: dev/sit/uat/prod
   - 运行时加载三个文件：
     1. `{service}-{group}.yml`
     2. `application-{group}.yml`
     3. `{service}-setting-{group}.yml`

**3. 识别需要调整的配置项**：

| 旧配置 | 新配置 | 影响 |
|--------|--------|------|
| `server.context-path` | `server.servlet.context-path` | 全局 |
| `spring.redis.*` | `spring.data.redis.*` | 缓存 |
| `security.oauth2.*` | `spring.security.oauth2.*` | OAuth2 |
| `spring.datasource.url` (旧驱动) | `jdbc:mysql://` (新驱动) | 数据库 |
| `@EnableGlobalMethodSecurity` | `@EnableMethodSecurity` | 方法级权限 |
| `spring.config.import=nacos:` | 格式微调 | Nacos |

### 阶段 3：制定升级方案

**标准升级顺序清单**（已验证有效）：

| # | 任务 | 破坏性 | 说明 |
|---|------|--------|------|
| 1 | 升级 JDK 版本 | 高 | JDK 8→21，验证语言特性兼容性 |
| 2 | 升级 BOM 层 | 中 | 先改 orion-dependencies，再改根 POM |
| 3 | javax→jakarta 迁移 | 高 | ~190 文件，全局替换 + 排除 JDK 标准库 |
| 4 | spring.factories→AutoConfiguration.imports | 中 | 12 个 Starter，路径是 `spring/` 非 `spring-boot/` |
| 5 | OAuth2 架构重构 | 极高 | spring-security-oauth2 → SAS 1.4.2 |
| 6 | HttpClient 4.x→5.x | 高 | 6 个文件，SSL/连接池 API 大改 |
| 7 | Swagger→SpringDoc | 中 | Springfox 不兼容，注解迁移 |
| 8 | FastJSON→Jackson | 中 | 全项目弃用 FastJSON |
| 9 | JSqlParser API 适配 | 高 | SubJoin→ParenthesedFromItem 等 |
| 10 | 调整 application.yml | 中 | 各环境同步更新 |
| 11 | 修改 Java Config 类 | 高 | SecurityFilterChain 等 |
| 12 | 数据库迁移脚本 | 高 | OAuth2 新表创建 + 数据迁移 |
| 13 | 编译验证 | - | `mvn clean compile` |
| 14 | 功能测试 | - | 6 种认证方式逐一验证 |

**在开始任何破坏性修改前（标记"高"或"极高"的任务），提醒用户创建新分支。**

### 阶段 4：代码与 SQL 影响评估

#### 4.1 Java 配置变更清单

| 配置类 | 变更 | 风险 | 迁移样例 |
|--------|------|------|----------|
| `PcAuthorizationServerConfig` | `AuthorizationServerConfigurerAdapter` → 独立 `SecurityFilterChain` Bean | 极高 | 见下方样例 A |
| `PcResourceServerConfig` | 资源服务器配置重构，`@Order` 排序 | 高 | 见下方样例 B |
| `WebSecurityConfigurer` | `WebSecurityConfigurerAdapter` → `SecurityFilterChain` | 极高 | 见下方样例 C |
| `TokenStoreConfig` | `JwtTokenStore` → `JwtDecoder` + `OAuth2TokenGenerator` | 极高 | 见下方样例 D |
| `TokenJwtEnhancer` | `TokenEnhancer` → `OAuth2TokenCustomizer<JwtEncodingContext>` | 高 | 见下方样例 E |
| `DataScopeSqlProcessor` | JSqlParser 5.2 API 适配 | 高 | 见下方样例 F |
| `OAuth2FeignRequestInterceptor` | Feign OAuth2 拦截器重构 | 高 | 见下方样例 G |
| `MyKnife4jConfiguration` | Knife4j 注释排除，springdoc 替代 | 中 | - |

#### 4.2 迁移样例

**样例 A：OAuth2 授权服务器配置重构**

```java
// ❌ 旧写法（Spring Security 5.x）
@Configuration
@EnableAuthorizationServer
public class PcAuthorizationServerConfig extends AuthorizationServerConfigurerAdapter {
    @Override
    public void configure(ClientDetailsServiceConfigurer clients) throws Exception {
        clients.jdbc(dataSource);
    }
    @Override
    public void configure(AuthorizationServerEndpointsConfigurer endpoints) {
        endpoints.tokenStore(tokenStore)
                 .tokenEnhancer(tokenEnhancer)
                 .authenticationManager(authenticationManager);
    }
}

// ✅ 新写法（Spring Security 6.x + SAS）
@Configuration
public class PcAuthorizationServerConfig {
    @Bean
    @Order(1)
    public SecurityFilterChain authorizationServerSecurityFilterChain(HttpSecurity http) throws Exception {
        OAuth2AuthorizationServerConfiguration.applyDefaultSecurity(http);
        return http.formLogin(Customizer.withDefaults()).build();
    }

    @Bean
    public RegisteredClientRepository registeredClientRepository(JdbcTemplate jdbcTemplate) {
        return new JdbcRegisteredClientRepository(jdbcTemplate);
    }

    @Bean
    public OAuth2TokenGenerator<?> tokenGenerator(JwtEncoder jwtEncoder) {
        JwtGenerator jwtGenerator = new JwtGenerator(jwtEncoder);
        jwtGenerator.setJwtCustomizer(tokenCustomizer);
        return new DelegatingOAuth2TokenGenerator(
            jwtGenerator,
            new OAuth2AccessTokenGenerator(),
            new OAuth2RefreshTokenGenerator()
        );
    }
}
```

**样例 B：资源服务器配置重构**

```java
// ❌ 旧写法
@Configuration
@EnableResourceServer
public class PcResourceServerConfig extends ResourceServerConfigurerAdapter {
    @Override
    public void configure(ResourceServerSecurityConfigurer resources) {
        resources.tokenStore(tokenStore);
    }
}

// ✅ 新写法
@Configuration
public class PcResourceServerConfig {
    @Bean
    @Order(2)
    public SecurityFilterChain resourceServerSecurityFilterChain(HttpSecurity http) throws Exception {
        http.securityMatcher("/api/**")
            .oauth2ResourceServer(oauth2 -> oauth2.jwt(Customizer.withDefaults()))
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/api/public/**").permitAll()
                .anyRequest().authenticated()
            );
        return http.build();
    }

    @Bean
    public JwtDecoder jwtDecoder(JWKSource<SecurityContext> jwkSource) {
        return OAuth2AuthorizationServerConfiguration.jwtDecoder(jwkSource);
    }
}
```

**样例 C：WebSecurityConfigurerAdapter 迁移**

```java
// ❌ 旧写法
@Configuration
public class WebSecurityConfigurer extends WebSecurityConfigurerAdapter {
    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http.csrf().disable()
            .authorizeRequests()
            .antMatchers("/public/**").permitAll()
            .anyRequest().authenticated()
            .and().formLogin();
    }
}

// ✅ 新写法
@Configuration
public class WebSecurityConfig {
    @Bean
    @Order(3)
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http.csrf(csrf -> csrf.disable())
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/public/**").permitAll()
                .anyRequest().authenticated()
            )
            .formLogin(Customizer.withDefaults());
        return http.build();
    }
}
```

**样例 D：Token 生成器迁移**

```java
// ❌ 旧写法：TokenEnhancer
public class TokenJwtEnhancer implements TokenEnhancer {
    @Override
    public OAuth2AccessToken enhance(OAuth2AccessToken accessToken, OAuth2Authentication authentication) {
        // 添加自定义 claim
        Map<String, Object> additionalInfo = new HashMap<>();
        additionalInfo.put("userId", authentication.getUserAuthentication().getName());
        ((DefaultOAuth2AccessToken) accessToken).setAdditionalInformation(additionalInfo);
        return accessToken;
    }
}

// ✅ 新写法：OAuth2TokenCustomizer
@Bean
public OAuth2TokenCustomizer<JwtEncodingContext> jwtTokenCustomizer() {
    return context -> {
        if (context.getTokenType() == OAuth2TokenType.ACCESS_TOKEN) {
            context.getClaims().claims(claims -> {
                claims.put("userId", context.getPrincipal().getName());
            });
        }
    };
}
```

**样例 E：SecurityFilterChain @Order 排序规则**

```
Order 值越小，优先级越高。多个 SecurityFilterChain 的排序：

Order 1: OAuth2 授权服务器 FilterChain（处理 /oauth2/* 端点）
Order 2: 资源服务器 FilterChain（处理 /api/** 业务接口）
Order 3: 表单登录 FilterChain（处理 /auth/* 认证接口）
Order N: 兜底 FilterChain（处理其他请求）

⚠️ 排序错误会导致请求匹配到错误的 FilterChain，返回 401 或 403
```

**样例 F：JSqlParser 5.2 API 迁移**

```java
// ❌ 旧 API（JSqlParser 4.2）
if (fromItem instanceof SubJoin) {
    SubJoin subJoin = (SubJoin) fromItem;
    // 处理带括号的 JOIN
}
ItemsList rightItems = inExpression.getRightItemsList();
if (itemsList instanceof ValuesList) { ... }

// ✅ 新 API（JSqlParser 5.2）
if (fromItem instanceof ParenthesedFromItem) {
    ParenthesedFromItem parenthesed = (ParenthesedFromItem) fromItem;
    FromItem innerFrom = parenthesed.getFromItem();
    List<Join> joins = parenthesed.getJoins();
}
Expression rightExpr = inExpression.getRightExpression();
if (itemsList instanceof Values) { ... }

// ExpressionList 括号场景
if (expr instanceof ParenthesedExpressionList) { ... }  // 替代部分 ExpressionList 用法
```

**样例 G：HttpClient 4.x → 5.x 迁移**

```java
// ❌ HttpClient 4
CloseableHttpClient httpClient = HttpClients.custom()
    .setSSLContext(sslContext)
    .setSSLHostnameVerifier(hostnameVerifier)
    .setMaxConnTotal(maxTotal)
    .setMaxConnPerRoute(maxPerRoute)
    .build();

// ✅ HttpClient 5
PoolingHttpClientConnectionManager connManager = PoolingHttpClientConnectionManagerBuilder.create()
    .setSSLSocketFactory(new SSLConnectionSocketFactory(sslContext, hostnameVerifier))
    .setMaxConnTotal(maxTotal)
    .setMaxConnPerRoute(maxPerRoute)
    .build();
CloseableHttpClient httpClient = HttpClients.custom()
    .setConnectionManager(connManager)
    .build();
```

#### 4.3 SQL 影响评估

**OAuth2 新表创建**（必须在部署前执行）：

| 新表 | 替代旧表 | 说明 |
|------|---------|------|
| `oauth2_registered_client` | `oauth_client_details` | 客户端注册信息 |
| `oauth2_authorization` | `oauth_access_token`, `oauth_refresh_token` | 授权数据 |
| `oauth2_authorization_consent` | `oauth_approvals` | 用户授权同意 |

**数据迁移脚本要点**：
- `oauth_client_details` → `oauth2_registered_client`：`client_id` 映射、`client_secret` 需 BCrypt 加密
- `client_settings` 和 `token_settings` 为 JSON 格式，需手动构造
- 旧表保留不删除（回滚用途）

#### 4.4 端点路径变更

| 旧端点 | 新端点 | 影响范围 |
|--------|--------|----------|
| `/oauth/token` | `/oauth2/token` | 前端、网关、下游系统 |
| `/oauth/authorize` | `/oauth2/authorize` | 前端 |
| `/oauth/check_token` | `/oauth2/introspect`（需自定义实现） | 资源服务器 |
| `/oauth/token_key` | `/oauth2/jwks` | 所有 JWT 验证方 |
| `/oauth/confirm_access` | 不再需要 | 授权同意页 |

### 阶段 5：分批升级策略

**框架层先行，业务层跟随**：

```
升级顺序：
1. orion-dependencies (BOM 层)
2. orion-common/* (通用模块)
3. orion-db
4. orion-security/*
5. orion-starters/*
6. orion-support/*
7. orioncloud-parent/* (业务层父模块)
8. orioncloud-provider-uac (业务层应用)

每步完成后执行: mvn clean compile
```

### 阶段 6：复杂调试流程

#### 6.1 OAuth2 Token 端点调试（最常见卡点）

**完整 Filter Chain**：

```
POST /oauth2/token
    │
    ▼
Step 1: OAuth2ClientAuthenticationFilter
    ├── 从请求中提取 client_id / client_secret
    ├── authenticationManager.authenticate()
    │   └─→ OAuth2ClientCredentialsAuthenticationProvider
    ├── 查询 oauth2_registered_client 表验证客户端
    └── 认证通过 → 存入 SecurityContext
    │
    ▼
Step 2: OAuth2TokenEndpointFilter
    ├── 从 SecurityContext 取出已认证客户端
    ├── 解析 grant_type
    ├── 构建对应 AuthenticationToken
    ├── authenticationManager.authenticate()
    ├── tokenGenerator.generate() ← 最常见卡点
    └── 返回 token JSON
```

**各步骤排查要点**：

| 步骤 | 常见失败原因 | 排查方法 |
|------|-------------|---------|
| 客户端凭据提取 | 未携带 `client_id`/`client_secret` | 检查 Basic Auth Header |
| 客户端认证 | `oauth2_registered_client` 表中无记录 | 查询数据库确认 |
| client_secret 验证 | 加密方式不匹配 | 确认 DB 中为 BCrypt 格式 |
| grant_type 解析 | 不支持的 grant_type | 确认请求 body 中值正确 |
| **Token 生成** | **JwtGenerator 未注册 / JWK 缺失 / Customizer 报错** | 检查 `@Bean OAuth2TokenGenerator<?>` 注册 |

**Token 生成失败的根因排查顺序**：
1. `JwtGenerator` 未注册 → 确认 `SecurityConfig` 中配置了 `OAuth2TokenGenerator<?>` Bean
2. JWK 密钥对缺失 → 确认 `@Bean JWKSource<SecurityContext>` 已注册
3. `OAuth2TokenCustomizer` 异常 → 自定义 Token 增强器内部逻辑报错
4. `RegisteredClient` 配置不完整 → 确认 `token_settings` JSON 字段包含正确的 TTL

**调试日志配置**：
```yaml
logging:
  level:
    org.springframework.security: DEBUG
    org.springframework.security.oauth2: DEBUG
    org.springframework.security.oauth2.server.authorization: DEBUG
```

#### 6.2 SecurityFilterChain 匹配问题

**现象**：请求返回 401 或 403，但配置看起来正确。

**排查步骤**：
1. 检查 `@Order` 排序是否正确（授权服务器 1 < 资源服务器 2 < 其他 3）
2. 检查 `securityMatcher()` 范围是否有重叠或遗漏
3. 开启 `logging.level.org.springframework.security=TRACE`
4. 确认请求路径没有被更高优先级的 FilterChain 拦截

#### 6.3 Jakarta 命名空间遗漏

**现象**：运行时 `ClassNotFoundException: javax.servlet.Filter` 或校验注解不生效。

**排查命令**：
```bash
# 搜索 javax 残留（排除 JDK 标准库）
grep -r "import javax\." --include="*.java" | grep -v "javax.crypto\|javax.net\|javax.sql\|javax.management\|javax.xml\|javax.swing\|javax.imageio\|javax.security"
```

#### 6.4 spring.factories 迁移路径错误

**现象**：自定义 Starter 的自动配置不生效。

**常见错误**：路径写成 `META-INF/spring-boot/org.springframework.boot.autoconfigure.AutoConfiguration.imports`

**正确路径**：`META-INF/spring/org.springframework.boot.autoconfigure.AutoConfiguration.imports`（注意是 `spring/` 不是 `spring-boot/`）

### 阶段 7：验证清单

升级完成后，逐项确认：

#### 7.1 编译与构建

- [ ] JDK 21 环境验证（`java -version`）
- [ ] `mvn clean compile` 全项目编译通过
- [ ] `maven-compiler-plugin` 配置 `<parameters>true</parameters>`
- [ ] Annotation Processor 配置: MapStruct + Lombok + lombok-mapstruct-binding
- [ ] 确认无 `javax.servlet/validation/annotation` 残留（`javax.crypto/net/sql` 除外）
- [ ] 确认无 `spring-security-oauth2` 旧依赖引用
- [ ] `mvn dependency:tree` 排查传递性旧依赖
- [ ] 确认 Knife4j 依赖已注释排除（如使用 springdoc）
- [ ] Elasticsearch 不兼容模块已排除（如有）

#### 7.2 数据库

- [ ] 执行 OAuth2 新表建表脚本
- [ ] 执行 `oauth_client_details` → `oauth2_registered_client` 数据迁移
- [ ] 旧表保留不删除（回滚用途）
- [ ] 验证 ShardingSphere 分片规则兼容性
- [ ] 验证 MyBatis-Plus mapper 兼容性
- [ ] 验证 JSqlParser 数据权限 SQL 处理（带括号 JOIN、子查询 IN）

#### 7.3 认证功能

- [ ] 表单登录返回 JWT Token
- [ ] 短信验证码登录
- [ ] CAS SSO
- [ ] Code/BUAC 认证
- [ ] OAuth2 授权码流程
- [ ] OAuth2 客户端凭据流程（`client_credentials`）
- [ ] password 密码模式
- [ ] Token 刷新（`refresh_token`）
- [ ] 滑动验证码

#### 7.4 微服务

- [ ] Feign 服务间调用 Token 自动传播
- [ ] `/.well-known/openid-configuration` 端点可访问
- [ ] `/oauth2/jwks` 端点可访问
- [ ] `@EnableMethodSecurity` 方法级权限生效
- [ ] 数据权限插件（`DataScopeSqlProcessor`）兼容性

#### 7.5 配置

- [ ] Nacos 各环境配置同步（dev/sit/uat/prod）
- [ ] JWT 签名密钥环境变量配置
- [ ] Swagger/SpringDoc `tokenUrl` 和 `authorizationUrl` 更新为 `/oauth2/` 路径
- [ ] `security.oauth2.*` → `spring.security.oauth2.*` 前缀迁移
- [ ] 各环境 `bootstrap.yml` 移除确认

### 阶段 8：常见问题 FAQ

| 问题 | 原因 | 解决方案 |
|------|------|----------|
| SpringDoc 2.8.4 启动异常 | 兼容性 bug | 升级至 2.8.9 |
| Knife4j 4.5.0 与 Spring Boot 3.5 不兼容 | 内部依赖冲突 | 注释排除 Knife4j，仅用 springdoc |
| ES 7.8.0 传递 HttpClient 4.x 冲突 | ES 内部绑定旧版本 | 暂时排除 ES 模块，后续升级 ES 8.x Java Client |
| `@Order` 排序混乱导致 401 | FilterChain 匹配顺序错误 | 按 1=授权, 2=资源, 3=登录 排序 |
| Nacos 配置加载失败 | `spring.config.import` 格式变化 | 使用 `nacos:server-addr?group=xxx` 格式 |
| `maven-compiler-plugin skip=true` | CI/CD 编译被跳过 | 生产环境恢复为 `false` |
| JSqlParser `SubJoin` 找不到 | 5.x 已移除该类 | 改用 `ParenthesedFromItem` |
| FastJSON 序列化异常 | 已被 Jackson 替代 | 全项目改用 `JacksonUtil` |
| 旧 JWT Token 验证失败 | 签名密钥变化 | 使用 `oldJwtSigningKey` 兼容旧 token |
| `@EnableGlobalMethodSecurity` 失效 | 已移除 | 改用 `@EnableMethodSecurity` |
| spring.factories 自动配置不生效 | 路径写错 | 正确路径 `META-INF/spring/` 而非 `META-INF/spring-boot/` |
| Druid 连接池配置不生效 | Spring Boot 3 内置 HikariCP | 显式配置 Druid Bean |

### 阶段 9：已知高风险陷阱

| 陷阱 | 影响 | 缓解措施 |
|------|------|----------|
| ES 7.8.0 绑定 HttpClient 4.x | 传递依赖冲突 | 模块注释排除，后续升级 ES 8.x Java Client |
| Spring Social 不兼容 | QQ/微信登录不可用 | 已重写为 OAuth2 Client 模式 |
| CAS API 变化 | CAS SSO 可能中断 | 已适配新版 `spring-security-cas` |
| OAuth2 客户端配置迁移 | 客户端配置可能丢失 | 迁移脚本 + 人工核对 `oauth2_registered_client` 表 |
| 下游系统旧 Token | 服务间调用失败 | JWT 密钥轮换兼容 + 灰度发布 |
| springdoc 2.8.4 兼容性 | Swagger UI 异常 | 已升级至 2.8.9 |
| `security.oauth2.*` 前缀残留 | 配置不生效 | 全局搜索替换为 `spring.security.oauth2.*` |

## 参考文件

- **references/spring-boot-2-to-3.md** — Spring Boot 2.x → 3.x 完整迁移清单
- **references/common-breaking-changes.md** — 各版本（2.7→3.0→3.1→3.2→3.3→3.4）破坏性变更汇总