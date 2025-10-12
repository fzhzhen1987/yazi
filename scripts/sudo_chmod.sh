#!/usr/bin/env bash
# 使用 sudo 修改文件权限（支持多文件）

# 获取所有选中的文件
files=("$@")

if [ ${#files[@]} -eq 0 ]; then
  echo "错误：未指定文件"
  exit 1
fi

# 显示要修改的文件
echo "选中的文件:"
for file in "${files[@]}"; do
  current=$(stat -c "%a" "$file" 2>/dev/null)
  echo "  $file (当前: $current)"
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "权限说明:"
echo "  u=所有者  g=组  o=其他人  (省略=所有人)"
echo "  r=读(4)  w=写(2)  x=执行(1)"
echo "  +=添加  -=移除  =设置"
echo ""
echo "示例: +x  u+x  go-w  755  644"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -n "新权限 (数字或符号): "
read new_mode

if [ -n "$new_mode" ]; then
  success_count=0
  fail_count=0

  for file in "${files[@]}"; do
    sudo chmod "$new_mode" "$file"
    if [ $? -eq 0 ]; then
      # 递归处理目录
      if [ -d "$file" ]; then
        echo -n "是否递归修改目录 $file? (y/N): "
        read recursive
        if [[ "$recursive" =~ ^[Yy]$ ]]; then
          sudo chmod -R "$new_mode" "$file"
        fi
      fi
      ((success_count++))
    else
      echo "修改失败: $file"
      ((fail_count++))
    fi
  done

  echo "完成: 成功 $success_count 个, 失败 $fail_count 个"
fi
