local ui = {}
function ui.init(parent)
	-- Create member_cell
	local member_cell = GUI:Layout_Create(parent, "member_cell", 131.00, 380.00, 600.00, 38.00, false)
	GUI:setChineseName(member_cell, "队伍成员组合")
	GUI:setTouchEnabled(member_cell, true)
	GUI:setTag(member_cell, 49)

	-- Create Image_leader
	local Image_leader = GUI:Image_Create(member_cell, "Image_leader", 0.00, 19.00, "res/public/1900000678.png")
	GUI:Image_setScale9Slice(Image_leader, 26, 76, 5, 19)
	GUI:setContentSize(Image_leader, 600, 38)
	GUI:setIgnoreContentAdaptWithSize(Image_leader, false)
	GUI:setChineseName(Image_leader, "加入队伍_选中_图片")
	GUI:setAnchorPoint(Image_leader, 0.00, 0.50)
	GUI:setTouchEnabled(Image_leader, false)
	GUI:setTag(Image_leader, 50)

	-- Create Image_5
	local Image_5 = GUI:Image_Create(Image_leader, "Image_5", 20.00, 20.00, "res/private/team/1900014001.png")
	GUI:setChineseName(Image_5, "加入队伍_队长_图片")
	GUI:setAnchorPoint(Image_5, 0.50, 0.50)
	GUI:setTouchEnabled(Image_5, false)
	GUI:setTag(Image_5, 63)

	-- Create Image_4
	local Image_4 = GUI:Image_Create(member_cell, "Image_4", 300.00, 20.00, "res/private/team/1900014010.png")
	GUI:setChineseName(Image_4, "加入队伍_装饰条图片")
	GUI:setAnchorPoint(Image_4, 0.50, 0.50)
	GUI:setTouchEnabled(Image_4, false)
	GUI:setTag(Image_4, 62)

	-- Create Label_name
	local Label_name = GUI:Text_Create(member_cell, "Label_name", 94.00, 20.00, 16, "#ffffff", [[玩家名字七个字]])
	GUI:setChineseName(Label_name, "加入队伍_名称_文本")
	GUI:setAnchorPoint(Label_name, 0.50, 0.50)
	GUI:setTouchEnabled(Label_name, false)
	GUI:setTag(Label_name, 51)
	GUI:Text_enableOutline(Label_name, "#111111", 1)

	-- Create Label_job
	local Label_job = GUI:Text_Create(member_cell, "Label_job", 215.00, 20.00, 16, "#ffffff", [[战士]])
	GUI:setChineseName(Label_job, "加入队伍_职业_文本")
	GUI:setAnchorPoint(Label_job, 0.50, 0.50)
	GUI:setTouchEnabled(Label_job, false)
	GUI:setTag(Label_job, 52)
	GUI:Text_enableOutline(Label_job, "#111111", 1)

	-- Create Label_level
	local Label_level = GUI:Text_Create(member_cell, "Label_level", 293.00, 20.00, 16, "#ffffff", [[等级]])
	GUI:setChineseName(Label_level, "加入队伍_等级_文本")
	GUI:setAnchorPoint(Label_level, 0.50, 0.50)
	GUI:setTouchEnabled(Label_level, false)
	GUI:setTag(Label_level, 53)
	GUI:Text_enableOutline(Label_level, "#111111", 1)

	-- Create Label_guild
	local Label_guild = GUI:Text_Create(member_cell, "Label_guild", 402.00, 20.00, 16, "#ffffff", [[行会名字七个字]])
	GUI:setChineseName(Label_guild, "加入队伍_行会_文本")
	GUI:setAnchorPoint(Label_guild, 0.50, 0.50)
	GUI:setTouchEnabled(Label_guild, false)
	GUI:setTag(Label_guild, 54)
	GUI:Text_enableOutline(Label_guild, "#111111", 1)

	-- Create Label_map
	local Label_map = GUI:Text_Create(member_cell, "Label_map", 535.00, 20.00, 16, "#ffffff", [[地图名字七个字]])
	GUI:setChineseName(Label_map, "加入队伍_地图_文本")
	GUI:setAnchorPoint(Label_map, 0.50, 0.50)
	GUI:setTouchEnabled(Label_map, false)
	GUI:setTag(Label_map, 55)
	GUI:Text_enableOutline(Label_map, "#111111", 1)
end
return ui