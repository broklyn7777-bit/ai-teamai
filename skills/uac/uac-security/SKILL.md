---
name: uac-security
description: |
  安全防护卫士。用于实现身份认证/授权、数据加密、敏感数据脱敏、密钥管理、访问控制和审计日志配置。
  覆盖使用 @PreAuthorize 进行接口权限验证、AES-GCM 加密数据库字段和 HTTP 报文、API 响应和日志中敏感信息脱敏、全面安全最佳实践。
  触发关键词："安全"、"权限"、"接口鉴权"、"加密"、"解密"、"AES"、"RSA"、"脱敏"、"数据安全"、"敏感字段"、"身份认证"、"PreAuthorize"、"AesGcmUtil"、"EncryptField"、"DecryptField"、"JsonSlideDesensitize"、"Jasypt"
compatibility: Requires Spring Security 2.5.2+, orion-crypto-core, orion-crypto-db, Jasypt encryption library
---

# Skill: Security-Audit
# 适用场景：接口鉴权、权限控制、数据加密、报文加解密、敏感数据脱敏、配置加密、数据库字段加密、操作审计

## 一、核心触发场景

安全、权限、接口鉴权、加密、解密、AES、RSA、AesGcmUtil、数据库加密、配置加密、PreAuthorize、加解密、报文加密

## 二、强制基础规范

1. **加密工具统一**：禁止自定义加密工具类、禁止使用 DES/MD5，AES 强制使用 `com.sf.gis.orion.common.utils.crypto.AesGcmUtil`（GCM 模式）
2. **密钥管理**：密钥禁止硬编码，必须配置中心读取；禁止明文密钥提交 git
3. **敏感数据定义**：密码、手机号、身份证、银行卡、密钥、内部 IP、业务配置，全程禁止明文：存储加密、传输加密、日志脱敏
4. **接口鉴权强制**：所有业务接口必须 `@PreAuthorize`，禁止匿名访问（登录、健康检查、公网接口除外）
5. **权限标识规范**：遵循 **业务域:模块:操作** 格式（如 `system:user:add`）

## 三、接口鉴权与权限控制

- 统一使用 `@PreAuthorize("@per.hasPermission('xxx:xxx:xxx')")` 注解
- Token 认证配置通过 `SecurityProperties`（`userTokenCheckPath` / `ignorePath`）
- 用户信息获取使用 `SecurityUtils`（`getLoginAuthDto` / `getLoginAuthInfo`），必须 null 校验
- 敏感操作额外做数据归属校验，防止越权

详见 `references/auth-rules.md`

## 四、数据加密规范

- 数据库字段：`@EncryptionClass` + `@EncryptField`/`@DecryptField` 注解驱动，入库加密/查询解密
- HTTP 报文：`@Decrypt`（请求解密）/ `@Encrypt`（响应加密）
- 配置文件：基于 Jasypt 实现配置加密，生产环境通过启动参数传入 Jasypt 密码
- 特殊场景：`MySqlAESUtil` 基于 IP 绑定密钥手动加解密

详见 `references/crypto-rules.md`

## 五、敏感数据脱敏

- JSON 序列化脱敏（接口返回值）：`@JsonSlideDesensitize`（手机号/身份证/银行卡）、`@JsonRegexDesensitize`（邮箱/密码）、`@JsonSimpleDesensitize`（一律 6 个 `*`）
- 日志脱敏：禁止直接打印敏感数据，必须手动脱敏后打印或使用 `SlideDesensitizationHandler`
- 强制：日志禁止输出完整敏感信息、接口返回值禁止返回敏感字段、数据导出必须脱敏

详见 `references/desensitize-rules.md`

## 六、编码禁忌

- 禁止自定义加密算法、禁止硬编码密钥、禁止明文打印敏感数据
- 禁止捕获大异常不处理、禁止外部代码执行、禁止未校验文件上传
- 禁止直接使用用户输入拼接 SQL（必须参数化查询）
- 加解密异常统一捕获，返回标准化提示，不暴露底层密钥/加密方式信息

## 红线禁忌

详见 `references/security-redlines.md`（完整 20+ 条红线）

**核心红线**：
- ⛔ 业务接口遗漏 `@PreAuthorize` | ⛔ 硬编码权限检查
- ⛔ 跳过数据归属校验 | ⛔ 明文密钥提交 git
- ⛔ 日志打印完整敏感数据 | ⛔ 自定义加密工具/算法
- ⛔ 跨租户查询数据不隔离

---

## 📚 快速参考文件导航

| 文件名 | 用途 | 适用场景 |
|---|---|---|
| **auth-rules.md** | 接口鉴权、权限注解、Token配置、SecurityUtils | 快速查表 |
| **crypto-rules.md** | 数据库加密、HTTP报文加密、Jasypt配置 | 快速查表 |
| **desensitize-rules.md** | JSON注解脱敏、日志脱敏、对照表 | 快速查表 |
| **security-redlines.md** | 完整红线禁忌汇总 | 故障排查 |
