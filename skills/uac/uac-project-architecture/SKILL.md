---
name: uac-project-architecture
description: |
  项目架构守护者 — Java 后端项目的架构和规范专家。定义四层模块结构（Model→Biz→Controller→Provider）、分层架构约束、包命名规范。
  当以下情况出现时，必须使用此 skill：
  • 新项目/新模块初始化，需要规划包结构和目录布局
  • 新增 Entity/Service/Controller，需要确认分层归属
  • 审查代码是否遵循分层铁律
  • 需要确认项目基础包名 com.sf.gis 和模块命名规则
  触发关键词："架构"、"分包"、"包结构"、"分层"、"启动类"、"全局异常"、"统一返回"、"模块结构"、"Entity"、"Service"、"Controller"、"构造器注入"、"MapStruct"、"DataEntity"
compatibility: Requires Spring Boot 2.5.5+, Lombok 1.18.16+, Java 8+, MyBatis-Plus
---

# Skill: Project-Architecture
# 适用场景：项目初始化、架构规范、包结构、分层开发、全局规范

## 一、四层模块结构

```
orion-{project}-model/           # 数据对象层 (Entity/DTO/Enum/VO)
   ├── entity/                   # 数据库实体，继承 DataEntity<T, Long>
   ├── dto/                      # 数据传输对象
   ├── vo/                       # 视图对象
   ├── enums/                    # 枚举类
   └── constant/                 # 常量定义

orion-{project}-biz/             # 业务服务层 (Service/Mapper)
   ├── service/                  # 服务接口
   ├── service/impl/             # 服务实现
   ├── mapper/                   # MyBatis Mapper
   └── resources/mapper/         # SQL映射文件

orion-{project}-controller/      # 表现层 (Controller/Config)
   ├── controller/               # REST 控制器
   └── config/                   # 配置类

orioncloud-provider-{project}/   # 应用启动层
   ├── {project}Application.java # Spring Boot 启动类
   └── resources/                # 环境配置文件
```

**基础包名**：`com.sf.gis`
**模块示例**：`com.sf.gis.demo.controller`、`com.sf.gis.demo.service`、`com.sf.gis.demo.entity`

## 二、分层铁律（Orion 框架特有约束）

1. **Entity** 仅作数据库映射，禁止包含任何业务逻辑方法。树状结构继承 `TreeEntity<T, Long>`
2. **Controller** 只做：参数校验、调用 Service、包装返回；禁止写业务逻辑、禁止 try-catch 吞异常
3. **Service** 只做：业务逻辑、事务、组合调用；禁止使用 MyBatis-Plus 的 QueryWrapper，复杂查询走 Mapper 自写 SQL
4. **Mapper** 只做：数据访问；简单查询用 BaseMapper，复杂查询用 XML + ResultMap
5. 禁止跨层直接访问，禁止 Controller 写业务逻辑
6. 全局统一异常处理 + 统一返回体 `RestResponse<T>`
7. 多表操作强制开启事务，事务内严禁 RPC 调用、MQ 发送、Redis 操作

## 三、依赖注入规范

- 禁止 `@Autowired` 字段注入，必须 `private final` + `@RequiredArgsConstructor` 构造器注入
- 禁用 `BeanUtils.copyProperties`，强制使用 MapStruct 做 Bean 映射
- Lombok 仅限 `@Data`、`@Getter`、`@Setter`、`@Slf4j`，禁止在 Entity 中滥用 `@Builder`

## 四、红线禁忌

- ⛔ 禁止在 Entity 中添加业务逻辑方法
- ⛔ 禁止使用 `@Autowired` 字段注入
- ⛔ 禁止在 Service 中使用 QueryWrapper（复杂查询走 Mapper XML）
- ⛔ 禁止手动 try-catch 吞掉异常
- ⛔ 禁止多表操作事务中包含 RPC/MQ/Redis 操作
- ⛔ 禁止在项目配置中硬编码中间件连接地址、API 密钥、密码
