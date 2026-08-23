# 各版本破坏性变更汇总 + 本项目实战经验

> 按需读取。覆盖 Spring Boot 2.7 → 3.0 → 3.1 → 3.2 → 3.3 → 3.4 → 3.5 的主要破坏点。
> 最后一节为本项目（gis-lbc-ibs-base + gis-lbc-ibs-uac）实战踩坑总结。

## Spring Boot 2.7 → 3.0（最大变更）

### 破坏性等级：极高

| 变更项 | 影响范围 | 说明 | 本项目影响 |
|--------|----------|------|-----------|
| JDK 最低版本 17 | 基础设施 | JDK 11 不再支持 | 本项目直接升到 JDK 21 |
| Jakarta EE 9+ | 全局 | javax → jakarta 全量替换 | ~190 文件受影响 |
| WebSecurityConfigurerAdapter 移除 | 安全 | 所有 Security 配置需重写 | 核心配置类全部重写 |
| spring.factories 机制变更 | 自定义 starter | 自动配置注册方式改变 | 12 个 Starter 迁移 |
| Hibernate 6.x | 数据层 | HQL 语法、Dialect、@Type 变更 | 使用 MyBatis-Plus，影响较小 |
| Springfox 不兼容 | API 文档 | springfox-swagger2 无法使用 | 迁移至 springdoc 2.8.9 |
| OAuth2 旧依赖移除 | 安全 | spring-security-oauth2 停止维护 | 迁移至 SAS 1.4.2 |

## Spring Boot 3.0 → 3.1

### 破坏性等级：低

| 变更项 | 影响范围 | 说明 |
|--------|----------|------|
| 部分废弃 API 移除 | 少量 | 2.x 时代标记 @Deprecated 的 API 被清理 |
| GraphQL 支持调整 | GraphQL 项目 | API 有小幅调整 |

## Spring Boot 3.1 → 3.2

### 破坏性等级：中

| 变更项 | 影响范围 | 说明 |
|--------|----------|------|
| autoconfigure 包结构调整 | 自定义 starter | 部分内部类位置变化 |
| Virtual Threads 实验性支持 | 并发 | 新增功能，不影响现有代码 |
| Spring Authorization Server 调整 | OAuth2 项目 | 部分配置属性变更 |
| 数据库连接池默认行为 | 数据层 | HikariCP 配置有细微调整 |

## Spring Boot 3.2 → 3.3

### 破坏性等级：低

| 变更项 | 影响范围 | 说明 |
|--------|----------|------|
| 部分 Actuator 端点行为 | 监控 | 健康检查探针配置变更 |
| Testcontainers 集成优化 | 测试 | 测试配置可能有调整 |
| Micrometer 观测 API | 指标 | 部分观测 API 有调整 |

## Spring Boot 3.3 → 3.4

### 破坏性等级：低-中

| 变更项 | 影响范围 | 说明 |
|--------|----------|------|
| 废弃 API 清理 | 少量 | 3.2 及之前标记废弃的 API 被移除 |
| AOT 编译支持增强 | 原生镜像 | GraalVM 相关配置有调整 |
| Spring AI 集成 | AI 项目 | 新增模块，不影响现有代码 |

## Spring Boot 3.4 → 3.5（当前项目目标版本）

### 破坏性等级：中

| 变更项 | 影响范围 | 说明 |
|--------|----------|------|
| Spring Cloud 版本对齐 | 微服务 | 需使用 Spring Cloud 2025.0.x |
| Spring Cloud Alibaba 版本对齐 | Nacos 等 | 需使用 2025.0.0.0 |
| HttpClient 5 成为主流 | HTTP 客户端 | 旧 HttpClient 4.x 依赖可能冲突 |
| 部分内部 API 清理 | 少量 | 标记废弃的内部 API 被移除 |

---

## 本项目实战踩坑总结（gis-lbc-ibs-base + gis-lbc-ibs-uac）

> 基于 23 次提交、~560 文件变更的真实经验。

### 坑 1：springdoc 2.8.4 兼容性 bug

- **现象**：Swagger UI 启动异常，端点注册失败
- **根因**：springdoc 2.8.4 与 Spring Boot 3.5 存在兼容性问题
- **解决**：升级至 2.8.9
- **教训**：不要盲目追最新版本，标记为 `#重大问题` 后升级

### 坑 2：Knife4j 4.5.0 与 Spring Boot 3.5 不兼容

- **现象**：启动时 ClassNotFoundException
- **根因**：knife4j-openapi3-jakarta-spring-boot-starter 内部依赖与 Spring Boot 3.5 冲突
- **解决**：注释排除 Knife4j，仅使用 springdoc 原生 UI（`/swagger-ui.html`）
- **教训**：生态兼容性比框架本身更重要，评估传递依赖

### 坑 3：ES 7.8.0 绑定 HttpClient 4.x

- **现象**：`mvn dependency:tree` 发现 HttpClient 4.x 残留
- **根因**：ES 7.8.0 内部依赖 HttpClient 4.x，与 HttpClient 5.x 冲突
- **解决**：暂时注释排除 orion-elasticsearch 模块，后续升级至 ES 8.x Java Client
- **教训**：生态兼容性 > 框架本身兼容性

### 坑 4：OAuth2 端点路径变化影响下游

- **现象**：前端/网关调用 `/oauth/token` 返回 404
- **根因**：SAS 的端点路径为 `/oauth2/token`
- **解决**：前端、网关、下游系统同步适配
- **教训**：路径变化是 API 级别的破坏性变更，需提前通知所有消费方

### 坑 5：spring.factories 迁移路径错误

- **现象**：自定义 Starter 自动配置不生效
- **根因**：路径写成 `META-INF/spring-boot/org.springframework.boot.autoconfigure.AutoConfiguration.imports`
- **正确路径**：`META-INF/spring/org.springframework.boot.autoconfigure.AutoConfiguration.imports`（`spring/` 而非 `spring-boot/`）
- **教训**：路径拼写错误最隐蔽，需仔细核对

### 坑 6：@Order 排序导致 401

- **现象**：某些请求返回 401，但配置看起来正确
- **根因**：SecurityFilterChain 的 `@Order` 排序错误，请求被错误的 FilterChain 拦截
- **正确排序**：授权服务器(1) < 资源服务器(2) < 表单登录(3) < 兜底(N)
- **教训**：多个 FilterChain 时，顺序是决定性的

### 坑 7：Javax 残留导致运行时异常

- **现象**：编译通过，但运行时 `ClassNotFoundException: javax.servlet.Filter`
- **根因**：部分文件未替换为 `jakarta.servlet`
- **排查命令**：
  ```bash
  grep -r "import javax\." --include="*.java" | grep -v "javax.crypto\|javax.net\|javax.sql\|javax.management\|javax.xml\|javax.swing\|javax.imageio\|javax.security"
  ```
- **教训**：全局搜索，不要遗漏

### 坑 8：maven-compiler-plugin skip=true

- **现象**：CI/CD 中编译被跳过
- **根因**：开发环境设置了 `skip=true`，忘记恢复
- **教训**：生产环境必须恢复为 `false`

### 坑 9：FastJSON 替换遗漏

- **现象**：部分 JSON 序列化异常
- **根因**：部分代码仍使用 FastJSON，但依赖已移除
- **解决**：全项目改用 `JacksonUtil`
- **教训**：替换依赖时搜索所有使用点

### 坑 10：Nacos 配置迁移遗漏

- **现象**：某个环境（如 sit）启动失败
- **根因**：只更新了 dev/prod 配置，遗漏 sit/uat
- **教训**：四环境（dev/sit/uat/prod）同步更新

### 版本选择经验

| 决策 | 建议 |
|------|------|
| Spring Boot 版本 | 选次新版本（如 3.5.x 而非 3.0.x），避开早期 bug |
| springdoc 版本 | 2.8.9+，2.8.4 有已知问题 |
| Knife4j | 与 Spring Boot 3.5 不兼容，暂时弃用 |
| JDK 版本 | 直接升到 21（当前 LTS），不要停在 17 |
| MyBatis-Plus | 3.5.15+，包含 JSqlParser 5.x 适配 |
| ShardingSphere | 5.5.3+，SPI 接口稳定 |

## 通用注意事项

1. **次版本升级**（如 3.1 → 3.2）通常安全，破坏性变更较少
2. **主版本升级**（如 2.x → 3.x）需要完整的兼容性评估
3. **Spring Cloud 版本对齐**：Spring Cloud 有独立的版本发布节奏，升级 Spring Boot 后需确认 Spring Cloud 对应版本
4. **第三方依赖**：每次升级后运行 `mvn dependency:tree` 或 `gradle dependencies` 检查是否有不兼容的传递依赖
5. **生态兼容性 > 框架本身兼容性**：ES、MQ 等中间件的客户端版本往往比 Spring Boot 本身更容易出问题
