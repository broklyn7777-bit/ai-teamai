#!/usr/bin/env bash
# check-javax-remaining.sh
# 检查项目中是否还有 javax.* 命名空间残留（排除 JDK 标准库）
#
# 用法: bash check-javax-remaining.sh [搜索路径]
# 默认搜索路径: 当前目录
#
# 返回值:
#   0 - 未发现残留
#   1 - 发现残留

SEARCH_PATH="${1:-.}"

# 排除的 JDK 标准库包
EXCLUDE_PATTERN="javax\.crypto\|javax\.net\|javax\.sql\|javax\.management\|javax\.xml\|javax\.swing\|javax\.imageio\|javax\.security\|javax\.naming"

echo "=== Jakarta 命名空间残留检查 ==="
echo "搜索路径: $SEARCH_PATH"
echo ""

RESULTS=$(grep -r "import javax\." --include="*.java" "$SEARCH_PATH" | grep -v "$EXCLUDE_PATTERN")

if [ -z "$RESULTS" ]; then
    echo "✅ 未发现 javax 残留（JDK 标准库除外）"
    exit 0
else
    echo "❌ 发现 javax 残留："
    echo "$RESULTS"
    echo ""
    echo "总计: $(echo "$RESULTS" | wc -l) 处残留"
    exit 1
fi
