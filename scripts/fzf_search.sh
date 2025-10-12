#!/usr/bin/env bash
# FZF 内容搜索脚本
# 从 lf lfrc 迁移而来

result=$(
  RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case"
  FZF_DEFAULT_COMMAND="$RG_PREFIX '^\s*$'" \
    fzf \
    --ansi \
    --bind "change:reload:$RG_PREFIX {q} || true" \
    --delimiter : \
    --preview 'file={1}; line={2}; if command -v nkf >/dev/null 2>&1; then nkf -w "$file" | bat --color=always --file-name="$file" --highlight-line "$line"; else bat --color=always "$file" --highlight-line "$line"; fi' \
    --preview-window 'down,60%,border-top,+{2}+3/3,~3' \
    --layout=reverse --header 'Search in files'
)

if [ -n "$result" ]; then
  file=$(echo "$result" | cut -d':' -f1)
  line=$(echo "$result" | cut -d':' -f2)
  $EDITOR "+$line" "$file"
fi
