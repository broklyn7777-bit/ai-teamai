---
name: uac-schedule-tasks
description: |
  分布式调度专家。用于实现分布式定时任务、配置 Cron 表达式、设计分片策略以支持跨多个实例的并行任务执行、管理任务生命周期和重试策略。
  提供 Saturn 框架集成模式、任务实现指南、命名空间和监控配置、全面的作业治理标准以实现容错和执行跟踪、用户上下文设置。
  触发关键词："定时任务"、"Saturn"、"分布式调度"、"Cron"、"JobBean"、"分片"、"广播"、"任务调度"、"分片处理"、"故障转移"、"任务重试"、"AbstractSaturnJavaJob"、"handleJavaJob"、"setSystemTaskAuth"、"作业治理"
compatibility: Requires saturn-spring 3.6.9.SF.RELEASE+, ZooKeeper coordination, Spring TaskScheduler, Saturn Console access
---

# Skill: Saturn-Development
# 适用场景：聚焦Saturn定时任务、分布式调度、分片处理、幂等机制、故障转移、最佳实践，无冗余内容，直接落地

## 一、核心触发场景

定时任务、Saturn、分布式调度、Cron表达式、分片处理、任务分片、广播任务、重复执行防护、幂等设计、故障转移、任务重试、重试策略、执行时间控制、资源竞争、任务治理、作业监控、调度告警、多实例协调


## 二、核心使用规范（必遵守）

- **统一依赖**：强制使用指定版本Saturn依赖，禁止私自升级、降级版本或引入其他定时任务框架（如Quartz、XXL-Job），杜绝依赖冲突。

- **配置集中化**：Saturn控制台地址、命名空间等核心参数统一通过yml配置，禁止硬编码，接入配置中心统一管理，不同环境（开发/测试/生产）配置严格隔离。

- **类规范**：定时任务实现类必须继承`AbstractSaturnJavaJob`，重写指定任务方法，交由Spring容器管理（添加@Component注解），禁止匿名任务、非托管类实现任务。

- **分片与隔离**：分布式场景强制使用分片机制，避免多实例重复执行；任务命名语义化，禁止无意义命名，便于控制台监控与运维排查。

- **异常与日志**：任务内部必须捕获业务异常，规范返回执行结果，日志完整打印执行开始、结束、异常信息，禁止静默失败、无日志执行。

- **模式固定**：默认关闭多实例模式，按需开启标准输出，类加载器使用当前类加载器，禁止随意修改核心调度参数。

- **权限与管控**：定时任务统一在Saturn控制台配置调度策略，禁止代码硬编码cron表达式，任务执行权限受控，仅管理员可调整调度规则。



## 极简落地模板
### Saturn定时任务 （标准化示例）

#### 1 依赖引入规范

严格使用指定版本依赖，版本号统一维护在properties标签内，禁止直接写死版本号，便于后续统一升级管理，依赖直接加入项目pom.xml文件，禁止排除核心依赖。

```xml
<properties>
    <saturn.version>3.6.9.SF.RELEASE</saturn.version>
</properties>

<dependency>
    <groupId>com.vip.saturn</groupId>
    <artifactId>saturn-spring</artifactId>
    <version>${saturn.version}</version>
</dependency>
```

#### 2 YAML核心配置规范

配置项固定前缀为`saturnjob`，控制台地址与命名空间严格按照环境分配填写，禁止随意修改，命名空间遵循项目业务域规范，确保全局唯一，避免跨项目任务冲突。

```yaml
saturnjob:
  # Saturn控制台地址，不同环境配置对应域名，禁止混用测试与生产地址
  consoleURI: http://ujp.intsit.sfcloud.local:1080
  # 任务命名空间，遵循项目-应用-业务域规范，全局唯一
  appnamespace: GIS-ASS-AOS-ATLAS
```

#### 3 核心配置类实现规范

新建独立配置类，统一注册SaturnJobMain实例到Spring容器，绑定yml配置参数，配置类添加@Configuration、@ConfigurationProperties注解，固定参数配置，禁止额外扩展无关逻辑，类命名遵循SaturnJobConfig规范，便于快速定位。

```java
import com.vip.saturn.job.spring.SaturnJobMain;
import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * 定时任务核心配置类
 * 绑定Saturn控制台与命名空间配置，注册核心调度Bean
 *
 * @author TDDC
 * @version 1.0
 */
@Configuration
@ConfigurationProperties(prefix = "saturnjob")
@Data
public class SaturnJobConfig {

	/**
	 * Saturn控制台访问地址
	 */
	private String consoleURI;

	/**
	 * 任务所属命名空间
	 */
	private String appnamespace;

	/**
	 * 注册Saturn核心调度主类，固定参数配置，禁止随意修改
	 * @return 初始化完成的SaturnJobMain实例
	 */
	@Bean
	public SaturnJobMain createSaturnJobMain() {
		SaturnJobMain saturnJobMain = new SaturnJobMain();
		// 绑定控制台地址
		saturnJobMain.setSaturnConsoleURI(consoleURI);
		// 绑定命名空间
		saturnJobMain.setSaturnAppNamespace(appnamespace);
		// 开启标准输出，便于日志排查
		saturnJobMain.setSaturnStdout(true);
		// 关闭多实例模式，按需开启
		saturnJobMain.setMultiMode(false);
		// 指定类加载器，固定使用当前类加载器
		saturnJobMain.setClassLoader(this.getClass().getClassLoader());
		return saturnJobMain;
	}

}
```

#### 4 定时任务实现类规范

所有业务定时任务必须单独新建实现类，继承`AbstractSaturnJavaJob`，重写`handleJavaJob`方法，交由Spring容器管理，通过@Resource注入业务Service，禁止在任务类内写核心业务逻辑，统一做任务调度与业务逻辑解耦；任务执行结果必须规范返回，日志完整打印，异常主动捕获，避免任务中断。

```java
import com.github.pagehelper.Page;
import com.sf.framework.domain.Result;
import com.sf.test.model.DemoUser;
import com.sf.test.model.DemoUserExample;
import com.sf.test.service.DemoUserService;
import com.vip.saturn.job.AbstractSaturnJavaJob;
import com.vip.saturn.job.SaturnJobExecutionContext;
import com.vip.saturn.job.SaturnJobReturn;
import com.vip.saturn.job.SaturnSystemErrorGroup;
import com.vip.saturn.job.SaturnSystemReturnCode;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;

/**
 * 业务定时任务实现类
 * 继承AbstractSaturnJavaJob，重写任务执行方法
 * 类命名：业务含义+SaturnJavaJob，语义清晰
 *
 * @author TDDC
 * @version 1.0
 */
@Slf4j
@Component
public class DemoUserSyncSaturnJavaJob extends AbstractSaturnJavaJob {

    /**
     * 注入业务Service，禁止手写业务逻辑
     */
    @Resource
    private DemoUserService demoUserService;

    @Autowired
    UserTheadLocalUtil userTheadLocalUtil;

    /**
     * 定时任务核心执行入口，固定方法签名，禁止修改
     * @param jobName 任务名称，控制台配置对应名称
     * @param shardItem 分片项，分布式分片标识
     * @param shardParam 分片参数，控制台可配置
     * @param shardingContext 任务执行上下文
     * @return 任务执行结果，规范返回状态与信息
     * @throws InterruptedException 中断异常，必须处理
     */
    @Override
    public SaturnJobReturn handleJavaJob(String jobName, Integer shardItem, String shardParam,
                                         SaturnJobExecutionContext shardingContext) throws InterruptedException {
        log.info("【定时任务{}】执行开始，分片项：{}，分片参数：{}", jobName, shardItem, shardParam);
        SaturnJobReturn jobReturn = new SaturnJobReturn();
        //设置用户上下文
        userTheadLocalUtil.setSystemTaskAuth();
        try {
            // 执行业务逻辑，禁止在任务类内写复杂逻辑
            DemoUserExample example = new DemoUserExample();
            Result<Page<DemoUser>> queryResult = demoUserService.selectByExample(example, 1, 100);
            // 规范返回执行结果
            jobReturn.setReturnCode(SaturnSystemReturnCode.SYSTEM_SUCCESS);
            jobReturn.setErrorGroup(SaturnSystemErrorGroup.SUCCESS);
            jobReturn.setReturnMsg("任务执行成功，共查询到用户数据：" + queryResult.getObj().getTotal() + "条");
            log.info("【定时任务{}】执行结束，执行结果：成功", jobName);
        } catch (Exception e) {
            // 捕获全局异常，避免任务崩溃，记录异常日志
            log.error("【定时任务{}】执行异常，异常信息：", jobName, e);
            jobReturn.setReturnCode(SaturnSystemReturnCode.SYSTEM_FAIL);
            jobReturn.setErrorGroup(SaturnSystemErrorGroup.FAIL);
            jobReturn.setReturnMsg("任务执行失败，异常原因：" + e.getMessage());
        }
        return jobReturn;
    }
}
```

## 🚫 红线禁忌

- ⛔ 禁止使用非指定版本Saturn依赖，禁止引入其他定时任务框架，禁止手写线程池实现本地定时任务。

- ⛔ 禁止硬编码控制台地址、命名空间、cron表达式，所有调度规则必须在Saturn控制台配置，代码无侵入。

- ⛔ 禁止定时任务类不继承AbstractSaturnJavaJob、不添加@Component注解，禁止非Spring托管类作为任务执行类。

- ⛔ 禁止任务内部不捕获异常、不打印执行日志，禁止静默执行、失败无反馈，导致任务异常无法排查。

- ⛔ 禁止在定时任务内写复杂业务逻辑、大数据量无分页处理，避免任务执行超时、占用过多服务资源。

- 禁止分布式场景下不使用分片机制，多实例重复执行任务，禁止随意修改SaturnJobMain核心配置参数。

- **【强制】定时任务实现类必须在handleJavaJob方法开始处设置用户信息**：通过`userTheadLocalUtil.setSystemTaskAuth()`为当前线程设置系统任务执行权限上下文，确保任务执行时拥有完整的用户身份与权限。禁止跳过该步骤，违反此规则导致的权限不足问题由开发人员承担责任。

## 扩展资源

了解更多Saturn定时任务框架详情，请参考 [VIP官方文档](https://vipshop.github.io/Saturn/#/zh-cn/3.x/)