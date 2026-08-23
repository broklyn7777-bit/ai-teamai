# 多数据源切换 快速参考

## @DS 注解用法

### 类级别指定（整个类使用同一数据源）

```java
@DS("db1")
@Service
public class OrderServiceImpl implements OrderService {
    // 这个 Service 的所有方法都走 db1 数据源
}
```

### 方法级别指定（仅当前方法生效，优先级高于类级）

```java
@Service
public class UserServiceImpl implements UserService {

    @DS("db2")
    public User queryFromDb2(Long userId) {
        return userMapper.selectById(userId);
    }

    // 此方法走默认 master 数据源
    public User queryDefault(Long userId) {
        return userMapper.selectById(userId);
    }
}
```

### 请求头动态指定（根据请求头参数动态切换）

```java
@DS("#header.dsName")
@Service
public class DynamicServiceImpl implements DynamicService {
    // 从 HTTP 请求头中读取 dsName 参数，动态切换数据源
    // curl -H "dsName: db1" http://...
}
```

---

## 数据源切换规则速查表

| 场景 | 配置方式 | 优先级 | 说明 |
|---|---|---|---|
| 整个 Service 用一个数据源 | @DS 在类上 | 低 | 简单场景使用 |
| 单个方法用不同数据源 | @DS 在方法上 | 高 | 方法级优先级高于类级 |
| 根据请求动态切换 | @DS("#header.参数名") | 中 | 从请求头读取数据源名 |
| 默认走主数据源 | 不添加 @DS | - | 不指定时自动走 master |

---

## 常见错误和解决方案

**错误1** ❌：strict 模式开启，未匹配到数据源导致服务报错

```yaml
# ⛔ 生产环境不要这样！
spring:
  datasource:
    dynamic:
      strict: true  # 严格模式打开，未匹配到数据源会报错
```

**解决**：生产环境保持 strict: false，让未匹配的请求自动走默认数据源

```yaml
# ✅ 正确！
spring:
  datasource:
    dynamic:
      strict: false  # 未匹配时走默认 master 数据源
```

---

**错误2** ❌：跨数据库的嵌套调用和分布式事务

```java
// ⛔ 禁止！框架不支持分布式事务
@Transactional
public void crossDbOperation() {
    userService.saveToDb1();    // db1
    orderService.saveToDb2();   // db2，事务无法跨库保障
}
```

**解决**：避免跨数据源的事务操作，在应用层规避或使用消息队列解耦

---

## 配置模板

```yaml
spring:
  datasource:
    dynamic:
      enabled: true
      primary: master      # 默认数据源，必须设置
      strict: false        # 生产关闭严格模式
      datasource:
        master:
          url: jdbc:mysql://host1:3306/db1...
          username: user1
          password: pass1
          driver-class-name: com.mysql.jdbc.Driver
          druid:
            initial-size: 50
            min-idle: 50
            max-active: 100
            test-on-borrow: true
            time-between-eviction-runs-millis: 60000
            min-evictable-idle-time-millis: 300000
            web-stat-filter:
              exclusions: '*.js,*.gif,*.jpg,*.png,*.css,*.ico,/druid/*'
            stat-view-servlet:
              allow:
              login-username: admin
              login-password: admin
        db1:
          url: jdbc:mysql://host2:3306/db2...
          username: user2
          password: pass2
          driver-class-name: com.mysql.jdbc.Driver
          druid:
            initial-size: 50
            min-idle: 50
            max-active: 100
            test-on-borrow: true
            time-between-eviction-runs-millis: 60000
            min-evictable-idle-time-millis: 300000
            web-stat-filter:
              exclusions: '*.js,*.gif,*.jpg,*.png,*.css,*.ico,/druid/*'
            stat-view-servlet:
              allow:
              login-username: admin
              login-password: admin
```
