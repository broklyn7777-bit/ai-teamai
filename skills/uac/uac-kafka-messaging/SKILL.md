---
name: uac-kafka-messaging
description: |
  消息队列专家。用于实现 Kafka 消息队列、设计生产者/消费者架构、配置最佳实践、实现可靠消息投递。
  聚焦 Kafka 使用规范、Topic/消费者组命名、消息体设计、核心配置约束、编码禁忌、消息重试与死信队列。
  触发关键词："Kafka"、"消息队列"、"生产者"、"消费者"、"Topic"、"消息投递"、"Kafka配置"、"消费者组"、"消息重试"、"死信队列"、"消息幂等"、"消息追踪"、"bizId"、"traceId"
compatibility: Requires sf-kafka-api-core 1.20.3+, Kafka broker 2.5.1+
---

# Kafka 消息队列实践指南

## 一、核心触发场景

Kafka、消息队列、生产者、消费者、消息投递、Topic 命名、消费者组、消息路由

## 二、强制命名规范（必须遵守）

### 1. Topic 命名
- 格式：**业务域_模块_功能**（大写英文 + 下划线）或 **业务域-模块-功能**（小写英文 + 横杠）
- 遵循 sf-kafka 框架规范：Topic 需配套 **校验码**（Token），防止配置错误
- 示例：
  - `GIS_AOI_CONFIG:BDwPiWPf`（大写格式 + 校验码）
  - `user-register-notice`（小写格式，如无校验码）
  - `order-pay-success`

### 2. 消费者组命名：业务域-模块-consumer
- 同一业务消费逻辑共用一个组，避免重复消费/漏消费
- 示例：`user-register-consumer`、`order-pay-consumer`、`aoi-config-consumer`

### 3. 消息 Key 命名：业务域:模块:ID
- 保证同一业务按顺序消费，分区路由用
- 示例：`order:pay:20240321001`、`user:register:1001`

## 三、Kafka 核心约束

### 1. 统一依赖管理
- 禁止原生引入 spring-kafka、librdkafka 等，通过 sf-kafka 框架集成
- 所有 Kafka 连接参数、Topic、消费者组、线程数配置统一在 yml 配置中心，禁止硬编码
- 敏感信息（密码、broker地址）接入配置中心占位符

### 2. 消息体必需字段
消息基类必须包含：
- `bizId`：业务唯一ID（用于消费端幂等去重、追踪）
- `createTime`：消息创建时间戳(ms)（用于链路追踪、消费时效性）
- `traceId`：链路追踪ID（关联系统间日志）

可选字段：
- `bizType`：业务类型(枚举值)
- `source`：消息来源系统
- `remark`：备注信息
- `version`：消息版本（向后兼容）

### 3. 消息大小限制
- 单条消息建议 ≤ 100KB，绝对不超过 1MB
- 大文件走文件服务，消息中仅存储地址引用

## 四、极简落地示例

### 1. 依赖引入

```xml
<!-- Kafka依赖 -->
<sf-kafka-version>1.20.3</sf-kafka-version>
<kafka-client-version>2.5.1</kafka-client-version>

<dependency>
  <groupId>org.apache.kafka</groupId>
  <artifactId>kafka-clients</artifactId>
  <version>2.5.1</version>
</dependency>
<dependency>
  <groupId>com.sf.kafka</groupId>
  <artifactId>sf-kafka-api-core</artifactId>
  <version>${sf-kafka-version}</version>
</dependency>
<dependency>
  <groupId>com.sf.kafka</groupId>
  <artifactId>sf-kafka-api-check-valid</artifactId>
  <version>${sf-kafka-version}</version>
</dependency>
```

### 2. Kafka yml 配置

```yaml
kafka:
  # 生产者配置（Map 结构，key 为分组名称）
  producer:
    config:                                       # 生产者分组名称（对应 KafkaConst.PRODUCER_CONFIG_NAME）
      enable: true                               # 是否启用
      poolSize: 10                               # 生产者线程池大小
      clusterName: default-cluster               # Kafka集群名称
      topicTokens: "GIS_AOI_CONFIG:BDwPiWPf"    # Topic:校验码 格式，单个Topic
      monitorUrl: "http://kafka-monitor:8080"   # Kafka监控平台URL
  # 消费者配置（Map 结构，key 为分组名称）
  consumer:
    config:                                       # 消费者分组名称（对应 KafkaConst.CONSUMER_CONFIG_NAME）
      enable: true                               # 是否启用
      topic: GIS_AOI_CONFIG                      # 消费的Topic名称
      systemIdToken: "GIS_ASS_AOS:peMERUZd"      # 消费组Token
      messageConsumeThreadCount: 3               # 消费线程数(≤Topic分区数)
      clusterName: default-cluster               # Kafka集群名称
      monitorUrl: "http://kafka-monitor:8080"   # Kafka监控平台URL
```

### 3. Kafka 配置 DTO 类

**生产者配置 DTO（ConsumerKafkaConfig.java）：**

```java
@Data
public class ConsumerKafkaConfig {
    private Boolean enable;
    private String systemIdToken;
    private String monitorUrl;
    private String clusterName;
    private String topic;
    private Integer messageConsumeThreadCount;
}
```

**消费者配置 DTO（ProducerKafkaConfig.java）：**

```java
@Data
public class ProducerKafkaConfig {
    private Boolean enable;
    private Integer poolSize;
    private String monitorUrl;
    private String clusterName;
    private String topicTokens;
}
```

**主配置绑定（KafkaSettingConfig.java）：**

```java
@Configuration
@ConfigurationProperties(prefix = "kafka")
@Data
public class KafkaSettingConfig {
    private Map<String, ProducerKafkaConfig> producer;
    private Map<String, ConsumerKafkaConfig> consumer;
}
```

> 使用 `Map<String, XxxConfig>` 结构，key 为分组名称（如 `config`），通过 `KafkaConst.PRODUCER_CONFIG_NAME` / `KafkaConst.CONSUMER_CONFIG_NAME` 获取。

### 4. Kafka Topic 常量管理

```java
public class KafkaConst {
    // Producer config names
    public static final String PRODUCER_CONFIG_NAME = "config";

    // Consumer config names
    public static final String CONSUMER_CONFIG_NAME = "config";
}
```

### 5. Kafka Spring 配置类（核心注册模式）

**使用 `@ConfigurationProperties` + `@Bean` 模式注册生产者和消费者：**

```java
@Configuration
@RequiredArgsConstructor
public class KafkaServiceConfig {

    private final KafkaSettingConfig kafkaSettingConfig;

    // 注入你的业务服务
    private final ISysConfigService sysConfigService;

    @Bean(name = "sysConfigKafkaProducer")
    @ConditionalOnProperty(name = "kafka.producer.config.enable", havingValue = "true", matchIfMissing = true)
    public KafkaTemplate sysConfigKafkaProducer() {
        Map<String, ProducerKafkaConfig> producerMap = kafkaSettingConfig.getProducer();
        if (producerMap == null || producerMap.isEmpty()) {
            throw new RuntimeException("Kafka producer config not found. Check kafka.producer configuration in yml");
        }
        ProducerKafkaConfig config = producerMap.get(KafkaConst.PRODUCER_CONFIG_NAME);
        if (config == null || !config.getEnable()) {
            throw new RuntimeException("Kafka producer config is disabled or not found. Check kafka.producer.config.enable=true");
        }
        ProduceConfig produceConfig = new ProduceConfig(config.getPoolSize(), config.getMonitorUrl(),
                config.getClusterName(), config.getTopicTokens());
        return new KafkaTemplate(produceConfig);
    }

    @Bean(name = "sysconfigKafkaListener")
    @ConditionalOnProperty(name = "kafka.consumer.config.enable", havingValue = "true", matchIfMissing = true)
    public BaseConsumeListener sysconfigKafkaListener() {
        Map<String, ConsumerKafkaConfig> consumerMap = kafkaSettingConfig.getConsumer();
        if (consumerMap == null || consumerMap.isEmpty()) {
            throw new RuntimeException("Kafka consumer config not found. Check kafka.consumer configuration in yml");
        }
        ConsumerKafkaConfig config = consumerMap.get(KafkaConst.CONSUMER_CONFIG_NAME);
        if (config == null || !config.getEnable()) {
            throw new RuntimeException("Kafka consumer config is disabled or not found. Check kafka.consumer.config.enable=true");
        }
        // 构建 ConsumeConfig：systemIdToken, monitorUrl, clusterName, topic, threadCount
        ConsumeConfig consumeConfig = new ConsumeConfig(config.getSystemIdToken(), config.getMonitorUrl(),
                config.getClusterName(), config.getTopic(), config.getMessageConsumeThreadCount());
        // 创建消费者实例（通过构造函数注入业务依赖）
        SysConfigChangeListener listener = new SysConfigChangeListener(sysConfigService);
        // 注册消费组
        listener.register(consumeConfig);
        return listener;
    }
}
```

> **关键点**：
> - `@ConditionalOnProperty` 控制 producer/consumer 是否启用
> - 配置缺失或禁用时抛出 RuntimeException 快速失败
> - `ConsumeConfig` 构造函数 5 个参数：`systemIdToken, monitorUrl, clusterName, topic, messageConsumeThreadCount`
> - `ProduceConfig` 构造函数 4 个参数：`poolSize, monitorUrl, clusterName, topicTokens`
> - 消费者通过构造函数注入业务服务依赖

### 6. Kafka 消息基类

```java
@Data
@AllArgsConstructor
@NoArgsConstructor
public class BaseKafkaMessage {
    private String bizId;              // 业务唯一ID，必需
    private Long createTime;           // 消息创建时间戳(ms)，必需
    private String traceId;            // 链路追踪ID，必需
    private String bizType;            // 业务类型(可选)
    private String source;             // 消息来源系统(可选)
    private String remark;             // 备注(可选)
    private String version = "v1";     // 消息版本(可选)

    public static BaseKafkaMessage create(String bizId) {
        BaseKafkaMessage msg = new BaseKafkaMessage();
        msg.setBizId(bizId);
        msg.setCreateTime(System.currentTimeMillis());
        msg.setTraceId(MDC.get("traceId"));
        return msg;
    }
}

@Data
@EqualsAndHashCode(callSuper = true)
public class OrderNoticeMessage extends BaseKafkaMessage {
    private Long orderId;
    private Long userId;
    private BigDecimal amount;
    private String orderStatus;
    private Long createTime;
}
```

### 7. Kafka 生产者工具类

```java
@Slf4j
public class KafkaTemplate extends ProducerPool {

    private ProduceConfig config;

    public KafkaTemplate(ProduceConfig produceConfig) {
        super(produceConfig);
        this.config = produceConfig;
    }

    public void send(String message) {
        String topic = config.getTopicTokens().split(":")[0];
        log.info("=>kafka topic: " + topic + ",message:" + message);
        this.sendString(topic, message);
    }

    public void sendListData(List<String> messages) {
        String topic = config.getTopicTokens().split(":")[0];
        log.info("kafka topic " + topic + ",message:" + messages);
        this.batchSendString(topic, messages);
    }

}
```

**生产者发送示例：**

```java
// 发送单条消息
OrderNoticeMessage message = new OrderNoticeMessage();
message.setBizId("order_20240322_001");
message.setOrderId(12345L);
message.setUserId(6789L);
message.setAmount(new BigDecimal("99.99"));
message.setOrderStatus("PAID");
message.setCreateTime(System.currentTimeMillis());

kafkaTemplate.send(JacksonUtil.toJson(message));
```

### 8. Kafka 消费者基类

```java
@Slf4j
public abstract class BaseConsumeListener implements IStringMessageConsumeListener {

    public void register(ConsumeConfig consumeConfig) {
        try {
            KafkaConsumerRegister.registerStringConsumer(consumeConfig, this);
        }
        catch (Throwable e) {
            log.error("Listener failed to be register ", e);
        }
    }

    public abstract void onMessage(List<String> values) throws KafkaConsumeRetryException;

}
```

### 9. 具体消费者实现示例

```java
public class SysConfigChangeListener extends BaseConsumeListener {

    private static Logger logger = LoggerFactory.getLogger(SysConfigChangeListener.class);

    private ISysConfigService sysConfigService;

    public SysConfigChangeListener(ISysConfigService sysConfigService) {
        this.sysConfigService = sysConfigService;
    }

    @Override
    public void onMessage(List<String> values) throws KafkaConsumeRetryException {
        logger.info("SysConfigChangeListener receive kafka data:{}", values.toString());
        for (String msg : values) {
            try {
                logger.info("Processing message: {}", msg);
                sysConfigService.processConfigChange(msg);
            }
            catch (Exception e) {
                logger.error("Failed to process kafka message: {}", msg, e);
            }
        }
        logger.info("SysConfigChangeListener kafka receive success");
    }

}
```

> **注意**：消费者通过构造函数注入业务服务依赖，在 `KafkaServiceConfig` 中完成装配。
> 消息处理逻辑必须在 try-catch 块内，异常不得抛出消费线程。

## 六、标准项目结构

按照以下目录结构组织 Kafka 相关代码：

```
kafka/
├── constant/
│   └── KafkaConst.java              # 常量定义（PRODUCER_CONFIG_NAME / CONSUMER_CONFIG_NAME）
├── config/
│   ├── ConsumerKafkaConfig.java     # 消费者配置 DTO
│   ├── ProducerKafkaConfig.java     # 生产者配置 DTO
│   ├── KafkaSettingConfig.java      # @ConfigurationProperties 主配置
│   └── KafkaServiceConfig.java      # @Bean 注册 + 消费者初始化
├── consumer/
│   ├── BaseConsumeListener.java     # 抽象基类（register + onMessage）
│   └── XxxConsumerListener.java     # 具体消费者实现（继承 BaseConsumeListener）
└── producer/
    └── KafkaTemplate.java           # 生产者工具类（继承 ProducerPool）
```

## 七、🚫 红线禁忌（必须遵守）

1. **⛔ 禁止手动创建 KafkaProducer/KafkaConsumer**，必须通过框架 ProducerPool/IStringMessageConsumeListener
2. **⛔ 禁止消费线程内抛异常**，所有异常必须内部捕获处理，防止消费线程中断
3. **⛔ 禁止消息体无 bizId**，无法实现去重、无法追踪溯源
4. **⛔ 禁止硬编码 Topic 名称、消费者组**，所有常量必须在 KafkaConst 统一管理
5. **⛔ 禁止单条消息体超过 1MB**，超大对象导致网络缓慢、内存溢出
6. **⛔ 禁止消费线程数超过 Topic 分区数**，多余线程无法分配分区，浪费资源
7. **⛔ 禁止生产环境使用单 Broker 部署**，单点故障导致消息丢失
8. **⛔ 禁止消费处理逻辑超过 session.timeout.ms**，导致消费者被剔除
9. **⛔ 禁止在消费线程内同步调用第三方接口**，应异步处理或交由线程池
10. **⛔ 禁止消费者未订阅 Topic 就启动**，导致消费线程空转浪费资源
