#!/usr/bin/env bash
# 智能预览脚本（来自 lf lfrc line 353-360）
# 支持编码转换

file="$1"

if [ -z "$file" ]; then
  echo "错误：未指定文件"
  exit 1
fi

# 如果有 nkf，使用它转换编码后预览
if command -v nkf >/dev/null 2>&1; then
  nkf -w "$file" | bat --color=always --paging=always --file-name="$file"
else
  bat --color=always --paging=always "$file"
fi
