#!/usr/bin/env bash
# FZF 快速跳转脚本（yazi版本）

selected=$(fd --hidden --follow -E .git -E node_modules -E .ccls-cache . |
  fzf --reverse --header='Jump to location' \
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
