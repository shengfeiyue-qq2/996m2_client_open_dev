local ui = {}
function ui.init(parent)
	-- Create member_cell
	local member_cell = GUI:Layout_Create(parent, "member_cell", 300.00, 285.00, 500.00, 40.00, true)
	GUI:setChineseName(member_cell, "加入队伍组合")
	GUI:setAnchorPoint(member_cell, 0.50, 0.00)
	GUI:setTouchEnabled(member_cell, true)
	GUI:setTag(member_cell, 49)

	-- Create Image_4
	local Image_4 = GUI:Image_Create(member_cell, "Image_4", 250.00, 20.00, "res/private/team/1900014007_1.png")
	GUI:setChineseName(Image_4, "加入队伍_装饰条图片")
	GUI:setAnchorPoint(Image_4, 0.50, 0.50)
	GUI:setTouchEnabled(Image_4, false)
	GUI:setTag(Image_4, 52)

	-- Create Label_name
	local Label_name = GUI:Text_Create(member_cell, "Label_name", 65.00, 20.00, 16, "#ffffff", [[玩家名字七个字]])
	GUI:setChineseName(Label_name, "加入队伍_名字_文本")
	GUI:setAnchorPoint(Label_name, 0.50, 0.50)
	GUI:setTouchEnabled(Label_name, false)
	GUI:setTag(Label_name, 53)
	GUI:Text_enableOutline(Label_name, "#111111", 1)

	-- Create Label_guild
	local Label_guild = GUI:Text_Create(member_cell, "Label_guild", 197.00, 20.00, 16, "#ffffff", [[行会名字七个字]])
	GUI:setChineseName(Label_guild, "加入队伍_行会_文本")
	GUI:setAnchorPoint(Label_guild, 0.50, 0.50)
	GUI:setTouchEnabled(Label_guild, false)
	GUI:setTag(Label_guild, 56)
	GUI:Text_enableOutline(Label_guild, "#111111", 1)

	-- Create Label_level
	local Label_level = GUI:Text_Create(member_cell, "Label_level", 337.00, 20.00, 16, "#ffffff", [[]])
	GUI:setChineseName(Label_level, "加入队伍_等级_文本")
	GUI:setAnchorPoint(Label_level, 0.50, 0.50)
	GUI:setTouchEnabled(Label_level, false)
	GUI:setTag(Label_level, 58)
	GUI:Text_enableOutline(Label_level, "#111111", 1)

	-- Create Button_operation
	local Button_operation = GUI:Button_Create(member_cell, "Button_operation", 455.00, 20.00, "res/public/1900000679.png")
	GUI:Button_loadTexturePressed(Button_operation, "res/public/1900000679_1.png")
	GUI:Button_setScale9Slice(Button_operation, 16, 14, 12, 10)
	GUI:setContentSize(Button_operation, 76, 33)
	GUI:setIgnoreContentAdaptWithSize(Button_operation, false)
	GUI:Button_setTitleText(Button_operation, "邀请")
	GUI:Button_setTitleColor(Button_operation, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_operation, 16)
	GUI:Button_titleEnableOutline(Button_operation, "#111111", 2)
	GUI:setChineseName(Button_operation, "加入队伍_邀请_按钮")
	GUI:setAnchorPoint(Button_operation, 0.50, 0.50)
	GUI:setTouchEnabled(Button_operation, true)
	GUI:setTag(Button_operation, 59)

	-- Create Label_operation
	local Label_operation = GUI:Text_Create(member_cell, "Label_operation", 455.00, 20.00, 16, "#ffffff", [[已邀请]])
	GUI:setChineseName(Label_operation, "加入队伍_邀请状态_文本")
	GUI:setAnchorPoint(Label_operation, 0.50, 0.50)
	GUI:setTouchEnabled(Label_operation, false)
	GUI:setTag(Label_operation, 60)
	GUI:Text_enableOutline(Label_operation, "#111111", 1)
end
return ui