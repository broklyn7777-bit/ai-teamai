---
name: uac-internationalization
description: |
  国际化专家。用于实现多语言支持和国际字符处理、管理多个时区、为 API 响应和错误消息配置本地化。
  覆盖通过远程 UAC 服务进行消息包配置、特定语言的格式化、时区在数据库和应用层的管理、客户端时区协调、I18nClass/I18nField 注解驱动翻译。
  触发关键词："国际化"、"多语言"、"i18n"、"Locale"、"消息文案"、"语言切换"、"时区"、"多语种"、"翻译"、"文案管理"、"I18nClass"、"I18nField"、"TIME-ZONE"、"Accept-Language"
compatibility: Requires orion-spring-boot-starter-i18n, Spring Messages MessageSource, UAC feign API for remote i18n config
---

# Skill: I18N-Development
# 适用场景：统一国际化管理，多时区处理，杜绝硬编码，简洁易用

## 一、核心触发场景

国际化、多语言、i18n、多时区、接口提示文案、异常信息、返回消息

## 二、核心规范要求

1. **禁止硬编码文案**：所有接口返回提示、异常信息、前端展示文案，禁止直接写死字符串，全部纳入国际化配置

2. **资源文件规范**：
    - 路径：resources/i18n/，文件名格式：messages_语言代码.properties

    - 默认语言：zh_CN（简体中文），必支持en_US（英文），按需扩展其他语言

    - 编码统一UTF-8，杜绝乱码

3. **文案Key命名**：**模块.功能.场景.含义**，小写英文+点，层级清晰，见名知意
   示例：common.param.invalid、user.login.success、order.pay.fail

## 三、使用规范

1. 后端通过请求Header的Accept-Language自动识别语言，无标识默认中文

2. 文案支持占位符，用{0}、{1}...传参，动态拼接参数，禁止字符串拼接硬编码

3. 全局异常处理、统一返回对象，全部调用国际化工具类获取文案

4. 新增文案必须同步维护所有语言配置，避免缺失导致返回Key原文

## 四、编码禁忌

1. 禁止Controller、Service层直接写中文/英文提示语

2. 禁止不同模块复用同一个Key，避免修改一处影响全局

3. 禁止资源文件缺失对应语言配置，导致文案展示异常

## 五、国际化核心使用约束
- **统一依赖**：复用框架 `orion-spring-boot-starter-i18n`，禁止自定义国际化工具类、手动处理多语言切换逻辑。

- **配置固定**：严格遵循框架yml配置模板，**禁止擅自修改basename、fallbackLanguageTag**，默认回退语言为zh-CN，严禁改动。

- **数据源统一**：通过UAC远程Feign接口获取全局国际化配置，禁止本地维护多语言properties文件，禁止硬编码多语言文案。

- **注解驱动**：需要国际化的实体类，必须添加 `@I18nClass` 标记类，翻译字段添加 `@I18nField` 并指定匹配条件，禁止手动赋值多语言字段。

- **全局联动**：国际化逻辑依托框架自动拦截处理，无需业务代码手动调用，自动适配请求头语言参数，保障全链路语言统一。

## 六、多时区核心使用约束
- **数据库时区统一**：JDBC连接串必须配置对应时区，**禁止使用serverTimezone=UTC**，国内业务默认Asia/Shanghai，海外业务按区域指定（如泰国GMT+7）。

- **时间类型固定**：后端时间入参、出参统一使用 `java.util.Date` 类型，禁止使用LocalDateTime、LocalDate等不带时区的类型，避免时区转换异常。

- **前端强制传时区**：前端每次请求必须在Header携带 `TIME-ZONE` 参数，框架自动拦截转换，后端无需手动处理时区换算。

- **全局转换**：依托框架全局时区拦截器，自动完成前端时区与数据库时区转换，业务代码禁止手写时区转换、时间计算逻辑。

### 国际化（标准化示例）
### 1. 依赖引入（禁止改版本）

```xml
<dependency>
	<groupId>com.orion.starters</groupId>
	<artifactId>orion-spring-boot-starter-i18n</artifactId>
	<version>${revision}</version>
</dependency>
```

### 2. yml核心配置（严格照搬）

```yml
spring:
  messages:
    basename: 'orion-*, org.springframework.security.messages, i18n.messages'

orion:
  i18n:
    fallbackLanguageTag: zh-CN
```

### 3. UAC远程国际化配置（固定写法）

```java
/**
 * 国际化自动配置类，固定注册CustomI18nMessageProvider，禁止自定义逻辑
 */
@AutoConfigureBefore({ I18nMessageSourceConfiguration.class, MessageEventListenerAutoConfiguration.class })
@MapperScan("com.sf.gis.orion.i18n.mapper")
@ComponentScan("com.sf.gis.orion.i18n")
@Configuration(proxyBeanMethods = false)
public class AdminI18nAutoConfiguration {

	@Bean
	@ConditionalOnMissingBean(I18nMessageProvider.class)
	public CustomI18nMessageProvider i18nMessageProvider(I18nFeignApi i18nFeignApi) {
		return new CustomI18nMessageProvider(i18nFeignApi);
	}

}

/**
 * 远程UAC国际化消息获取实现，禁止修改核心逻辑
 */
@Slf4j
public class CustomI18nMessageProvider implements I18nMessageProvider {

	private final I18nFeignApi i18nFeignApi;

	public CustomI18nMessageProvider(I18nFeignApi i18nFeignApi) {
		this.i18nFeignApi = i18nFeignApi;
	}

	@Override
	public I18nMessage getI18nMessage(String code, Locale locale) {
		String languageTag = locale.toLanguageTag();
		I18nMessage i18nMessage = null;
		// 远程调用UAC接口获取，禁止修改缓存及调用逻辑
		RestResponse<I18nData> i18nDataRestResponse = i18nFeignApi.queryByCode(code, languageTag);
		I18nData i18nData = null;
		if (i18nDataRestResponse.getSuccess()) {
			i18nData = i18nDataRestResponse.getResult();
			if (i18nData != null) {
				i18nMessage = converterToI18nMessage(i18nData);
			}
		}
		return i18nMessage;
	}

	/**
	 * 实体转换，固定写法，禁止扩展
	 */
	private I18nMessage converterToI18nMessage(I18nData i18nData) {
		I18nMessage i18nMessage = new I18nMessage();
		i18nMessage.setMessage(i18nData.getMessage());
		i18nMessage.setCode(i18nData.getCode());
		i18nMessage.setLanguageTag(i18nData.getLanguageTag());
		return i18nMessage;
	}

}
```

### 4. 实体注解用法（强制规范）

```java
/**
 * 需国际化的实体必须加@I18nClass，翻译字段加@I18nField
 */
@I18nClass
@Data
@ApiModel(value = "菜单权限分页视图对象")
public class SysMenuPageVO {

	/**
	 * 国际化字段，指定翻译生效条件，字段命名统一带i18n前缀
	 */
	@I18nField(condition = "type != 3")
	@ApiModelProperty(value = "菜单名称")
	private String i18nName;
	
}
```

### 多时区（标准化示例）
### 1. 数据库连接时区配置

```yml
# 国内标准时区
&serverTimezone=Asia/Shanghai
# 泰国时区示例
&serverTimezone=GMT%2B7
```

### 2. 后端时间字段规范

```java
/**
 * 时间字段统一使用Date/LocalDateTime/LocalDate类型，禁止使用string
 */
@ApiModelProperty(value = "创建时间")
private Date createTime;

@ApiModelProperty(value = "查询开始时间")
private Date startTime;
```

### 3. 前端请求头规范（强制）

```javascript
// 前端固定写法，每次请求携带TIME-ZONE请求头
let timeZone = Intl.DateTimeFormat().resolvedOptions().timeZone;  // 获取当前客户端时区
// 放入请求头，禁止遗漏
headers['TIME-ZONE'] = timeZone
```

## 🚫 红线禁忌

- 禁止数据库连接使用UTC时区，禁止随意修改项目默认时区配置。

- 禁止前端请求遗漏TIME-ZONE请求头，禁止手动调整时间值再传给后端。

- 时间字段传参统一使用Date/LocalDateTime/LocalDate类型，禁止使用string