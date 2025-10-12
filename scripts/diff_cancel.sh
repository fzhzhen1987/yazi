#!/usr/bin/env bash
#
# Yazi 脚本: 取消 diff 选定
#

DIFF_FILE="/tmp/yazi_diff_file"

if [[ -f "$DIFF_FILE" ]]; then
    selected=$(cat "$DIFF_FILE")
    rm -f "$DIFF_FILE"
    echo "已取消选定: $(basename "$selected")"
else
    echo "当前没有选定的文件"
fi
sleep 0.5
