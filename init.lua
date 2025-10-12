-- Yazi 初始化配置
-- 文档: https://yazi-rs.github.io/docs/configuration/overview

-- 启用 DDS 跨实例剪贴板同步
require("session"):setup {
	sync_yanked = true,
}

-- 配置 Git 状态显示图标（必须在 require 之前）
th.git = th.git or {}
-- 自定义状态符号（使用自定义插件，可区分staged和unstaged）
th.git.modified_sign = "●"   -- 未暂存的修改
th.git.staged_sign = "◆"     -- 已暂存的修改
th.git.added_sign = "✚"      -- 新增的文件（已暂存）
th.git.untracked_sign = "?"  -- 未跟踪的文件
th.git.deleted_sign = "✖"    -- 删除的文件
th.git.updated_sign = "!"    -- 冲突/未合并的文件
th.git.ignored_sign = ""     -- 被忽略的文件（不显示）

-- 自定义颜色
th.git.modified = ui.Style():fg("yellow")      -- 未暂存的修改（黄色）
th.git.staged = ui.Style():fg("cyan")          -- 已暂存的修改（青色）
th.git.added = ui.Style():fg("green")          -- 新增的文件（绿色）
th.git.untracked = ui.Style():fg("magenta")    -- 未跟踪的文件（洋红色）
th.git.deleted = ui.Style():fg("red")          -- 删除的文件（红色）
th.git.updated = ui.Style():fg("red"):bold()   -- 冲突的文件（粗红色）

-- 启用 Git 状态显示（使用自定义插件）
require("git-custom"):setup()
