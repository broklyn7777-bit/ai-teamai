# 敏感数据脱敏规范

## 一、脱敏范围

手机号、身份证、银行卡、邮箱、IP 地址、密码、密钥、内部 IP、业务配置等。

**强制要求**：日志禁止输出完整敏感信息、接口返回值禁止返回敏感字段、数据导出必须脱敏。

## 二、JSON 序列化脱敏（接口返回值）

### 2.1 滑动脱敏注解（@JsonSlideDesensitize）

适用于手机号、身份证、银行卡等固定格式字段。

```java
@Data
public class SysUserPageVO {
    @ApiModelProperty("手机号，脱敏为 158****00 格式")
    @JsonSlideDesensitize(type = SlideDesensitizationTypeEnum.PHONE_NUMBER)
    private String phone;

    @ApiModelProperty("身份证，脱敏为 110101*****1234 格式")
    @JsonSlideDesensitize(type = SlideDesensitizationTypeEnum.ID_CARD_NO)
    private String idCard;

    @ApiModelProperty("银行卡，脱敏为 330150****1234 格式")
    @JsonSlideDesensitize(type = SlideDesensitizationTypeEnum.BANK_CARD_NO)
    private String bankCard;

    @ApiModelProperty("邮箱，完全脱敏")
    @JsonSlideDesensitize(type = SlideDesensitizationTypeEnum.ALL_ASTERISK)
    private String email;

    @ApiModelProperty("自定义脱敏")
    @JsonSlideDesensitize(
        type = SlideDesensitizationTypeEnum.CUSTOM,
        leftPlainTextLen = 2,
        rightPlainTextLen = 2,
        maskString = "*"
    )
    private String customField;
}
```

**滑动脱敏类型对照表**

| 脱敏类型 | 格式示例 | 左明文 | 右明文 | 应用场景 |
|---------|---------|--------|--------|---------|
| `PHONE_NUMBER` | 158****00 | 3 | 2 | 手机号 |
| `ID_CARD_NO` | 110101*****1234 | 6 | 4 | 身份证 |
| `BANK_CARD_NO` | 330150****1234 | 6 | 4 | 银行卡 |
| `ALL_ASTERISK` | ****** | 0 | 0 | 完全隐藏 |
| `CUSTOM` | 自定义 | 自定义 | 自定义 | 自定义需求 |

### 2.2 正则脱敏注解（@JsonRegexDesensitize）

适用于邮箱、密码等可变格式字段。

```java
@Data
public class UserDTO {
    @ApiModelProperty("邮箱，脱敏为 a****@qq.com 格式")
    @JsonRegexDesensitize(type = RegexDesensitizationTypeEnum.EMAIL)
    private String email;

    @ApiModelProperty("加密密码，脱敏为 adm****56 格式")
    @JsonRegexDesensitize(type = RegexDesensitizationTypeEnum.ENCRYPTED_PASSWORD)
    private String password;

    @ApiModelProperty("自定义正则脱敏")
    @JsonRegexDesensitize(
        type = RegexDesensitizationTypeEnum.CUSTOM,
        regex = "^(.{2})[\\s\\S]*(.{2}$)",
        replacement = "$1****$2"
    )
    private String customRegexField;
}
```

**正则脱敏类型对照表**

| 脱敏类型 | 格式示例 | 正则规则 | 应用场景 |
|---------|---------|---------|---------|
| `EMAIL` | a****@qq.com | `(^.)[^@]*(@.*$)` | 邮箱 |
| `ENCRYPTED_PASSWORD` | adm****56 | `(.{3}).*(.{2}$)` | 加密密码 |
| `CUSTOM` | 自定义 | 自定义正则 | 自定义需求 |

### 2.3 简单脱敏注解（@JsonSimpleDesensitize）

一律显示 6 个 `*`。

```java
@Data
public class UserDTO {
    @ApiModelProperty("敏感字段，一律脱敏为 ******")
    @JsonSimpleDesensitize(handler = SixAsteriskDesensitizationHandler.class)
    private String sensitiveField;
}
```

## 三、日志脱敏

### 3.1 禁止：直接打印敏感数据

```java
// ❌ 禁止做法
log.info("Adding user: {}", user);           // 整个对象打印，敏感数据暴露
log.info("User password: {}", user.getPassword());  // 直接打印敏感字段
```

### 3.2 推荐：手动脱敏后打印

```java
// ✅ 手动脱敏
log.info("Adding user: name={}, phone={}, email={}",
    user.getUserName(),
    desensitizePhone(user.getPhone()),
    desensitizeEmail(user.getEmail())
);

private String desensitizePhone(String phone) {
    if (StringUtils.isBlank(phone) || phone.length() < 5) return "****";
    return phone.substring(0, 3) + "****" + phone.substring(phone.length() - 2);
}

private String desensitizeEmail(String email) {
    if (StringUtils.isBlank(email) || !email.contains("@")) return "****";
    int atIndex = email.indexOf("@");
    return email.charAt(0) + "****" + email.substring(atIndex);
}
```

### 3.3 推荐：使用脱敏处理器

```java
@Autowired
private SlideDesensitizationHandler slideHandler;

String desensitizedPhone = slideHandler.handle(
    user.getPhone(),
    SlideDesensitizationTypeEnum.PHONE_NUMBER
);
log.info("Adding user: phone={}", desensitizedPhone);
```

### 3.4 敏感操作审计日志

```java
// ❌ 禁止
log.info("User {} modified password to {}", userId, newPassword);

// ✅ 推荐
log.info("User {} modified password", userId);  // 不输出密码内容

// ✅ 审计日志
log.info("AUDIT|{}|userId:{}|phone:{}|timestamp:{}",
    operationType,
    userId,
    desensitizePhone(userData.getPhone()),
    System.currentTimeMillis()
);
```

## 四、脱敏方式混用禁忌

| 场景 | 正确方式 |
|------|---------|
| 接口返回值 | 使用 `@JsonSlideDesensitize` / `@JsonRegexDesensitize` / `@JsonSimpleDesensitize` |
| 日志输出 | 手动脱敏或使用 `SlideDesensitizationHandler` |
| 数据导出 | 必须脱敏，使用与接口返回值相同的注解脱敏 |

禁止混用：日志输出不能用 JSON 注解脱敏，接口返回值不能手动拼接 `****`。
