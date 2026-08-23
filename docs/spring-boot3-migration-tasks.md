# Spring Boot 3 + orioncloud-uac 3.1.0.0 迁移任务清单

> 生成时间：2026-05-29
> 分支：`feature/202604/spring-boot3-upgrade`
> 目标：Spring Boot 2.x → 3.x + orioncloud-parent → orioncloud-uac

---

## Phase 1: 前置准备

### 1.1 确认 JDK 17 运行环境

- [ ] 确认本地已安装 JDK 17+（`java -version`）
- [ ] 确认 CI/CD 环境 JDK 版本为 17
- [ ] 更新 IDEA/编辑器 SDK 指向

**破坏性等级**：低 | **预估时间**：5min

### 1.2 配置 Maven 内部仓库

- [ ] 在 `~/.m2/settings.xml` 中添加 `artifactory.sf-express.com` 仓库配置
- [ ] 验证 `mvn help:effective-settings` 能看到内部仓库地址
- [ ] 测试下载 `com.orioncloud.uac:orioncloud-uac:3.1.0.0`

**破坏性等级**：低 | **预估时间**：10min

### 1.3 确认 orioncloud-uac 3.1.0.0 已发布

- [ ] 联系 uac 框架团队确认发布状态
- [ ] 确认依赖 groupId 映射关系（`com.orioncloud.*` → `com.orioncloud.uac.*`）
- [ ] 获取框架发布说明/迁移文档

**破坏性等级**：低 | **预估时间**：沟通确认

---

## Phase 2: POM 升级

### 2.1 根 pom.xml 父 POM 坐标变更

- [x] 父 groupId：`com.orioncloud` → `com.orioncloud.uac`
- [x] 父 artifactId：`orioncloud-parent` → `orioncloud-uac`
- [x] 父 version：使用硬编码 `3.1.0.0`（不能使用 `${uac-version}` 变量）

**破坏性等级**：低 | **预估时间**：5min | **状态**：✅ 已完成

### 2.2 JDK 版本升级

- [x] 根 pom.xml `<java.version>`：1.8 → 17
- [x] `orioncloud-provider-demo/pom.xml` `<java.version>`：1.8 → 17

**破坏性等级**：低 | **预估时间**：5min | **状态**：✅ 已完成

### 2.3 框架版本号升级

- [x] `<orion-version>`：2.2.2.3 → 3.1.0.0
- [x] 新增 `<uac-version>3.1.0.0</uac-version>`

**破坏性等级**：低 | **预估时间**：5min | **状态**：✅ 已完成

---

## Phase 3: 代码适配

### 3.1 @EnableOAuth2Sso 替换

- [ ] 确认 uac 3.1.0.0 提供的 Boot 3 认证替代方案
- [ ] 替换 `DemoApplication.java` 中的 `@EnableOAuth2Sso` 注解
- [ ] 替换对应的 import 语句
- [ ] 如有新增安全配置类，一并创建

**涉及文件**：`orioncloud-provider-demo/src/main/java/com/sf/gis/orioncloud/DemoApplication.java`

**破坏性等级**：高 | **预估时间**：2-4h | **状态**：⏸️ 阻塞（需框架确认）

### 3.2 Swagger 2 注解迁移到 OpenAPI 3

- [ ] 确认 uac 3.1.0.0 是否已内置 Knife4j 4.x / OpenAPI 3
- [ ] 批量替换注解：
  - `io.swagger.annotations.Api` → `io.swagger.v3.oas.annotations.tags.Tag`
  - `io.swagger.annotations.ApiOperation` → `io.swagger.v3.oas.annotations.Operation`
  - `io.swagger.annotations.ApiModel` → `io.swagger.v3.oas.annotations.media.Schema`
  - `io.swagger.annotations.ApiModelProperty` → `io.swagger.v3.oas.annotations.media.Schema`
- [ ] 验证 Knife4j 文档页面正常渲染

**涉及文件**（14 个）：

```
orion-demo/orion-demo-controller/src/main/java/.../SysConfigController.java
orion-demo/orion-demo-controller/src/main/java/.../GridController.java
orion-demo/orion-demo-model/src/main/java/.../SysConfigPageVo.java
orion-demo/orion-demo-model/src/main/java/.../SysConfigExcelVO.java
orion-demo/orion-demo-model/src/main/java/.../GridPageVo.java
orion-demo/orion-demo-model/src/main/java/.../GridExcelVO.java
orion-demo/orion-demo-model/src/main/java/.../GridQo.java
orion-demo/orion-demo-model/src/main/java/.../SysConfigQo.java
orion-demo/orion-demo-model/src/main/java/.../SysConfig.java
orion-demo/orion-demo-model/src/main/java/.../Grid.java
```

**破坏性等级**：中 | **预估时间**：1-2h | **状态**：⏳ 待执行

### 3.3 javax.* → jakarta.* 隐式引用修复

- [ ] 扫描所有 Java 文件确认无直接 `javax.*` 引用
- [ ] 编译后检查是否有框架层的 javax 隐式引用报错
- [ ] 如有间接引用，替换为 `jakarta.*`

**注意**：当前项目代码中已无 `javax.*` 直接引用，此任务需编译后确认

**破坏性等级**：中 | **预估时间**：1h | **状态**：⏳ 待编译验证

---

## Phase 4: 依赖兼容性确认

### 4.1 Forest HTTP 客户端

- [ ] 确认 uac 3.1.0.0 管理的 Forest 版本（当前项目引入 1.5.36）
- [ ] 如框架未升级，手动指定 Boot 3 兼容版本（≥ 1.6.0）
- [ ] 验证 `@ForestScan` 注解正常工作

**涉及文件**：`orion-demo/orion-demo-biz/pom.xml`、`DemoApplication.java`

**破坏性等级**：中 | **预估时间**：1h | **状态**：⏳ 待执行

### 4.2 Saturn 定时任务

- [ ] 确认 `saturn-spring 3.6.9.SF.RELEASE` 对 Boot 3 的兼容性
- [ ] 如有新版本，更新版本号
- [ ] 验证定时任务注册正常

**涉及文件**：`orion-demo/orion-demo-biz/pom.xml`

**破坏性等级**：中 | **预估时间**：1h | **状态**：⏳ 待执行

### 4.3 Kafka 客户端

- [ ] 确认 `sf-kafka-api-core 1.20.3` 对 Boot 3 的兼容性
- [ ] 确认 `kafka-clients 2.5.1` 是否需要升级到 3.x
- [ ] 验证 Kafka 生产/消费功能

**涉及文件**：`orion-demo/orion-demo-biz/pom.xml`

**破坏性等级**：中 | **预估时间**：1h | **状态**：⏳ 待执行

### 4.4 MyBatis-Plus

- [ ] 确认 uac 3.1.0.0 管理的 MyBatis-Plus 版本（应 ≥ 3.5.3.1）
- [ ] 检查 Entity 注解（`@TableName`、`@TableLogic`）是否兼容
- [ ] 检查 Mapper 接口是否兼容

**涉及文件**：全部 Entity、Mapper、Service 文件

**破坏性等级**：中 | **预估时间**：1h | **状态**：⏳ 待执行

---

## Phase 5: 配置适配

### 5.1 Nacos 配置中心

- [ ] 确认 Nacos 中 `orion-cloud-boot3` namespace 已创建
- [ ] 确认配置中心中 `application-dev.yml` 已适配 Boot 3
- [ ] 确认 `extension-configs` 和 `shared-configs` 格式兼容

**涉及文件**：`orioncloud-provider-demo/src/main/resources/bootstrap.yml`

**破坏性等级**：低 | **预估时间**：30min | **状态**：✅ 已确认（当前已使用新格式）

### 5.2 Profile 配置文件检查

- [ ] 检查 `dev` 环境 `application.yml`
- [ ] 检查 `prod` 环境 `application.yml`
- [ ] 检查 `sit` 环境 `application.yml`
- [ ] 确认无已废弃的 Spring Boot 2.x 配置属性

**涉及文件**：
```
orioncloud-provider-demo/src/main/assembly/dev/conf/application.yml
orioncloud-provider-demo/src/main/assembly/prod/conf/prod/application.yml
orioncloud-provider-demo/src/main/assembly/prod/conf/sit/application.yml
```

**破坏性等级**：低 | **预估时间**：30min | **状态**：⏳ 待执行

### 5.3 Spring Cloud 配置检查

- [ ] 确认 `bootstrap.yml` 中 Spring Cloud 配置兼容
- [ ] 确认 `spring-cloud-starter-bootstrap` 版本对齐
- [ ] 确认 `EnableDiscoveryClient` 和 `EnableFeignClients` 注解兼容

**涉及文件**：`orioncloud-provider-demo/src/main/resources/bootstrap.yml`

**破坏性等级**：低 | **预估时间**：30min | **状态**：⏳ 待执行

---

## Phase 6: 验证

### 6.1 编译验证

- [ ] `mvn clean compile -DskipTests` 零错误通过
- [ ] 记录编译错误并逐一修复

**破坏性等级**：中 | **预估时间**：30min | **状态**：🔴 阻塞（内部仓库未配置）

### 6.2 编译错误修复

- [ ] 根据编译报错修复 import
- [ ] 修复 API 不兼容
- [ ] 修复注解不兼容
- [ ] 重新编译直到零错误

**破坏性等级**：中 | **预估时间**：1-4h | **状态**：⏳ 待执行

### 6.3 单元测试验证

- [ ] `mvn test` 全部通过
- [ ] 修复失败的测试

**破坏性等级**：中 | **预估时间**：30min | **状态**：⏳ 待执行

### 6.4 本地启动验证

- [ ] 应用成功启动（观察启动日志）
- [ ] 访问 `http://localhost:8050/demo/actuator/health` 健康检查
- [ ] 访问 Knife4j 文档页面（如有）
- [ ] 测试核心 API 接口

**破坏性等级**：中 | **预估时间**：1h | **状态**：⏳ 待执行

### 6.5 Nacos 注册验证

- [ ] 登录 Nacos 控制台确认服务注册成功
- [ ] 确认配置从 Nacos 正确加载
- [ ] 确认服务发现正常

**破坏性等级**：中 | **预估时间**：1h | **状态**：⏳ 待执行

---

## 总览

| Phase | 状态 | 完成度 | 预估时间 |
|-------|------|--------|---------|
| Phase 1: 前置准备 | 🔴 阻塞 | 0/3 | 15min + 沟通 |
| Phase 2: POM 升级 | ✅ 完成 | 3/3 | ✅ 已完成 |
| Phase 3: 代码适配 | 🔴 阻塞 | 0/3 | 3-6h |
| Phase 4: 依赖确认 | ⏳ 待执行 | 0/4 | 3h |
| Phase 5: 配置适配 | ⏳ 进行中 | 1/3 | 1h |
| Phase 6: 验证 | 🔴 阻塞 | 0/5 | 3-5h |
| **合计** | | **4/21** | **约 10-15h** |

---

## 回滚策略

```bash
# 回到主分支
git checkout master

# 删除升级分支
git branch -D feature/202604/spring-boot3-upgrade
```

---

## 关键阻塞项清单

| # | 阻塞项 | 需要谁确认 | 影响范围 |
|---|--------|-----------|---------|
| 1 | Maven 内部仓库未配置 | 自行配置 | Phase 1、6 |
| 2 | `@EnableOAuth2Sso` 替代方案 | uac 框架团队 | Phase 3.1 |
| 3 | orioncloud-uac 3.1.0.0 是否已发布 | uac 框架团队 | Phase 1.3、6.1 |
| 4 | Swagger 2 → OpenAPI 3 迁移方式 | uac 框架团队（是否已内置） | Phase 3.2 |
| 5 | Saturn/Forest/Kafka 兼容版本 | uac 框架团队 | Phase 4 |
