# 数据加密规范（存储层 + 传输层 + 配置加密）

## 一、核心约束

- 加密工具统一使用公司 orion 框架（`orion-crypto-core`、`orion-crypto-db`），禁止引入第三方不安全加密包
- 禁止自定义加密工具类、禁止使用 DES/MD5 等不安全算法
- AES 加密强制使用 `com.sf.gis.orion.common.utils.crypto.AesGcmUtil`（GCM 模式，安全级别最高）
- 密钥禁止硬编码，必须通过配置中心读取；禁止明文密钥提交 git

## 二、数据库字段加解密

### 2.1 依赖引入

```xml
<dependency>
    <groupId>com.orion.cropto</groupId>
    <artifactId>orion-crypto-db</artifactId>
    <version>${orion-version}</version>
</dependency>
```

### 2.2 注解驱动（自动加解密）

```java
@Data
@TableName("sys_user")
@EncryptionClass // 标记为加密类
public class SysUser extends DataEntity<SysUser, Long> {

    @TableField("password")
    @EncryptField  // 入库自动加密
    @DecryptField  // 查询自动解密
    private String password;

    @TableField("phone")
    @EncryptField
    @DecryptField
    private String phone;

    @TableField("email") // 普通字段，不加解密
    private String email;
}
```

**约束**：禁止对非敏感字段加解密，禁止主键/索引字段加密，禁止手动加解密与自动加解密混用。

### 2.3 YAML 配置

```yaml
orion:
  sql:
    enableSqlCryptoInterceptor: true  # 开启数据库字段加解密拦截
  crypto:
    rsaEnable: true  # 生成RSA密钥对，用于解密前端报文
    cache:
      cache_mange:
        crypto:  # 加解密专用redis，禁止与业务缓存混用
          cache_prefix: crypto
          redis:
            password: ${REDIS_PASSWORD}
            cluster:
              nodes: ${REDIS_NODES}
```

### 2.4 Service 层操作

```java
@Service
public class SysUserServiceImpl extends ServiceImpl<SysUserMapper, SysUser> {
    @Override
    public SysUser getUserById(Long id) {
        return this.getById(id);  // 查询自动解密 @DecryptField 字段
    }

    @Override
    public boolean saveUser(SysUser user) {
        return this.save(user);  // 保存自动加密 @EncryptField 字段
    }
}
```

### 2.5 手动加解密（特殊场景）

```java
// 仅在特殊场景使用，禁止常规业务使用
String localIp = IPUtil.getLocalIP(true);
String reverseKey = CryptoInitialization.cacheCryptoKey.getCache(localIp);
if (StringUtils.isBlank(reverseKey)) {
    throw new BaseException("数据库加密密钥获取失败");
}
String decryptResult = MySqlAESUtil.decrypt(encryptedData, reverseKey);
```

## 三、HTTP 报文加解密

### 3.1 依赖引入

```xml
<dependency>
    <groupId>com.orion.cropto</groupId>
    <artifactId>orion-crypto-core</artifactId>
    <version>${orion-version}</version>
</dependency>
```

### 3.2 请求参数解密

```java
@PostMapping("/update-sensitive")
@Decrypt  // 自动解密请求参数
@PreAuthorize("@per.hasPermission('system:config:update')")
public RestResponse<?> updateSensitiveConfig(@RequestBody ConfigDTO configDTO) {
    configService.updateConfig(configDTO);
    return RestResponse.ok();
}
```

### 3.3 返回数据加密

```java
@GetMapping("/query-sensitive")
@Encrypt  // 自动加密返回数据
@PreAuthorize("@per.hasPermission('system:config:query')")
public RestResponse<ConfigDTO> querySensitiveConfig(@RequestParam("id") Long id) {
    return RestResponse.ok(configService.getById(id));
}
```

## 四、配置文件加密（Jasypt）

### 4.1 生成加密密文

```java
@Component
public class JasyptUtil {
    @Autowired
    private StringEncryptor stringEncryptor;

    public String encrypt(String plaintext) {
        return stringEncryptor.encrypt(plaintext);
    }
}
```

### 4.2 配置文件使用

```yaml
spring:
  datasource:
    username: ENC(encryptedUsername)
    password: ENC(encryptedPassword)
  redis:
    password: ENC(encryptedRedisPassword)
app:
  third-party:
    api-key: ENC(encryptedApiKey)
```

### 4.3 生产启动参数

```bash
# Jasypt密码从启动参数读取，禁止在配置文件中放入加密密码
java -Djasypt.encryptor.password="prod_password_xyz" \
     -Dspring.profiles.active=prod \
     -jar application.jar
```
