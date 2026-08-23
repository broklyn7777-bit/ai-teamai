# 接口幂等性配置与示例

## 一、强制要求
1. **适用范围**：所有涉及数据写入/状态变更的接口（提交、支付、更新、回调类）必须实现幂等性控制，纯查询接口除外
2. **技术选型**：统一使用基于 Redis 的分布式幂等方案（依托 `orion-spring-boot-starter-idempotent` 组件），禁止重复造轮子
3. **实现方式**：通过 AOP 注解 `@Idempotent` 完成幂等控制，禁止在业务逻辑中硬编码幂等校验逻辑

## 二、依赖引入

```xml
<dependency>
    <groupId>com.orion.starters</groupId>
    <artifactId>orion-spring-boot-starter-idempotent</artifactId>
    <version>${orion-version}</version>
</dependency>
```

## 三、Redis 全局配置

```java
@Configuration
public class IdempotentAutoConfig {
    @Bean
    public IdempotentKeyStore idempotentKeyStore() {
        // 必须使用项目统一的RedisHelper获取模板
        StringRedisTemplate redisTemplate = RedisHelper.getStrRedisTemplate("demo");
        return new RedisIdempotentKeyStore(redisTemplate);
    }
}
```

## 四、@Idempotent 注解用法

### 4.1 基础用法（默认规则）

```java
@PostMapping("/config/save")
@Idempotent  // 默认以请求全参+接口路径生成唯一Key，有效期5分钟
public RestResponse<SysConfig> saveConfig(@Validated @RequestBody SysConfig sysConfig) {
    return RestResponse.ok(sysConfigService.save(sysConfig));
}
```

### 4.2 自定义唯一标识 + 有效期

```java
@PostMapping("/biz/method2")
@Idempotent(
    uniqueExpression = "#key",   // SpEL表达式，指定入参作为唯一Key
    duration = 10                 // 有效期10秒，禁止无限制有效期
)
public RestResponse<String> method2(@NotBlank String key) {
    return RestResponse.ok(key);
}
```

### 4.3 从请求头获取唯一标识

```java
@PostMapping("/biz/method3")
@Idempotent(
    uniqueExpression = "#request.getHeader('formId')",
    duration = 30
)
public RestResponse<String> method3(HttpServletRequest request) {
    return RestResponse.ok("hello world");
}
```

## 五、注意事项
- 仅 POST/PUT/DELETE 接口需加幂等注解，GET 接口禁止使用
- `uniqueExpression` 使用 SpEL 表达式，优先使用业务唯一标识（订单号、表单ID）
- Header 中的唯一标识需由前端保证全局唯一（如 UUID）
