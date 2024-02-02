local ui = {}
function ui.init(parent)
	-- Create member_cell
	local member_cell = GUI:Layout_Create(parent, "member_cell", 0.00, 0.00, 200.00, 50.00, false)
	GUI:setChineseName(member_cell, "组队成员组合")
	GUI:setTouchEnabled(member_cell, true)
	GUI:setTag(member_cell, -1)

	-- Create Image_job
	local Image_job = GUI:Image_Create(member_cell, "Image_job", 25.00, 30.00, "res/private/main/assist/1900012536.png")
	GUI:setChineseName(Image_job, "队员_职业_图片")
	GUI:setAnchorPoint(Image_job, 0.50, 0.50)
	GUI:setTouchEnabled(Image_job, false)
	GUI:setTag(Image_job, -1)

	-- Create Text_level
	local Text_level = GUI:Text_Create(member_cell, "Text_level", 25.00, 10.00, 16, "#ffffff", [[Lv:%s]])
	GUI:setChineseName(Text_level, "队员_等级_文本")
	GUI:setAnchorPoint(Text_level, 0.50, 0.50)
	GUI:setTouchEnabled(Text_level, false)
	GUI:setTag(Text_level, -1)
	GUI:Text_enableOutline(Text_level, "#000000", 1)

	-- Create Text_name
	local Text_name = GUI:Text_Create(member_cell, "Text_name", 115.00, 35.00, 16, "#ffffff", [[我是玩家名字名字]])
	GUI:setChineseName(Text_name, "队员_昵称_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 0.50)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, -1)
	GUI:Text_enableOutline(Text_name, "#000000", 1)

	-- Create Image_hp
	local Image_hp = GUI:Image_Create(member_cell, "Image_hp", 115.00, 20.00, "res/private/main/assist/1900012530.png")
	GUI:setContentSize(Image_hp, 132, 8)
	GUI:setIgnoreContentAdaptWithSize(Image_hp, false)
	GUI:setChineseName(Image_hp, "队员_Hp_边框")
	GUI:setAnchorPoint(Image_hp, 0.50, 0.50)
	GUI:setTouchEnabled(Image_hp, false)
	GUI:setTag(Image_hp, -1)

	-- Create LoadingBar_hp
	local LoadingBar_hp = GUI:LoadingBar_Create(member_cell, "LoadingBar_hp", 115.00, 20.00, "res/private/main/assist/1900012532.png", 0)
	GUI:setContentSize(LoadingBar_hp, 130, 6)
	GUI:setIgnoreContentAdaptWithSize(LoadingBar_hp, false)
	GUI:LoadingBar_setPercent(LoadingBar_hp, 100)
	GUI:LoadingBar_setColor(LoadingBar_hp, "#ffffff")
	GUI:setChineseName(LoadingBar_hp, "队员_Hp值")
	GUI:setAnchorPoint(LoadingBar_hp, 0.50, 0.50)
	GUI:setTouchEnabled(LoadingBar_hp, false)
	GUI:setTag(LoadingBar_hp, -1)

	-- Create Image_mp
	local Image_mp = GUI:Image_Create(member_cell, "Image_mp", 115.00, 10.00, "res/private/main/assist/1900012530.png")
	GUI:setContentSize(Image_mp, 132, 8)
	GUI:setIgnoreContentAdaptWithSize(Image_mp, false)
	GUI:setChineseName(Image_mp, "队员_Mp_边框")
	GUI:setAnchorPoint(Image_mp, 0.50, 0.50)
	GUI:setTouchEnabled(Image_mp, false)
	GUI:setTag(Image_mp, -1)

	-- Create LoadingBar_mp
	local LoadingBar_mp = GUI:LoadingBar_Create(member_cell, "LoadingBar_mp", 115.00, 10.00, "res/private/main/assist/19000125321.png", 0)
	GUI:LoadingBar_setPercent(LoadingBar_mp, 100)
	GUI:setChineseName(LoadingBar_mp, "队员_Mp值")
	GUI:setAnchorPoint(LoadingBar_mp, 0.50, 0.50)
	GUI:setTouchEnabled(LoadingBar_mp, false)
	GUI:setTag(LoadingBar_mp, -1)

	-- Create Image_leader
	local Image_leader = GUI:Image_Create(member_cell, "Image_leader", 200.00, 50.00, "res/private/main/assist/19000125322.png")
	GUI:setChineseName(Image_leader, "队员_队长标识_图片")
	GUI:setAnchorPoint(Image_leader, 1.00, 1.00)
	GUI:setTouchEnabled(Image_leader, false)
	GUI:setTag(Image_leader, -1)

	-- Create Text_status
	local Text_status = GUI:Text_Create(member_cell, "Text_status", 115.00, 15.00, 18, "#ffffff", [[远离]])
	GUI:setChineseName(Text_status, "队员_距离状态_文本")
	GUI:setAnchorPoint(Text_status, 0.50, 0.50)
	GUI:setTouchEnabled(Text_status, false)
	GUI:setTag(Text_status, -1)
	GUI:Text_enableOutline(Text_status, "#000000", 1)
end
return ui