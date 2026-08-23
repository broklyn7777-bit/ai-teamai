# Redis 基础配置

## 1. 依赖引入（禁止改版本）

```xml
<dependency>
    <groupId>com.orion.starters</groupId>
    <artifactId>orion-spring-boot-starter-redis</artifactId>
    <version>${revision}</version>
</dependency>
```

## 2. Redis 核心 yml 配置（生产严格照搬）

```yaml
orion:
  cache:
    primary: test                    # 默认Redis缓存分组名
    cache_mange:
      test:                          # 缓存分组标识
        cache_prefix: orion          # 强制配置Redis键前缀
        dynamic: true                # 动态创建Cache
        cache_null_values: true      # 强制开启空值缓存，防止穿透
        init_listener: false         # 按需开启监听
        
        # Caffeine本地缓存配置
        caffeine_cache:
          expire_after_access: 50s   # 访问后过期，禁止超1h
          expire_after_write: 60s    # 写入后过期，禁止超1h
          initial_capacity: 70
          maximum_size: 500          # 禁止超1000，避免OOM
        
        # Redis缓存通用配置
        redis_cache:
          default_expiration: 1h     # 全局默认过期时间，禁止永久缓存
          expires:
            auth_user: 10m           
            order_info: 30m          
          topic: cache:redis:caffeine:topic  # 缓存同步topic
        
        # Redis集群连接配置（生产禁用单机）
        redis:
          password: ${REDIS_PASSWORD}
          timeout: 10000
          cluster:
            nodes: ${REDIS_NODES}
            max-redirects: 5
          lettuce:
            pool:
              max-active: 300        # 禁止超500
              max-idle: 50           
              min-idle: 20           
              max-wait: 20000        
            cluster:
              refresh:
                adaptive: true       
                period: 30000
```

## 3. 标准 Redis 工具类用法

```java
// 推荐使用
RedisCacheImpl getRedisCache(String name)                       // 包装后的缓存对象
StringRedisCacheImpl getStrRedisCache(String name)              // 字符串缓存对象

// 查询单个数据源
RedisTemplate getRedisTemplate(String name)                    // 对象模式
StringRedisTemplate getStrRedisTemplate(String name)           // 字符串模式

// 按分组查询（支持模式匹配）
Map<String, RedisTemplate> getGroupRedisTemplate(String groupName)    // 如 "order"
Map<String, StringRedisTemplate> getStrGroupRedisTemplate(String groupName)

// 查询所有数据源
Map<String, RedisTemplate> getRedisTemplates()
Map<String, StringRedisTemplate> getStrRedisTemplateMap()
```

## 4. 动态加载 Redis

修改 redis 加载类型为 custom：

```yaml
orion:
  cache:
    primary: test
    type: custom
```

项目启动加载初始自定义配置：

```java
import com.google.common.collect.Lists;
import com.sf.gis.orion.cache.redis.support.AbstractCacheConfigService;
import com.sf.gis.orion.common.redis.constants.CacheConstant;
import com.sf.gis.orion.common.redis.util.RedisConfig;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class CustomCacheConfigService extends AbstractCacheConfigService {
    @Override
    protected List<RedisConfig> loadCacheConfig() {
        List<RedisConfig> redisConfigs = Lists.newArrayList();
        RedisConfig redisConfig = new RedisConfig();
        redisConfig.setGroupKey("cms_base");   // _分割符前为分组名
        redisConfig.setCachePrefix("cms");     // redis key前缀
        redisConfig.setRedisType(CacheConstant.REDIS_TYPE_CLUSTER);  // cluster/sentinel/host
        redisConfig.setUrl("${REDIS_URLS}");
        redisConfig.setPassword("${REDIS_PASSWORD}");
        redisConfigs.add(redisConfig);
        return redisConfigs;
    }
}
```
