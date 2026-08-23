---
name: uac-file-storage
description: |
  文件存储安全卫士。用于实现文件上传/下载功能、配置分布式文件存储、设计安全的文件处理模式、管理文件访问控制和生命周期。
  覆盖 OSS（对象存储服务）集成、路径穿越防护、文件类型验证、大小限制、基于权限的访问控制、使用时间限制链接的防盗链策略、大文件断点续传支持。
  触发关键词："文件上传"、"文件下载"、"附件"、"图片上传"、"文件校验"、"大文件分片"、"文件安全"、"OSS"、"断点续传"、"文件管理"、"防盗链"、"签名链接"、"UUID重命名"、"魔数校验"、"路径穿越"
compatibility: Requires orion-spring-boot-starter-filestore, Distributed Storage (SOSS/OSS/FTP), Spring Web MVC
---

# Skill: FILE-UPLOAD-DOWNLOAD-Development
# 适用场景：聚焦文件上传下载、安全、合规、性能管控，规避漏洞与风险，基础框架已内置文件存储常用功能

## 一、核心触发场景

文件上传、文件下载、附件上传、图片上传、文件校验、大文件分片、文件安全

## 二、强制基础规范（阿里安全硬性要求）

1. **文件存储规范**：禁止存储到应用服务器本地目录，统一使用分布式文件存储（OSS），避免服务器磁盘爆满、服务不可用

2. **文件命名规范**：文件名禁止中文、特殊字符、空格、相对路径符号（../、./），后台统一重命名为UUID+原始后缀，原始文件名仅做展示，防止路径穿越漏洞

3. **路径规范**：采用**业务域/模块/日期/随机文件名**分层存储，示例：user/avatar/20260321/uuid_avatar.png，禁止固定硬编码路径

## 三、上传核心规范（安全优先）

1. **类型校验**：双重校验文件格式，前端校验后缀+后端校验文件头魔数，禁止仅校验后缀，杜绝恶意文件上传（如jsp、exe、php等可执行文件）

2. **大小限制**：单文件默认限制≤50MB，图片类≤10MB，大文件强制走分片上传，禁止超大文件直接上传占用带宽

3. **请求约束**：配置全局上传大小上限，禁用默认无限制配置；上传接口必须做登录权限校验，敏感文件额外做业务权限校验

4. **并发管控**：单用户单次上传文件数≤5个，防止恶意批量上传挤占资源，上传超时强制断开连接

5. **临时文件**：上传过程产生的临时文件，操作完成后立即删除，禁止残留占用存储空间

## 四、下载核心规范

1. **权限校验**：下载接口必须校验用户登录态与文件归属权限，禁止直接暴露文件物理路径，通过后端流输出文件

2. **防盗链处理**：私有文件生成带时效签名的下载链接，链接有效期≤30分钟，禁止永久有效下载链接

3. **响应头配置**：下载接口设置正确Content-Type、Content-Disposition，避免浏览器直接解析执行文件，防止XSS与文件解析风险

4. **断点续传**：大文件下载支持断点续传，配置合理缓冲区大小，避免内存溢出，下载异常关闭流并释放资源

## 五、编码禁忌与异常处理

1. 禁止直接使用用户传入的文件名、文件路径存储，杜绝路径穿越、文件覆盖漏洞

2. 禁止上传接口不做权限校验，允许匿名用户随意上传文件

3. 禁止文件IO流不关闭、不释放资源，必须用try-with-resources语法自动关闭流

4. 文件上传下载异常必须捕获，返回标准化提示，不暴露底层存储异常信息，同步打印日志便于排查

5. 禁止返回文件物理路径、存储密钥等敏感信息给前端

## 🚫 红线禁忌

- ⛔ 禁止直接使用用户传入的文件名存储到服务器，必须使用UUID或系统生成的唯一标识，杜绝路径穿越和文件覆盖漏洞
- ⛔ 禁止上传文件接口缺少权限验证和用户身份校验，严禁匿名用户随意上传文件
- ⛔ 禁止文件IO操作不使用try-with-resources，必须确保流及时关闭，防止资源泄漏
- ⛔ 禁止文件上传下载异常直接抛出，所有异常必须被捕获并返回标准化错误提示，不能暴露底层存储细节
- ⛔ 禁止返回文件存储物理路径、OSS密钥、Access Key等敏感信息给前端

## 六、核心使用约束
- **统一依赖**：复用框架 `orion-spring-boot-starter-filestore`，禁止新增文件存储相关依赖、手写上传下载工具类。

- **存储类型**：支持disk/ftp/sftp/soss四种模式，**项目统一指定单一存储类型**，禁止混用多类型，优先使用soss对象存储。

- **配置规范**：yml配置严格遵循框架模板，**禁止随意修改临时目录、文件大小限制、存储路径**，密钥等敏感配置禁止硬编码，按需接入配置中心。

- **表结构固定**：使用框架指定 `sys_file` 表，**严禁修改字段、主键、唯一索引**，del_flag逻辑删除、tenant_id/client_id租户应用字段必填。

- **接口复用**：禁止自定义文件上传下载接口，**直接调用框架内置接口**，统一入口、统一日志、统一权限控制。

### 文件上传、下载（标准化示例）
### 1. 依赖引入（复用框架，禁止改版本）

```xml
<dependency>
	<groupId>com.orion.starters</groupId>
	<artifactId>orion-spring-boot-starter-filestore</artifactId>
	<version>${orion-version}</version>
</dependency>
```

### 2. yml核心配置（严格对齐，禁止乱改参数）

```yml
orion:
  store:
    #文件存储临时目录
    tempDir: /app/temp/
    type: soss # 全局统一存储类型，禁止混用
    # soss对象存储（生产优先）
    soss:
      username: ${orion.store.soss.username}
      ak: ${orion.store.soss.ak}
      account: ${orion.store.soss.account}
      userKey: ${orion.store.soss.userKey}
      serverUrl: ${orion.store.soss.serverUrl}
      container: aoi
```

### 3. 固定表结构（禁止擅自变更）

```sql
CREATE TABLE `sys_file` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `file_id` varchar(32) NOT NULL COMMENT '文件ID',
  `file_name` varchar(255) NOT NULL COMMENT '文件名称',
  `file_url` varchar(255) DEFAULT NULL COMMENT '文件url',
  `file_path` varchar(255) DEFAULT NULL COMMENT '文件path',
  `file_type` int(11) DEFAULT NULL COMMENT '文件类型 1:图片 2:视频 3:其他文件',
  `file_privacy` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1:private 0:public',
  `extension` varchar(10) NOT NULL COMMENT '文件扩展名',
  `del_flag` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1:删除 0:未删除',
  `version` bigint(20) NOT NULL DEFAULT '1',
  `client_id` varchar(50) DEFAULT NULL COMMENT '应用ID',
  `tenant_id` bigint(20) DEFAULT NULL COMMENT '租户ID',
  `create_by` varchar(50) DEFAULT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_by` varchar(50) DEFAULT NULL,
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `file_id` (`file_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统文件管理表';
```

### 4. 内置接口调用（禁止自定义接口）

> 💡 所有文件操作直接调用框架内置接口，无需手写Controller、Service逻辑，自动关联sys_file表、记录操作日志、校验权限
>

- 图片上传：`/fileStore/uploadImg`

- 附件上传：`/fileStore/uploadAttachment`

- 文件/图片下载：`/fileStore/download`

- 文件删除（逻辑删除）：`/fileStore/deleteFile`


