# SQL 分析打印 快速参考

## p6spy 快速配置

### yml 配置（开启 SQL 打印）

```yaml
spring:
  datasource:
    dynamic:
      enabled: true
      primary: master
      p6spy: true  # ⚠️ 仅测试环境开启，生产必须关闭
      datasource:
        master:
          url: jdbc:mysql://localhost:3306/test...
          driver-class-name: com.p6spy.engine.spy.P6SpyDriver  # 替换为 p6spy 驱动
          username: root
          password: 123456
```

### spy.properties 配置（固定格式）

```properties
modulelist=com.baomidou.mybatisplus.extension.p6spy.MybatisPlusLogFactory,com.p6spy.engine.outage.P6OutageFactory
logMessageFormat=com.baomidou.mybatisplus.extension.p6spy.P6SpyLogger
appender=com.baomidou.mybatisplus.extension.p6spy.StdoutLogger
deregisterdrivers=true
useprefix=true
excludecategories=info,debug,result,commit,resultset
dateformat=yyyy-MM-dd HH:mm:ss
outagedetection=true
outagedetectioninterval=2  # 慢 SQL 阈值：2 秒，禁止随意修改
```

---

## 慢 SQL 阈值修改

```properties
# 默认 2 秒，修改为 3 秒
outagedetectioninterval=3

# 修改为 1 秒（更敏感）
outagedetectioninterval=1
```

日志输出：

```
 Consume Time: 2123 ms (超过阈值会标记为慢 SQL)
 [slow SQL] SELECT * FROM sys_user WHERE id = 1
```

---

## 常见错误和解决方案

**错误1** ❌：生产环境开启 p6spy

```yaml
# ⛔ 生产严禁！会导致性能严重下降
p6spy: true  # 仅开发、测试环境使用
```

**解决**：生产环境必须关闭

```yaml
# ✅ 生产环境
p6spy: false
```

---

**错误2** ❌：驱动配置错误，p6spy 日志打印不出来

```yaml
# ⛔ 混用驱动，p6spy 失效
driver-class-name: com.mysql.jdbc.Driver  # 原生驱动
```

**解决**：开启 p6spy 后必须替换为 p6spy 驱动

```yaml
# ✅ 正确！
driver-class-name: com.p6spy.engine.spy.P6SpyDriver
```

---

## 用途速查表

| 用途 | 配置 | 说明 |
|---|---|---|
| 查看执行的 SQL 语句 | 开启 p6spy | 打印原始 SQL 和参数 |
| 监控慢查询 | outagedetectioninterval | 默认 2 秒，超过则打印日志 |
| 测试性能 | 比较执行时间 | Consume Time 显示执行耗时 |
| 生产监控 | 关闭 p6spy，用数据库日志 | p6spy 影响性能，不推荐生产使用 |
