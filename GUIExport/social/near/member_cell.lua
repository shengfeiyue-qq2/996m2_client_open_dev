local ui = {}
function ui.init(parent)
	-- Create Panel_near_member
	local Panel_near_member = GUI:Layout_Create(parent, "Panel_near_member", 131.00, 370.00, 600.00, 40.00, false)
	GUI:setChineseName(Panel_near_member, "附件玩家表头组合")
	GUI:setTouchEnabled(Panel_near_member, true)
	GUI:setTag(Panel_near_member, 101)

	-- Create Image_4
	local Image_4 = GUI:Image_Create(Panel_near_member, "Image_4", 300.00, 20.00, "res/private/team/1900014010.png")
	GUI:setChineseName(Image_4, "附件玩家_线条装饰图")
	GUI:setAnchorPoint(Image_4, 0.50, 0.50)
	GUI:setTouchEnabled(Image_4, false)
	GUI:setTag(Image_4, 104)

	-- Create Label_name
	local Label_name = GUI:Text_Create(Panel_near_member, "Label_name", 85.00, 20.00, 16, "#ffffff", [[玩家名字七个字]])
	GUI:setChineseName(Label_name, "附件玩家_队伍_文本")
	GUI:setAnchorPoint(Label_name, 0.50, 0.50)
	GUI:setTouchEnabled(Label_name, false)
	GUI:setTag(Label_name, 105)
	GUI:Text_enableOutline(Label_name, "#111111", 1)

	-- Create Label_job
	local Label_job = GUI:Text_Create(Panel_near_member, "Label_job", 215.00, 20.00, 16, "#ffffff", [[职业]])
	GUI:setChineseName(Label_job, "附件玩家_职业_文本")
	GUI:setAnchorPoint(Label_job, 0.50, 0.50)
	GUI:setTouchEnabled(Label_job, false)
	GUI:setTag(Label_job, 106)
	GUI:Text_enableOutline(Label_job, "#111111", 1)

	-- Create Label_level
	local Label_level = GUI:Text_Create(Panel_near_member, "Label_level", 293.00, 20.00, 16, "#ffffff", [[等级]])
	GUI:setChineseName(Label_level, "附件玩家_等级_文本")
	GUI:setAnchorPoint(Label_level, 0.50, 0.50)
	GUI:setTouchEnabled(Label_level, false)
	GUI:setTag(Label_level, 107)
	GUI:Text_enableOutline(Label_level, "#111111", 1)

	-- Create Label_guild
	local Label_guild = GUI:Text_Create(Panel_near_member, "Label_guild", 402.00, 20.00, 16, "#ffffff", [[行会]])
	GUI:setChineseName(Label_guild, "附件玩家_行会_文本")
	GUI:setAnchorPoint(Label_guild, 0.50, 0.50)
	GUI:setTouchEnabled(Label_guild, false)
	GUI:setTag(Label_guild, 193)
	GUI:Text_enableOutline(Label_guild, "#111111", 1)

	-- Create Button_operation
	local Button_operation = GUI:Button_Create(Panel_near_member, "Button_operation", 535.00, 21.00, "res/public/1900000679.png")
	GUI:Button_loadTexturePressed(Button_operation, "res/public/1900000679_1.png")
	GUI:Button_setScale9Slice(Button_operation, 16, 14, 13, 9)
	GUI:setContentSize(Button_operation, 76, 33)
	GUI:setIgnoreContentAdaptWithSize(Button_operation, false)
	GUI:Button_setTitleText(Button_operation, "查看")
	GUI:Button_setTitleColor(Button_operation, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_operation, 16)
	GUI:Button_titleEnableOutline(Button_operation, "#111111", 2)
	GUI:setChineseName(Button_operation, "附件玩家_操作_按钮")
	GUI:setAnchorPoint(Button_operation, 0.50, 0.50)
	GUI:setTouchEnabled(Button_operation, true)
	GUI:setTag(Button_operation, 111)
end
return ui