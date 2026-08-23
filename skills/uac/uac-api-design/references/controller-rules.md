# Controller 编写铁律与文档规范

## 一、Controller 编写铁律
1. 类注解：`@RestController`
2. 路由注解：`@RequestMapping("/xxx")`
3. 入参必须校验
4. 禁止编写业务逻辑
5. 框架全局异常处理，Controller 中禁止异常捕获

## 二、接口文档规范（Knife4j/Swagger）
1. 类上加 `@Api(tags = "XXX管理")`
2. 方法上加 `@ApiOperation("XXX接口")`
3. DTO 字段上加 `@ApiModelProperty`
4. 必须说明：必填/含义/示例

## 三、权限控制（强制）
1. 所有业务接口必须加 `@PreAuthorize` 注解，禁止匿名访问（登录接口、健康检查除外）
2. 禁止在代码中硬编码权限检查（如 `if(permission.contains("xxx"))`），必须使用 `@PreAuthorize` 的声明式权限
3. 权限标识遵循"业务域:模块:操作"格式（如 `system:user:add`）
4. 增删改操作必须校验数据是否属于当前用户/租户/机构，防止越权
