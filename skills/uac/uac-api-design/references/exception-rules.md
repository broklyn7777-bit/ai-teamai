# 异常处理规范

## 一、异常定义规范

### 1. 模块异常枚举

- 命名格式：`{模块名}CodeEnum`，统一实现 `ExceptionEnums`
- 异常码 = 全局唯一模块主码（`ModuleCodeConstant`）+ 模块内唯一子码
- `subCode` 使用小写 + 短横线命名，语义化且唯一
- 枚举 `msg` 字段为可读提示，禁用无意义字符

```java
public enum CryptoCodeEnum implements ExceptionEnums {
    KEY_NOT_EXIST("key-not-exist", "密钥不存在"),
    KEY_EXPIRE("key-expire", "密钥过期");

    private final int code = ModuleCodeConstant.CRYPTO_MODULE;
    private final String subCode;
    private final String msg;

    CryptoCodeEnum(String subCode, String msg) {
        this.subCode = subCode;
        this.msg = msg;
    }

    @Override public int code() { return code; }
    @Override public String msg() { return msg; }
    public String getSubCode() { return subCode; }
}
```

### 2. 模块自定义异常类

- 类名格式：`{模块名}Exception`，继承 `RuntimeException`
- 提供枚举入参的构造方法，优先使用枚举初始化

```java
public class CryptoException extends RuntimeException {
    protected int code;

    public CryptoException(CryptoCodeEnum codeEnum, Object... args) {
        super(String.format(codeEnum.msg(), args));
        this.code = codeEnum.code();
    }

    public int getCode() { return code; }
    public void setCode(int code) { this.code = code; }
}
```

## 二、异常抛出规范

```java
// 场景1：普通业务异常
throw new BusinessException(CryptoCodeEnum.PUBLIC_KEY_NOT_FOUND);

// 场景2：模块专属异常（推荐，核心业务场景）
throw new CryptoException(CryptoCodeEnum.PUBLIC_KEY_NOT_FOUND);

// 场景3：带动态参数的模块异常
throw new CryptoException(CryptoCodeEnum.KEY_EXPIRE, "2024-01-01 12:00:00");
```

**约束**：必须传入完整枚举，禁用纯数字/字符串；动态消息用枚举 + 可变参数，禁止手动拼接。

## 三、异常处理禁忌

- 禁止空 catch 块，至少记录含堆栈的日志
- 禁止业务层捕获模块异常后抛通用异常，保留原始异常码/信息
- 禁止枚举定义重复 subCode 或无意义预留值
- 禁止异常处理时直接抛出底层异常给前端，必须转换为业务异常并返回用户友好的错误提示
