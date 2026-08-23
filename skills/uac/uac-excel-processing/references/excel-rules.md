# Excel 导入导出标准示例

## 1. 依赖引入

```xml
<dependency>
    <groupId>com.orion.starters</groupId>
    <artifactId>orion-spring-boot-starter-easyexcel</artifactId>
    <version>${orion-version}</version>
</dependency>
```

## 2. Excel 映射实体

```java
@Data
@ApiModel(value = "业务线Excel映射对象")
public class BusinessDataExcelVO implements Serializable {
    private static final long serialVersionUID = 1L;

    @ExcelProperty(value = "一级业务线名称", index = 0)
    private String pname;

    @ExcelProperty(value = "二级业务线名称", index = 1)
    private String name;

    @ExcelProperty(value = "二级部门", index = 2)
    private String orgName;

    @ExcelProperty(value = "自有人数", index = 5)
    private Integer ownNum;
}
```

## 3. 导入接口（@RequestExcel）

```java
@PostMapping("/import")
public RestResponse<?> importBusinessData(@RequestExcel List<BusinessDataExcelVO> excelVos) {
    return RestResponse.ok(businessDataService.batchSave(excelVos));
}
```

## 4. 导出接口（@ResponseExcel）

```java
@ResponseExcel(name = "业务线")
@GetMapping("/export")
public List<BusinessDataExcelVO> exportBusinessData(FsBusinessPageQo qo) {
    return businessDataService.queryList(qo);
}
```

## 5. 自定义表头

```java
@Component
public class DetailStatsHeadGenerator implements HeadGenerator {
    @Override
    public HeadMeta head(Class<?> aClass) {
        HeadMeta headMeta = new HeadMeta();
        headMeta.setHead(head());
        return headMeta;
    }

    private List<List<String>> head() {
        List<List<String>> titles = Lists.newArrayList();
        // 按层级定义表头
        titles.add(Lists.newArrayList("单位：万元", "单位：万元", "总投入"));
        // ... 其余表头
        return titles;
    }
}

@ResponseExcel(name = "统计", headGenerator = DetailStatsHeadGenerator.class)
@GetMapping("/export-stats")
public List<BusinessStatsExcelVO> exportStats() { ... }
```
