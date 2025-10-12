#!/usr/bin/env bash
#
# Yazi 脚本: 对比两个文件 (nvim -d)
#
# 支持两种模式:
# 1. (同一 Tab): 空格选中 2 个文件, 按 'F'
# 2. (跨 Tab): Tab 1 用 'yp' 复制文件路径, Tab 2 选中文件, 按 'F'
#

# --- 中文提示 ---
MSG_ERROR="文件选择错误：必须恰好选择 2 个文件。"
MSG_USAGE="用法: \n  模式 A: 选中 2 个文件, 按 'F'\n  模式 B: 复制路径 (yp), 再选中 1 个文件, 按 'F'"
MSG_PRESS_ANY_KEY="（按任意键继续...）"

# 1. 获取当前选中的文件
selected_files=("$@")

# 2. 尝试从剪贴板获取路径（支持多种剪贴板工具）
clipboard_file=""
if command -v xclip &> /dev/null; then
    clipboard_file=$(xclip -selection clipboard -o 2>/dev/null)
elif command -v wl-paste &> /dev/null; then
    clipboard_file=$(wl-paste 2>/dev/null)
elif command -v pbpaste &> /dev/null; then
    clipboard_file=$(pbpaste 2>/dev/null)
elif command -v win32yank.exe &> /dev/null; then
    clipboard_file=$(win32yank.exe -o 2>/dev/null)
elif command -v powershell.exe &> /dev/null; then
    clipboard_file=$(powershell.exe -c "Get-Clipboard" 2>/dev/null | tr -d '\r')
fi

# 3. 收集所有文件
all_files=()

# 添加剪贴板中的文件（如果存在且是有效文件路径）
if [ -n "$clipboard_file" ] && [ -f "$clipboard_file" ]; then
    all_files+=("$clipboard_file")
fi

# 添加当前选中的文件
for file in "${selected_files[@]}"; do
    all_files+=("$file")
done

# 4. 去重（防止同一文件被选择两次）
unique_files=()
declare -A seen
for file in "${all_files[@]}"; do
    if [ -z "${seen[$file]}" ]; then
        unique_files+=("$file")
        seen[$file]=1
    fi
done

# 5. 检查文件数量
count=${#unique_files[@]}

if [ "$count" -ne 2 ]; then
    echo -e "$MSG_ERROR" >&2
    echo -e "$MSG_USAGE" >&2
    echo ""
    echo "当前识别到的文件数: $count"
    if [ "$count" -gt 0 ]; then
        echo "文件列表:"
        for f in "${unique_files[@]}"; do
            echo "  - $f"
        done
    fi
    echo ""
    echo -n "$MSG_PRESS_ANY_KEY"
    read -n 1 -s -r
    exit 1
fi

# 6. 提取文件并执行 nvim diff
file1="${unique_files[0]}"
file2="${unique_files[1]}"

echo "正在对比："
echo "  文件1: $file1"
echo "  文件2: $file2"
sleep 1

# 启动 nvim -d
nvim -d "$file1" "$file2"