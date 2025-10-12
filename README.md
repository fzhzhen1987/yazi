# Yazi 配置

我的 Yazi 文件管理器配置，从 lf 迁移。版本: v25.5.31

## 文件结构

```
~/.config/yazi/
├── yazi.toml          # 主配置文件
├── keymap.toml        # 键位映射（ijkl导航）
├── theme.toml         # 主题配色
├── init.lua           # DDS跨实例剪贴板
├── yazi_config        # Shell wrapper (cd功能)
├── plugins/
│   ├── smart_enter.yazi/   # 智能进入/打开
│   └── ouch.yazi/          # 压缩解压
└── scripts/
    ├── fzf_jump.sh         # fzf快速跳转
    ├── fzf_file.sh         # fzf文件搜索
    ├── fzf_search.sh       # fzf内容搜索(rg)
    ├── smart_preview.sh    # 智能预览(nkf+bat)
    ├── chmod.sh            # 交互式权限修改
    └── tig.sh              # git状态查看
```

## 核心功能

### ijkl 导航（替代 hjkl）
- `i` - 上移
- `k` - 下移
- `j` - 返回上级目录
- `l` - 智能进入目录/打开文件

### 文件操作
- `dd` - 剪切文件
- `yy` - 复制文件
- `p` - 粘贴
- `D` - 删除（回收站）
- `M` - 创建目录
- `N` - 创建文件
- `C` - 修改权限（支持多文件）
- `r` - 重命名（光标在扩展名前）
- `A` - 重命名（光标在末尾）

### 搜索功能（fzf集成）
- `f` - fzf快速跳转（fd）
- `Ctrl-f` - fzf文件搜索（带预览）
- `Ctrl-g` - fzf内容搜索（rg）

### 显示控制
- `z` - 切换隐藏文件
- `ms` - 显示文件大小
- `mp` - 显示权限
- `mb` - 显示创建时间
- `mm` - 显示修改时间
- `mo` - 显示所有者
- `mn` - 隐藏额外信息

### 排序
- `,m/,M` - 按修改时间
- `,s/,S` - 按大小
- `,a/,A` - 按字母
- `,n/,N` - 按自然排序

### 其他功能
- `e` - 智能预览（全屏bat，支持日语编码）
- `T` - 使用tig查看git状态
- `Z` - 压缩成zip（ouch插件）
- `l` - 解压文件（在压缩包上按l）

## DDS 跨实例剪贴板

在 `init.lua` 中启用，多个yazi实例间共享剪贴板：

```lua
require("session"):setup {
	sync_yanked = true,
}
```

## Neovim 集成

使用 `Space+ra` 在浮动窗口中打开yazi（兼容Neovim 0.9.4）：

```lua
-- ~/.config/nvim/lua/plugins/yazi.lua
return {
  "DreamMaoMao/yazi.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
  },
  cmd = "Yazi",
  keys = {
    {
      "<leader>ra",
      "<cmd>Yazi<CR>",
      desc = "打开 yazi 浮动窗口",
    },
  },
}
```

## Shell 集成

在 `~/.zshrc` 中添加：

```bash
source ~/.config/yazi/yazi_config
alias ra="y"
```

使用 `ra` 命令启动yazi，退出后自动切换到当前目录。

## 特性说明

### 编码支持
所有shell脚本使用 `nkf -w` 处理日语编码，确保预览正常显示。

### 权限修改
`chmod.sh` 支持多文件选择，使用 `touch` 触发文件监视器，实时刷新显示。

### 键位设计
- `prepend_keymap` - 自定义键位（覆盖默认）
- `keymap` - 默认键位（被覆盖的已注释）

## 依赖工具

- `fd` - 文件查找
- `fzf` - 模糊搜索
- `ripgrep (rg)` - 内容搜索
- `bat` - 语法高亮预览
- `nkf` - 日语编码转换
- `tig` - git界面
- `ouch` - 压缩解压

## 文档

- [官方文档](https://yazi-rs.github.io/docs/)
- [默认配置](https://github.com/sxyazi/yazi/tree/shipped/yazi-config/preset)
- [插件仓库](https://github.com/yazi-rs/plugins)

## 版本信息

- Yazi: v25.5.31 (musl静态构建)
- 平台: Ubuntu 22.04 (WSL2)
- 迁移自: lf
