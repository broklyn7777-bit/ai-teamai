---
paths:
  - "**/*.java"
---

# Java Excel 处理规范

> 详细的代码模板、配置示例请参见 Skill `uac-excel-processing`。

## 🔴 核心禁忌

| 禁忌 | 正确做法 |
|---|---|
| POI 原生 SXSSF/XSSF | 统一使用 EasyExcel |
| 内存加载模式 | 监听器流式读写 |
| 导入导出无权限校验 | 必须校验登录态和业务权限 |
| IO 流手动关闭 | try-with-resources |
| 导入直接抛校验异常 | 收集全部错误统一返回 |
| 导出敏感数据不脱敏 | 手机号/身份证/银行卡强制脱敏 |
| 使用 `.xls` 格式 | 仅支持 `.xlsx` |

## 必守原则

1. **框架**：阿里 EasyExcel，orion-spring-boot-starter-easyexcel
2. **实体命名**：`XxxExcelDTO`/`XxxExcelVO`，存放于 `excel` 包下
3. **注解**：`@ExcelProperty` 指定列名+列索引
4. **数据量**：导出 ≤1万行，导入 ≤5000行
5. **导入注解**：`@RequestExcel`
6. **导出注解**：`@ResponseExcel`
7. **流式操作**：分页监听模式，每 500-1000 行批量入库

## 🔗 何时调用 uac-excel-processing Skill？

| 场景 | 用本文件 | 调用 Skill |
|------|---------|-----------|
| 查阅禁忌和快速规范 | ✅ | |
| 实现导入导出接口 | | ✅ |
| 自定义表头/复杂样式 | | ✅ |
| 大数据量分Sheet导出 | | ✅ |

完整指南：`skills/uac-excel-processing/SKILL.md`（5 个专题 + 2 个快速参考）
