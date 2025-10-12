#!/usr/bin/env bash
#
# Yazi 脚本: diff 文件选择
# s 键选中第一个文件，再按 s 选择第二个文件并对比
#

DIFF_FILE="/tmp/yazi_diff_file"
current_file="$1"

# 检查当前文件是否有效
if [[ -z "$current_file" || ! -f "$current_file" ]]; then
    echo "错误：请选择一个有效文件" >&2
    read -n 1 -s -r -p "按任意键继续..."
    exit 1
fi

# 检查是否已有选定的第一个文件
if [[ -f "$DIFF_FILE" ]]; then
    first_file=$(cat "$DIFF_FILE")

    # 检查第一个文件是否仍然存在
    if [[ -f "$first_file" ]]; then
        # 检查是否是同一个文件
        if [[ "$first_file" == "$current_file" ]]; then
            echo "提示：已选中此文件，请选择另一个文件进行对比" >&2
            read -n 1 -s -r -p "按任意键继续..."
            exit 0
        fi

        # 开始对比
        echo "对比: $(basename "$first_file") ↔ $(basename "$current_file")"
        rm -f "$DIFF_FILE"
        nvim -d "$first_file" "$current_file"
        exit 0
    fi
fi

# 保存当前文件为第一个选定文件
echo "$current_file" > "$DIFF_FILE"
echo "已选定: $(basename "$current_file")"
echo "再按 ; 选择第二个文件进行对比，按 : 取消选定"
sleep 1
