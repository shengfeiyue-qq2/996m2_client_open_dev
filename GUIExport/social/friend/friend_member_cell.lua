local ui = {}
function ui.init(parent)
	-- Create member_cell
	local member_cell = GUI:Layout_Create(parent, "member_cell", 0.00, 0.00, 600.00, 38.00, false)
	GUI:setChineseName(member_cell, "好友表头_组合")
	GUI:setTouchEnabled(member_cell, true)
	GUI:setTag(member_cell, 71)

	-- Create Text_name
	local Text_name = GUI:Text_Create(member_cell, "Text_name", 86.00, 20.00, 16, "#ffffff", [[角色六字名称]])
	GUI:setChineseName(Text_name, "好友表头_名字_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 0.50)
	GUI:setTouchEnabled(Text_name, true)
	GUI:setTag(Text_name, 72)
	GUI:Text_enableOutline(Text_name, "#111111", 1)

	-- Create Text_job
	local Text_job = GUI:Text_Create(member_cell, "Text_job", 215.00, 20.00, 16, "#ffffff", [[战士]])
	GUI:setChineseName(Text_job, "好友表头_职业_文本")
	GUI:setAnchorPoint(Text_job, 0.50, 0.50)
	GUI:setTouchEnabled(Text_job, false)
	GUI:setTag(Text_job, 74)
	GUI:Text_enableOutline(Text_job, "#111111", 1)

	-- Create Text_level
	local Text_level = GUI:Text_Create(member_cell, "Text_level", 295.00, 20.00, 16, "#ffffff", [[1 转 499级]])
	GUI:setChineseName(Text_level, "好友表头_等级_文本")
	GUI:setAnchorPoint(Text_level, 0.50, 0.50)
	GUI:setTouchEnabled(Text_level, false)
	GUI:setTag(Text_level, 73)
	GUI:Text_enableOutline(Text_level, "#111111", 1)

	-- Create Text_guild
	local Text_guild = GUI:Text_Create(member_cell, "Text_guild", 402.00, 20.00, 16, "#ffffff", [[行会名字七个字]])
	GUI:setChineseName(Text_guild, "好友表头_行会_文本")
	GUI:setAnchorPoint(Text_guild, 0.50, 0.50)
	GUI:setTouchEnabled(Text_guild, false)
	GUI:setTag(Text_guild, 75)
	GUI:Text_enableOutline(Text_guild, "#111111", 1)

	-- Create Text_online
	local Text_online = GUI:Text_Create(member_cell, "Text_online", 531.00, 20.00, 16, "#ffffff", [[在线]])
	GUI:setChineseName(Text_online, "好友表头_状态_文本")
	GUI:setAnchorPoint(Text_online, 0.50, 0.50)
	GUI:setTouchEnabled(Text_online, false)
	GUI:setTag(Text_online, 76)
	GUI:Text_enableOutline(Text_online, "#111111", 1)

	-- Create Image_line
	local Image_line = GUI:Image_Create(member_cell, "Image_line", 300.00, 20.00, "res/private/team/1900014010.png")
	GUI:setChineseName(Image_line, "好友表头_装饰条")
	GUI:setAnchorPoint(Image_line, 0.50, 0.50)
	GUI:setTouchEnabled(Image_line, false)
	GUI:setTag(Image_line, 77)
end
return ui