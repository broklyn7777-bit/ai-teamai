# 分库分表 快速入门

## 4 步快速配置

### 第 1 步：依赖引入

```xml
<dependency>
    <groupId>com.orion.starters</groupId>
    <artifactId>orion-spring-boot-starter-shardingsphere</artifactId>
    <version>${orion-version}</version>
</dependency>
```

### 第 2 步：普通数据源配置（application.yml）

```yaml
spring:
  datasource:
    dynamic:
      primary: gwl  # 默认普通数据源
      datasource:
        gwl:
          url: jdbc:mysql://host:3306/gwl...
          username: gwl
          password: ***
          driver-class-name: com.mysql.jdbc.Driver
        # 分片固定数据源：sharding
        sharding:
          driver-class-name: org.apache.shardingsphere.driver.ShardingSphereDriver
          url: jdbc:shardingsphere:nacos:${spring.application.name}-sharding-${spring.cloud.nacos.config.group}.yml
```

### 第 3 步：分片配置（Nacos 专用配置）

**配置名**：`{spring.application.name}-sharding-{group}.yml`

```yaml
dataSources:
  ds_0:
    dataSourceClassName: com.zaxxer.hikari.HikariDataSource
    driverClassName: com.mysql.jdbc.Driver
    jdbcUrl: jdbc:mysql://host:3306/data...
    username: user
    password: ***

rules:
  - !SHARDING
    tables:
      service_minute_stats:
        actualDataNodes: ds_0.service_minute_stats_$->{2023..2030}${(1..12).collect{t ->t.toString().padLeft(2,'0')}}
        tableStrategy:
          standard:
            shardingColumn: stats_time
            shardingAlgorithmName: month_interval
        keyGenerateStrategy:
          column: id
          keyGeneratorName: snowflake
    shardingAlgorithms:
      month_interval:
        type: INTERVAL
        props:
          datetime-pattern: yyyy-MM-dd HH:mm:ss
          datetime-lower: '2023-01-01 00:00:00'
          datetime-upper: '2025-01-01 00:00:00'
          datetime-interval-unit: Months
          sharding-suffix-pattern: yyyyMM
    keyGenerators:
      snowflake:
        type: SNOWFLAKE

props:
  sql-show: false  # 生产必须关闭
```

### 第 4 步：Service 层标记

```java
@Service
@DS("sharding")  // 固定指定分片数据源
public class ServiceMinuteStatsServiceImpl extends ServiceImpl<ServiceMinuteStatsMapper, ServiceMinuteStats>
        implements ServiceMinuteStatsService {
}
```

---

## 自定义分片算法

### 最小化示例（按用户 ID 模式分片）

```java
@Component
public class UserIdShardingAlgorithm implements StandardShardingAlgorithm<Long> {

    @Override
    public String doSharding(Collection<String> availableTargetNames, PreciseShardingValue<Long> shardingValue) {
        Long userId = shardingValue.getValue();
        // 计算用户应该落在哪个分表
        int shardIndex = (int)(userId % 10);  // 按 userId % 10 分配到 user_00 到 user_09
        return "user_" + String.format("%02d", shardIndex);
    }

    @Override
    public Collection<String> doSharding(Collection<String> availableTargetNames, RangeShardingValue<Long> shardingValue) {
        // 范围查询时的分片逻辑
        return availableTargetNames;
    }

    @Override
    public String getType() {
        return "USER_ID_MOD";
    }
}
```

Nacos 配置中引用：

```yaml
shardingAlgorithms:
  user_id_mod:
    type: USER_ID_MOD
```

---

## 常见错误清单

- [ ] ❌ 忘记 @DS("sharding") 注解
- [ ] ❌ sql-show: true 在生产环境（会严重影响性能）
- [ ] ❌ 跨分片表联表查询（ShardingSphere 不支持）
- [ ] ❌ 分片键为 NULL（会导致数据无法路由）
- [ ] ❌ 分片算法返回无效的表名

**检查**：分片操作必须指定分片键，否则会全表扫描
