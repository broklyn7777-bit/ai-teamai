# 发布订阅缓存同步

## 发布缓存更新消息

```java
@Service
public class RouterConfigService {
    @Autowired
    private RedisTemplate<String, Object> redisTemplate;
    
    public void updateRouterConfig(Long routerId) {
        // 数据库更新
        baseMapper.updateById(routerConfig);
        
        // 发布同步消息（参数精简，仅传必要字段）
        BaseMap params = new BaseMap();
        params.put("handlerName", "routerConfigRefreshHandler");
        params.put("routerId", routerId);
        
        redisTemplate.convertAndSend("cache:router:topic", params);
    }
}
```

## 订阅消息处理

```java
@Slf4j
@Component("routerConfigRefreshHandler")
public class RouterConfigRefreshHandler implements MyRedisListener {
    @Autowired
    private RedisCacheImpl redisCache;
    
    @Override
    public void onMessage(BaseMap params) {
        log.info("收到缓存刷新事件: {}", params);
        Long routerId = params.getLong("routerId");
        String cacheKey = "router:config:" + routerId;
        redisCache.del(cacheKey);
        log.info("缓存刷新完成: {}", routerId);
    }
}
```

**注意**：监听类 `handlerName` 与消息中对应，精准匹配。
