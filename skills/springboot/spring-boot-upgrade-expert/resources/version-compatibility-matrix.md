# Spring 生态版本对齐矩阵

> 按需读取。确保升级 Spring Boot 时，相关生态组件版本正确对齐。

## Spring Boot 3.x 版本对齐表

| Spring Boot | Spring Framework | Spring Cloud | Spring Cloud Alibaba | JDK 最低 |
|-------------|-----------------|--------------|---------------------|---------|
| 3.0.x | 6.0.x | 2022.0.x | 2022.0.x | 17 |
| 3.1.x | 6.0.x | 2022.0.x | 2022.0.x | 17 |
| 3.2.x | 6.1.x | 2023.0.x | 2023.0.x | 17 |
| 3.3.x | 6.1.x | 2023.0.x | 2023.0.x | 17 |
| 3.4.x | 6.2.x | 2024.0.x | 2024.0.x | 17 |
| **3.5.x** | **6.2.x** | **2025.0.x** | **2025.0.0.0** | **17** |

## 本项目使用版本（Spring Boot 3.5.0）

| 组件 | 版本 | 备注 |
|------|------|------|
| Spring Boot | 3.5.0 | |
| Spring Framework | 6.2.x (由 Boot 管理) | |
| Spring Cloud | 2025.0.1 | |
| Spring Cloud Alibaba | 2025.0.0.0 | |
| Spring Security | 6.x (由 Boot 管理) | |
| Spring Authorization Server | 1.4.2 | |
| MyBatis-Plus | 3.5.15 | |
| ShardingSphere | 5.5.3 | |
| Jackson | 2.18.4 | |
| Druid | 1.2.27 | |
| HttpClient | 5.4.2 | |
| Hutool | 5.8.36 | |
| MapStruct | 1.6.3 | |
| Lombok | 1.18.36 | |
| springdoc-openapi | 2.8.9 | |
| Logback | 1.5.18 | |
| Jasypt | 3.0.5 | |
| Redisson | 3.22.0 | |
| RocketMQ | 5.3.0 | |
| XXL-Job | 2.3.0 | |
| EasyExcel | 4.0.3 | |
| Tianai Captcha | 1.5.5 | |

## 不兼容组件记录

| 组件 | 旧版本 | 状态 | 原因 | 替代方案 |
|------|--------|------|------|----------|
| Knife4j | 4.5.0 | 注释排除 | 与 Spring Boot 3.5 不兼容 | springdoc 原生 UI |
| ES Client | 7.8.0 | 注释排除 | 内部依赖 HttpClient 4.x | ES 8.x Java Client |
| Springfox | 2.x/3.x | 已移除 | 不支持 Jakarta | springdoc 2.8.9 |
| spring-security-oauth2 | 2.5.2 | 已移除 | 停止维护 | SAS 1.4.2 |
| Spring Social | 1.1.6 | 已移除 | 不支持 Spring Security 6 | 重写为 OAuth2 Client |
