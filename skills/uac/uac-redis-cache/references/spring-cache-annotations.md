# Spring Cache 注解标准用法

## 1. Caffeine 配置

```yaml
caffeine_cache:
  expire_after_access: 50s   # 最后一次访问后过期，禁止超1h
  expire_after_write: 60s    # 最后一次写入后过期，禁止超1h
  initial_capacity: 70
  maximum_size: 500          # 严格控制防OOM，禁止超1000
```

## 2. @Cacheable 读取缓存（查询场景）

```java
@Service
public class SysOrganizationService {
    @Cacheable(
        cacheManager = "testCacheManager",
        value = "ORG_CACHE",
        key = "'org:' + #id",
        unless = "#result == null"
    )
    @Override
    public SysOrganization queryById(Long id) {
        return baseMapper.selectById(id);
    }
}
```

## 3. @CacheEvict 清除缓存

```java
// 单条清除
@CacheEvict(cacheManager = "testCacheManager", value = "ORG_CACHE", key = "'org:' + #orgId")
public boolean deleteOrganization(Long orgId) { ... }

// 全量清除（仅批量更新场景使用）
@CacheEvict(cacheManager = "testCacheManager", value = "ORG_CACHE", allEntries = true)
public void clearAllOrgs() { }
```

## 4. @Caching 组合操作

```java
@Caching(
    cacheManager = "testCacheManager",
    evict = {
        @CacheEvict(value = "ORG_CACHE", allEntries = true),
        @CacheEvict(value = "ORG_CHILD_CACHE", allEntries = true)
    }
)
public boolean updateOrganization(SysOrganization org) { ... }
```

## 5. @CachePut 写入不查询

```java
@CachePut(cacheManager = "testCacheManager", value = "USER_CACHE", key = "'user:' + #result.id")
public User saveUser(User user) {
    baseMapper.insert(user);
    return user;
}
```

## 6. 缓存常量类

```java
public class CacheConstants {
    public static final String ROLE_CACHE_NAME = "ROLE_CACHE";
    public static final String ORG_CACHE_NAME = "ORG_CACHE";
    public static final String USER_CACHE_NAME = "USER_CACHE";
}
```

## 7. 过期时间 Provider

```java
@Component("testRedisCacheConfigurationProvider")
public class TestRedisCacheConfigurationProvider 
    extends RedisHelper.RedisCacheConfigurationProvider {
    @Override
    protected void initConfigs() {
        this.configs = Maps.newHashMap();
        this.configs.put(CacheConstants.ROLE_CACHE_NAME, Duration.ofSeconds(30));
        this.configs.put(CacheConstants.ORG_CACHE_NAME, Duration.ofHours(2));
        this.configs.put(CacheConstants.USER_CACHE_NAME, Duration.ofHours(1));
    }
}
```

**红线禁忌**：
- 禁止注解省略 `cacheManager`、`key` 无意义、不配置 `unless` 空值过滤
- 禁止同类内部方法调用注解缓存（切面失效）
- 禁止滥用 `allEntries = true` 全量清除
