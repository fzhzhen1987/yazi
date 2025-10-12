#!/usr/bin/env bash
# 使用 tig 查看 git 状态

# 检查 tig 是否安装
if ! command -v tig >/dev/null 2>&1; then
  echo "错误: tig 未安装"
  echo "请运行: sudo apt install tig"
  exit 1
fi

# 检查是否在 git 仓库中
if ! git rev-parse --git-dir >/dev/null 2>&1; then
  echo "错误: 当前目录不是 git 仓库"
  exit 1
fi

# 启动 tig
tig
