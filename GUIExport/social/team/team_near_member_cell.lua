local ui = {}
function ui.init(parent)
	-- Create near_member_cell
	local near_member_cell = GUI:Layout_Create(parent, "near_member_cell", 131.00, 370.00, 600.00, 42.00, false)
	GUI:setChineseName(near_member_cell, "附近队伍组合")
	GUI:setTouchEnabled(near_member_cell, true)
	GUI:setTag(near_member_cell, 101)

	-- Create Image_4
	local Image_4 = GUI:Image_Create(near_member_cell, "Image_4", 300.00, 21.00, "res/private/team/19000140013_1.png")
	GUI:setChineseName(Image_4, "附近队伍_装饰条图")
	GUI:setAnchorPoint(Image_4, 0.50, 0.50)
	GUI:setTouchEnabled(Image_4, false)
	GUI:setTag(Image_4, 104)

	-- Create Label_name
	local Label_name = GUI:Text_Create(near_member_cell, "Label_name", 83.00, 21.00, 16, "#ffffff", [[玩家名字七个字]])
	GUI:setChineseName(Label_name, "附近队伍_名称_文本")
	GUI:setAnchorPoint(Label_name, 0.50, 0.50)
	GUI:setTouchEnabled(Label_name, false)
	GUI:setTag(Label_name, 105)
	GUI:Text_enableOutline(Label_name, "#111111", 1)

	-- Create Label_guild
	local Label_guild = GUI:Text_Create(near_member_cell, "Label_guild", 250.00, 21.00, 16, "#ffffff", [[战士]])
	GUI:setChineseName(Label_guild, "附近队伍_行会_文本")
	GUI:setAnchorPoint(Label_guild, 0.50, 0.50)
	GUI:setTouchEnabled(Label_guild, false)
	GUI:setTag(Label_guild, 106)
	GUI:Text_enableOutline(Label_guild, "#111111", 1)

	-- Create Label_number
	local Label_number = GUI:Text_Create(near_member_cell, "Label_number", 410.00, 21.00, 16, "#ffffff", [[等级]])
	GUI:setChineseName(Label_number, "附近队伍_行会人数_文本")
	GUI:setAnchorPoint(Label_number, 0.50, 0.50)
	GUI:setTouchEnabled(Label_number, false)
	GUI:setTag(Label_number, 107)
	GUI:Text_enableOutline(Label_number, "#111111", 1)

	-- Create Label_operation
	local Label_operation = GUI:Text_Create(near_member_cell, "Label_operation", 530.00, 21.00, 16, "#f8e6c6", [[已申请]])
	GUI:setChineseName(Label_operation, "附近队伍_申请状态_文本")
	GUI:setAnchorPoint(Label_operation, 0.50, 0.50)
	GUI:setTouchEnabled(Label_operation, false)
	GUI:setTag(Label_operation, 108)
	GUI:Text_enableOutline(Label_operation, "#111111", 2)

	-- Create Button_operation
	local Button_operation = GUI:Button_Create(near_member_cell, "Button_operation", 530.00, 21.00, "res/public/1900000679.png")
	GUI:Button_loadTexturePressed(Button_operation, "res/public/1900000679_1.png")
	GUI:Button_setScale9Slice(Button_operation, 16, 14, 12, 10)
	GUI:setContentSize(Button_operation, 76, 33)
	GUI:setIgnoreContentAdaptWithSize(Button_operation, false)
	GUI:Button_setTitleText(Button_operation, "申请")
	GUI:Button_setTitleColor(Button_operation, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_operation, 16)
	GUI:Button_titleEnableOutline(Button_operation, "#111111", 2)
	GUI:setChineseName(Button_operation, "附近队伍_申请_按钮")
	GUI:setAnchorPoint(Button_operation, 0.50, 0.50)
	GUI:setTouchEnabled(Button_operation, true)
	GUI:setTag(Button_operation, 111)
end
return ui