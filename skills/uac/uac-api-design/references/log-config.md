# 接口日志配置（访问日志 + 操作日志）

## 一、访问日志（AccessLog）

### 1.1 启用方式

启动类添加 `@EnableAccessLog` 注解，框架自动采集请求耗时、IP、状态等信息。

```java
@EnableAccessLog
public class DemoApplication {
    public static void main(String[] args) {
        SpringApplication.run(DemoApplication.class, args);
    }
}
```

### 1.2 表结构与分区配置

```sql
CREATE TABLE `log_access_log` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `trace_id` char(24) DEFAULT NULL COMMENT '追踪ID',
  `start_time` bigint(20) DEFAULT NULL COMMENT '开始时间',
  `spend_time` bigint(20) DEFAULT NULL COMMENT '消耗时间',
  `ip` varchar(64) DEFAULT NULL COMMENT '访问IP地址',
  `user_agent` varchar(1000) DEFAULT NULL COMMENT '用户代理',
  `uri` varchar(255) DEFAULT NULL COMMENT '请求URI',
  `url` varchar(255) DEFAULT NULL,
  `method` varchar(10) DEFAULT NULL COMMENT '操作方式',
  `params` text COMMENT '请求参数',
  `status` tinyint(1) NOT NULL COMMENT '操作状态',
  `result` longtext COMMENT '响应信息',
  `permissions` varchar(255) DEFAULT NULL COMMENT '错误消息',
  `create_by` varchar(50) DEFAULT NULL COMMENT '执行时长',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `tenant_id` bigint(20) DEFAULT NULL COMMENT '租户ID',
  `client_id` varchar(150) DEFAULT '' COMMENT '应用ID',
  PRIMARY KEY (`id`,`create_time`) USING BTREE,
  KEY `uri` (`uri`) USING BTREE,
  KEY `create_time` (`create_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='访问日志'
/*!50100 PARTITION BY RANGE (to_days(create_time))
(PARTITION p20251201 VALUES LESS THAN (739951) ENGINE = InnoDB,
 PARTITION p20260101 VALUES LESS THAN (739982) ENGINE = InnoDB) */;

-- 配置自动分区（替换数据库名，参数禁止修改）
call dbamon.proc_main_partition_config (@v_MSG,current_user(),'数据库名','log_access_log','create_time','MONTH',1,24,20,'false');
```

**分区参数**：保留 24 个月数据（参数禁止修改），按 MONTH 分区。

## 二、操作日志（BusinessLog）

### 2.1 启用方式

启动类添加 `@EnableOperationLog` 注解。

```java
@EnableOperationLog
public class DemoApplication {
    public static void main(String[] args) {
        SpringApplication.run(DemoApplication.class, args);
    }
}
```

### 2.2 注解使用

```java
// 修改操作（必须存储旧数据）
@BussinessLog(operation = "修改系统配置", targetIds = "confKey,name,confValue,category", isModify = true)
public RestResponse updateById(@RequestBody SysConfig sysConfig) {
    SysConfig oldConfig = sysConfigService.getById(sysConfig.getId());
    LogObjectHolder.me().set(oldConfig); // 必须存储旧数据，禁止省略
    return RestResponse.ok(sysConfigService.updateConfig(sysConfig));
}

// 删除操作
@BussinessLog(operation = "删除系统配置项", targetIds = "id", target = "ID:%s;")
@DeleteMapping("/{id}")
public RestResponse removeById(@PathVariable("id") Long id) {
    return RestResponse.ok(sysConfigService.removeById(id));
}
```

**强制约束**：
- 所有新增、修改需要审计接口必须加 `@BussinessLog`，纯查询接口禁止使用
- `operation` 参数必须使用中文清晰表达操作意义
- `targetIds` 必须包含主键和业务关键字段，禁止为空或无关字段
- 修改操作必须在 Service 层执行 `LogObjectHolder.me().set(旧数据)`，禁止在 Controller 层调用

### 2.3 表结构与分区配置

```sql
CREATE TABLE `log_operation_log` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '编号',
  `trace_id` char(24) DEFAULT NULL COMMENT '追踪ID',
  `ip` varchar(64) DEFAULT NULL COMMENT '访问IP地址',
  `user_agent` varchar(1000) DEFAULT NULL COMMENT '用户代理',
  `uri` varchar(255) DEFAULT NULL COMMENT '请求uri',
  `method` varchar(10) DEFAULT NULL COMMENT '请求方式',
  `params` text COMMENT '操作提交的数据',
  `operation` varchar(255) DEFAULT NULL COMMENT '操作动作',
  `status` tinyint(1) NOT NULL COMMENT '操作状态',
  `target` varchar(255) DEFAULT NULL COMMENT '操作对象',
  `clazz_name` varchar(255) DEFAULT NULL COMMENT '操作类名称',
  `method_name` varchar(255) DEFAULT NULL COMMENT '方法名',
  `permissions` varchar(255) DEFAULT NULL COMMENT '权限值',
  `spend_time` bigint(20) DEFAULT NULL COMMENT '执行时长',
  `result` longtext,
  `create_by` varchar(50) DEFAULT NULL COMMENT '创建者',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `tenant_id` bigint(20) DEFAULT NULL COMMENT '租户ID',
  `client_id` varchar(50) DEFAULT '' COMMENT '应用ID',
  PRIMARY KEY (`id`,`create_time`) USING BTREE,
  KEY `operator` (`create_by`) USING BTREE,
  KEY `uri` (`uri`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  KEY `create_time` (`create_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='操作日志'
/*!50100 PARTITION BY RANGE (to_days(create_time))
(PARTITION p20251201 VALUES LESS THAN (739951) ENGINE = InnoDB,
 PARTITION p20260101 VALUES LESS THAN (739982) ENGINE = InnoDB) */;

-- 配置自动分区（替换数据库名，参数禁止修改）
call dbamon.proc_main_partition_config (@v_MSG,current_user(),'数据库名','log_operation_log','create_time','MONTH',1,24,20,'false');
```
