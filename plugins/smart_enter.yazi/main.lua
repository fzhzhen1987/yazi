-- Smart Enter 插件 (v25.5.31)
-- 根据文件类型智能选择行为：
-- - 目录 → 进入目录 (enter)
-- - 文件 → 打开文件 (open)

local state = ya.sync(function()
	local h = cx.active.current.hovered
	if h then
		return h.cha.is_dir
	end
	return false
end)

return {
	entry = function()
		local is_dir = state()
		if is_dir then
			ya.emit("enter", {})
		else
			ya.emit("open", {})
		end
	end,
}
