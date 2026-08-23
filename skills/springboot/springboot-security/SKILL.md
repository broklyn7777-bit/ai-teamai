---
name: springboot-security
description: Spring Boot 服务中的认证/授权、输入校验、CSRF、密钥管理、安全头、限流和依赖安全的最佳实践。
origin: ECC
---

# Spring Boot 安全审查

在添加认证、处理输入、创建端点或处理密钥时使用。

## 何时激活

- 添加认证（JWT、OAuth2、基于会话）
- 实现授权（`@PreAuthorize`、基于角色的访问控制）
- 校验用户输入（Bean Validation、自定义校验器）
- 配置 CORS、CSRF 或安全头
- 管理密钥（Vault、环境变量）
- 添加限流或防暴力破解保护
- 扫描依赖中的 CVE

## 认证

- 优先无状态 JWT 或带吊销列表的不透明令牌
- 会话使用 `httpOnly`、`Secure`、`SameSite=Strict` cookie
- 使用 `OncePerRequestFilter` 或资源服务器校验令牌

```java
@Component
public class JwtAuthFilter extends OncePerRequestFilter {
  private final JwtService jwtService;

  public JwtAuthFilter(JwtService jwtService) {
    this.jwtService = jwtService;
  }

  @Override
  protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response,
      FilterChain chain) throws ServletException, IOException {
    String header = request.getHeader(HttpHeaders.AUTHORIZATION);
    if (header != null && header.startsWith("Bearer ")) {
      String token = header.substring(7);
      Authentication auth = jwtService.authenticate(token);
      SecurityContextHolder.getContext().setAuthentication(auth);
    }
    chain.doFilter(request, response);
  }
}
```

## 授权

- 启用方法安全：`@EnableMethodSecurity`
- 使用 `@PreAuthorize("hasRole('ADMIN')")` 或 `@PreAuthorize("@authz.canEdit(#id)")`
- 默认拒绝；仅暴露必需的权限范围

```java
@RestController
@RequestMapping("/api/admin")
public class AdminController {

  @PreAuthorize("hasRole('ADMIN')")
  @GetMapping("/users")
  public List<UserDto> listUsers() {
    return userService.findAll();
  }

  @PreAuthorize("@authz.isOwner(#id, authentication)")
  @DeleteMapping("/users/{id}")
  public ResponseEntity<Void> deleteUser(@PathVariable Long id) {
    userService.delete(id);
    return ResponseEntity.noContent().build();
  }
}
```

## 输入校验

- 在 controller 上使用 `@Valid` 进行 Bean Validation
- 在 DTO 上应用约束：`@NotBlank`、`@Email`、`@Size`、自定义校验器
- 渲染前使用白名单清洗任何 HTML

```java
// 错误：没有校验
@PostMapping("/users")
public User createUser(@RequestBody UserDto dto) {
  return userService.create(dto);
}

// 正确：带校验的 DTO
public record CreateUserDto(
    @NotBlank @Size(max = 100) String name,
    @NotBlank @Email String email,
    @NotNull @Min(0) @Max(150) Integer age
) {}

@PostMapping("/users")
public ResponseEntity<UserDto> createUser(@Valid @RequestBody CreateUserDto dto) {
  return ResponseEntity.status(HttpStatus.CREATED)
      .body(userService.create(dto));
}
```

## SQL 注入防护

- 使用 Spring Data 仓库或参数化查询
- 对于原生查询，使用 `:param` 绑定；永远不要拼接字符串

```java
// 错误：原生查询中拼接字符串
@Query(value = "SELECT * FROM users WHERE name = '" + name + "'", nativeQuery = true)

// 正确：参数化原生查询
@Query(value = "SELECT * FROM users WHERE name = :name", nativeQuery = true)
List<User> findByName(@Param("name") String name);

// 正确：Spring Data 派生查询（自动参数化）
List<User> findByEmailAndActiveTrue(String email);
```

## 密码编码

- 始终使用 BCrypt 或 Argon2 哈希密码 — 永远不要明文存储
- 使用 `PasswordEncoder` bean，而非手动哈希

```java
@Bean
public PasswordEncoder passwordEncoder() {
  return new BCryptPasswordEncoder(12); // 成本因子 12
}

// 在服务中使用
public User register(CreateUserDto dto) {
  String hashedPassword = passwordEncoder.encode(dto.password());
  return userRepository.save(new User(dto.email(), hashedPassword));
}
```

## CSRF 防护

- 对于浏览器会话应用，保持 CSRF 启用；在表单/头中包含令牌
- 对于使用 Bearer 令牌的纯 API，禁用 CSRF 并依赖无状态认证

```java
http
  .csrf(csrf -> csrf.disable())
  .sessionManagement(sm -> sm.sessionCreationPolicy(SessionCreationPolicy.STATELESS));
```

## 密钥管理

- 源码中不放密钥；从环境变量或 vault 加载
- `application.yml` 中不放凭证；使用占位符
- 定期轮换令牌和数据库凭证

```yaml
# 错误：硬编码在 application.yml 中
spring:
  datasource:
    password: mySecretPassword123

# 正确：环境变量占位符
spring:
  datasource:
    password: ${DB_PASSWORD}

# 正确：Spring Cloud Vault 集成
spring:
  cloud:
    vault:
      uri: https://vault.example.com
      token: ${VAULT_TOKEN}
```

## 安全头

```java
http
  .headers(headers -> headers
    .contentSecurityPolicy(csp -> csp
      .policyDirectives("default-src 'self'"))
    .frameOptions(HeadersConfigurer.FrameOptionsConfig::sameOrigin)
    .xssProtection(Customizer.withDefaults())
    .referrerPolicy(rp -> rp.policy(ReferrerPolicyHeaderWriter.ReferrerPolicy.NO_REFERRER)));
```

## CORS 配置

- 在安全过滤器级别配置 CORS，而非每个 controller
- 限制允许的的来源 — 生产环境永远不要使用 `*`

```java
@Bean
public CorsConfigurationSource corsConfigurationSource() {
  CorsConfiguration config = new CorsConfiguration();
  config.setAllowedOrigins(List.of("https://app.example.com"));
  config.setAllowedMethods(List.of("GET", "POST", "PUT", "DELETE"));
  config.setAllowedHeaders(List.of("Authorization", "Content-Type"));
  config.setAllowCredentials(true);
  config.setMaxAge(3600L);

  UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
  source.registerCorsConfiguration("/api/**", config);
  return source;
}

// 在 SecurityFilterChain 中：
http.cors(cors -> cors.configurationSource(corsConfigurationSource()));
```

## 限流

- 在昂贵端点上应用 Bucket4j 或网关级别限制
- 对突发进行日志记录和告警；返回 429 并重试提示

```java
// 使用 Bucket4j 进行端点级别限流
@Component
public class RateLimitFilter extends OncePerRequestFilter {
  private final Map<String, Bucket> buckets = new ConcurrentHashMap<>();

  private Bucket createBucket() {
    return Bucket.builder()
        .addLimit(Bandwidth.classic(100, Refill.intervally(100, Duration.ofMinutes(1))))
        .build();
  }

  @Override
  protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response,
      FilterChain chain) throws ServletException, IOException {
    String clientIp = request.getRemoteAddr();
    Bucket bucket = buckets.computeIfAbsent(clientIp, k -> createBucket());

    if (bucket.tryConsume(1)) {
      chain.doFilter(request, response);
    } else {
      response.setStatus(HttpStatus.TOO_MANY_REQUESTS.value());
      response.getWriter().write("{\"error\": \"Rate limit exceeded\"}");
    }
  }
}
```

## 依赖安全

- 在 CI 中运行 OWASP Dependency Check / Snyk
- 保持 Spring Boot 和 Spring Security 在受支持版本
- 对已知 CVE 失败构建

## 日志与 PII

- 永远不要记录密钥、令牌、密码或完整 PAN 数据
- 脱敏敏感字段；使用结构化 JSON 日志

## 文件上传

- 校验大小、内容类型和扩展名
- 存储在 Web 根目录之外；需要时进行扫描

## 发布前检查清单

- [ ] 认证令牌已验证且过期策略正确
- [ ] 每个敏感路径都有授权守卫
- [ ] 所有输入已校验和清洗
- [ ] 没有字符串拼接的 SQL
- [ ] CSRF 策略与应用类型匹配
- [ ] 密钥已外部化；没有提交到代码库
- [ ] 安全头已配置
- [ ] API 已限流
- [ ] 依赖已扫描且为最新版本
- [ ] 日志不含敏感数据

**记住**：默认拒绝、输入校验、最小权限、配置安全优先。
