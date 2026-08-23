---
paths:
  - "**/*.java"
---

# Java 安全

> 本文档在 [common/security.md](../common/security.md) 的基础上，补充了 Java 特有的安全原则。项目级的加密、脱敏、鉴权完整指南请参见 Skill `uac-security`。

## 核心原则

1. **密钥管理**：禁止硬编码，使用环境变量或密钥管理器（Vault 等）
2. **SQL 注入**：始终使用参数化查询，禁止字符串拼接 SQL
3. **输入验证**：在 DTO 层使用 Bean Validation（`@NotNull`, `@NotBlank`, `@Size`）
4. **密码存储**：使用 bcrypt 或 Argon2，禁止 MD5/SHA1
5. **错误信息**：禁止向客户端暴露堆栈跟踪、内部路径或 SQL 错误
6. **依赖安全**：定期审计传递依赖（`mvn dependency:tree` + OWASP Dependency-Check）

## 项目级安全（详见 uac-security Skill）

| 领域 | 项目规范 |
|------|---------|
| 权限注解 | `@PreAuthorize("@per.hasPermission('业务域:模块:操作')")` |
| 数据库加密 | `@EncryptionClass` + `@EncryptField` / `@DecryptField` |
| HTTP 加解密 | `@Decrypt` / `@Encrypt` 注解 |
| 配置加密 | Jasypt `ENC(...)` |
| JSON 脱敏 | `@JsonSlideDesensitize` / `@JsonRegexDesensitize` / `@JsonSimpleDesensitize` |
| 用户工具类 | `SecurityUtils.getLoginAuthInfo()` 等 |

完整指南：`skills/uac-security/SKILL.md`（8 个专题 + 完整代码模板）
