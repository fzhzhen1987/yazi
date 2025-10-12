#!/usr/bin/env bash
# FZF 文件搜索脚本（yazi版本）

selected=$(find . \( -path '*/.*' -o -fstype 'dev' -o -fstype 'proc' \) -prune -o -print 2>/dev/null |
  sed 1d |
  cut -b3- |
  fzf +m \
    --preview 'if [ -d {} ]; then ls -la {}; else if command -v nkf >/dev/null 2>&1; then nkf -w {} | bat --color=always --file-name={}; else bat --color=always {}; fi; fi' \
    --preview-window 'down:60%:wrap')

if [ -n "$selected" ]; then
  # 转换为绝对路径
  selected=$(realpath "$selected")

  if [ -d "$selected" ]; then
    # 目录：切换到该目录
    ya emit cd "$selected"
  else
    # 文件：跳转到该文件所在目录并高亮
    ya emit reveal "$selected"
  fi
fi
