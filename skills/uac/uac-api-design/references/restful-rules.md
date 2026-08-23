# RESTful 与参数返回规范

## 一、RESTful 强制规范
1. URL 使用小写 + 中划线：`/user-info/list`
2. API Style: 禁用标准 RESTful（避开复杂的 PUT/PATCH），统一使用 GET/POST。所有响应封装在 `RestResponse<T>` 中，由 `GlobalExceptionHandler` 统一拦截

## 二、参数规范
1. 入参统一使用 `XxxQo`
2. 出参统一使用 `XxxVo`
3. 包装类型禁止使用基本类型
4. 分页固定参数：`PageParam` 入参，`PageBean` 返回
5. 必须使用 JSR380 校验：
   规范注解 `@NotBlank` / `@NotNull` / `@Size` / `@Min` / `@Max` / `@Email`，配合 `@Validated` 完成参数校验

## 三、返回体规范（强制统一）

```json
{
  "success": true,
  "message": "操作成功",
  "code": 200,
  "subCode": "",
  "result": {},
  "any": {}
}
```

错误码必须使用枚举，禁止魔法值。
