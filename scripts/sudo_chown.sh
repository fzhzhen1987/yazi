#!/usr/bin/env bash
# 使用 sudo 修改文件所有者和组（支持多文件）

# 获取所有选中的文件
files=("$@")

if [ ${#files[@]} -eq 0 ]; then
  echo "错误：未指定文件"
  exit 1
fi

# 显示要修改的文件
echo "选中的文件:"
for file in "${files[@]}"; do
  current_owner=$(stat -c "%U:%G" "$file" 2>/dev/null)
  echo "  $file (当前: $current_owner)"
done

echo ""
echo "输入新的所有者 (格式示例):"
echo "  user           - 只改用户"
echo "  user:group     - 改用户和组"
echo "  :group         - 只改组"
echo -n "新所有者: "
read new_owner

if [ -n "$new_owner" ]; then
  success_count=0
  fail_count=0

  for file in "${files[@]}"; do
    sudo chown "$new_owner" "$file"
    if [ $? -eq 0 ]; then
      # 递归处理目录
      if [ -d "$file" ]; then
        echo -n "是否递归修改目录 $file? (y/N): "
        read recursive
        if [[ "$recursive" =~ ^[Yy]$ ]]; then
          sudo chown -R "$new_owner" "$file"
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
