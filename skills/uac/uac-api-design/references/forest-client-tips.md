# 外部接口调用规范（Forest）

## 一、强制要求
1. 统一使用 `forest-spring-boot-starter` 组件调用外部接口，禁止使用 HttpClient / RestTemplate 等其他客户端
2. 版本统一在父 POM 中维护，禁止在子模块中指定版本

## 二、依赖引入

```xml
<dependency>
    <groupId>com.dtflys.forest</groupId>
    <artifactId>forest-spring-boot-starter</artifactId>
    <version>${forest.version}</version>
</dependency>
```

## 三、接口定义规范

1. 使用接口类定义远程调用，禁止使用具体实现类
2. 接口类名命名：`{业务名}Client`（如 `GisApiClient`）
3. 放置于 `{module}-biz` 模块的 `remote` 包下：`com.sf.gis.xxx.remote`
4. 使用 `@BaseRequest` 注解配置基础 URL，必须从配置中读取（禁止硬编码）

```java
@BaseRequest(baseURL = "#{orion.demo.gisApi}")
public interface GisApiClient {

    @Post("/geo/api")
    GeoVo queryGeoApi(@Header("ak") String ak, @Body GeoQo geoQo);

    @Get(url = "/geo/encode", connectTimeout = 5000, readTimeout = 10000)
    GeoVo encodeAddress(@Query("city") String city, @Query("address") String address);
}
```

## 四、参数与返回值规范

- 请求参数使用 `Qo` 后缀，返回数据使用 `Vo` 后缀
- 必须使用包装类型（避免基本类型）；复杂对象使用静态内部类定义

```java
@Data
public class GeoQo {
    private String address;
    private String city;
    private String ak;
}

@Data
public class GeoVo {
    private Integer status;
    private List<GeoInfo> result;

    @Data
    public static class GeoInfo {
        private Double xcoord;
        private Double ycoord;
        private String adcode;
    }
}
```

## 五、配置管理规范

```yaml
# application-dev.yml
orion:
  demo:
    gisApi: http://api.location.example.com
    gisAk: ${GIS_API_KEY}

forest:
  connect-timeout: 5000
  read-timeout: 10000
```

- 外部接口 URL 和敏感信息必须通过配置中心管理（`application-{env}.yml`）
- 禁止硬编码 URL、API Key、密钥等敏感信息
- 使用 SpEL 表达式 `#{...}` 动态注入
- 关键参数（如 API Key）优先使用 Header 方式传递

## 六、超时与重试配置

- 必须显式设置连接超时（推荐 5s）和读超时（推荐 10s）
- **非幂等操作禁止重试**；幂等操作可设置重试次数（推荐 3 次）
- 使用 Forest 内置重试机制，禁止自定义重试逻辑

```java
@BaseRequest(baseURL = "#{orion.demo.paymentApi}")
public interface PaymentClient {

    // 幂等操作：可重试 3 次
    @Post(url = "/orders/create", connectTimeout = 5000, readTimeout = 10000,
          retryCount = 3, retryInterval = 1000)
    @Header("Authorization: Bearer #{orion.demo.paymentSecret}")
    PaymentVo createOrder(@Body CreateOrderQo orderQo);

    // 纯查询：禁止重试
    @Get(url = "/orders/{orderId}", connectTimeout = 3000, readTimeout = 5000)
    PaymentVo queryOrder(@PathVariable("orderId") String orderId);
}
```

## 七、异常与日志规范

- 捕获远程调用异常，统一转换为业务异常（复用异常处理规范）
- 禁止将远程服务异常直接向上游暴露；必须记录调用日志（参数、耗时、异常堆栈）

```java
@Slf4j
@Service
public class GeoService {

    @Autowired
    private GisApiClient gisApiClient;

    @Value("${orion.demo.gisAk}")
    private String gisAk;

    public GeoVo queryGeoInfo(String address, String city) {
        long startTime = System.currentTimeMillis();
        try {
            log.info("调用地理信息查询 API，address: {}, city: {}", address, city);
            GeoQo geoQo = new GeoQo();
            geoQo.setAddress(address);
            geoQo.setCity(city);
            geoQo.setAk(gisAk);

            GeoVo result = gisApiClient.queryGeoApi(gisAk, geoQo);

            long costTime = System.currentTimeMillis() - startTime;
            log.info("地理信息查询成功，耗时: {} ms，结果数: {}",
                costTime, result.getResult() != null ? result.getResult().size() : 0);
            return result;
        } catch (Exception e) {
            long costTime = System.currentTimeMillis() - startTime;
            log.error("地理信息查询失败，耗时: {} ms", costTime, e);
            throw new BusinessException(GeoCodeEnum.GEO_API_CALL_FAILED, e.getMessage());
        }
    }
}
```
