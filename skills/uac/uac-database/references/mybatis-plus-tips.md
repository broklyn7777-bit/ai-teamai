# MyBatis-Plus 快速参考

## SQL 复用设计

### 如何设计可复用的联表查询

**常见错误** ❌：为每个接口单独写一遍联表 SQL

**正确做法** ✅：设计通用的联表查询方法

```java
// Mapper 接口定义
@Mapper
public interface UserMapper extends BaseMapper<User> {
    // 通用联表查询，支持多条件筛选
    List<UserOrgDTO> selectUserOrgList(@Param("qo") UserQueryObject qo);
}
```

```xml
<!-- Mapper XML -->
<resultMap id="userOrgMap" type="com.sf.gis.demo.dto.UserOrgDTO">
    <id column="user_id" property="userId"/>
    <result column="org_id" property="orgId"/>
    <result column="org_name" property="orgName"/>
</resultMap>

<select id="selectUserOrgList" resultMap="userOrgMap">
    SELECT u.id as user_id, o.id as org_id, o.org_name
    FROM sys_user u
    LEFT JOIN sys_org o ON u.org_id = o.id
    WHERE 1=1
    <if test="qo.orgId != null">
        AND u.org_id = #{qo.orgId}
    </if>
</select>
```

**核心原则**：复杂业务逻辑（联表、多条件聚合）必须在 XML 中设计成可复用的通用 SQL，避免为每个场景重复代码。

---

## 批量操作分批处理

### 批量删除（分批 ≤ 1000）

```java
private static final int BATCH_SIZE = 1000;

public void deleteUsers(List<Long> userIds) {
    if (userIds == null || userIds.isEmpty()) return;

    for (int i = 0; i < userIds.size(); i += BATCH_SIZE) {
        int end = Math.min(i + BATCH_SIZE, userIds.size());
        List<Long> batchIds = userIds.subList(i, end);
        userMapper.deleteBatchIds(batchIds);
    }
}
```

### 批量插入（分批 ≤ 1000）

```java
public void importUsers(List<User> users) {
    if (users == null || users.isEmpty()) return;
    // MyBatis-Plus 内置分批支持
    userMapper.saveBatch(users, BATCH_SIZE);
}
```

**关键**：超过 1000 条数据必须分批，否则导致内存溢出和数据库锁竞争。

---

## 简单查询用法

### 使用 default 方法实现简单查询

```java
@Mapper
public interface UserMapper extends BaseMapper<User> {

    // ✅ 简单查询用 default 方法
    default User selectByUserName(String userName) {
        return this.selectOne(Wrappers.<User>lambdaQuery()
                .eq(User::getUserName, userName));
    }

    // ✅ 直接使用 BaseMapper 内置方法
    // selectById()、selectList()、selectOne() 已内置
}
```

---

## 常见错误和解决方案

**错误1** ❌：在 Mapper 接口上添加 @Select 注解或 XML 自定义方法

```java
// ⛔ 禁止！
@Mapper
public interface SysConfigMapper extends BaseMapper<SysConfig> {
    @Select("SELECT * FROM sys_config WHERE config_key = #{key}")
    SysConfig selectByKey(@Param("key") String key);
}
```

**解决**：仅继承 BaseMapper，使用 default 方法

```java
// ✅ 正确！
@Mapper
public interface SysConfigMapper extends BaseMapper<SysConfig> {
    default SysConfig selectByKey(String confKey) {
        return this.selectOne(Wrappers.<SysConfig>lambdaQuery()
                .eq(SysConfig::getConfKey, confKey));
    }
}
```

---

**错误2** ❌：使用 ${} 拼接 SQL（导致 SQL 注入）

```java
// ⛔ 禁止！
@Select("SELECT * FROM sys_user WHERE user_name = ${userName}")
```

**解决**：必须使用 #{} 参数占位符

```java
// ✅ 正确！
@Select("SELECT * FROM sys_user WHERE user_name = #{userName}")
```

---

**错误3** ❌：结果集不使用 ResultMap，导致字段映射错乱

**解决**：所有查询都必须定义 ResultMap，显式指定列和属性的映射关系。
