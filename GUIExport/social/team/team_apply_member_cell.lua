local ui = {}
function ui.init(parent)
	-- Create member_cell
	local member_cell = GUI:Layout_Create(parent, "member_cell", 40.00, 285.00, 600.00, 40.00, false)
	GUI:setChineseName(member_cell, "加入队伍组合")
	GUI:setTouchEnabled(member_cell, true)
	GUI:setTag(member_cell, 49)

	-- Create Image_4
	local Image_4 = GUI:Image_Create(member_cell, "Image_4", 300.00, 20.00, "res/private/team/1900014004_1.png")
	GUI:setChineseName(Image_4, "加入队伍_装饰条图片")
	GUI:setAnchorPoint(Image_4, 0.50, 0.50)
	GUI:setTouchEnabled(Image_4, false)
	GUI:setTag(Image_4, 52)

	-- Create Label_name
	local Label_name = GUI:Text_Create(member_cell, "Label_name", 68.00, 20.00, 16, "#ffffff", [[玩家名字七个字]])
	GUI:setChineseName(Label_name, "加入队伍_名字_文本")
	GUI:setAnchorPoint(Label_name, 0.50, 0.50)
	GUI:setTouchEnabled(Label_name, false)
	GUI:setTag(Label_name, 53)
	GUI:Text_enableOutline(Label_name, "#111111", 1)

	-- Create Label_guild
	local Label_guild = GUI:Text_Create(member_cell, "Label_guild", 200.00, 20.00, 16, "#ffffff", [[行会名字七个字]])
	GUI:setChineseName(Label_guild, "加入队伍_行会_文本")
	GUI:setAnchorPoint(Label_guild, 0.50, 0.50)
	GUI:setTouchEnabled(Label_guild, false)
	GUI:setTag(Label_guild, 56)
	GUI:Text_enableOutline(Label_guild, "#111111", 1)

	-- Create Label_level
	local Label_level = GUI:Text_Create(member_cell, "Label_level", 340.00, 20.00, 16, "#ffffff", [[]])
	GUI:setChineseName(Label_level, "加入队伍_等级_文本")
	GUI:setAnchorPoint(Label_level, 0.50, 0.50)
	GUI:setTouchEnabled(Label_level, false)
	GUI:setTag(Label_level, 58)
	GUI:Text_enableOutline(Label_level, "#111111", 1)

	-- Create Label_agree
	local Label_agree = GUI:Text_Create(member_cell, "Label_agree", 553.00, 20.00, 16, "#ffffff", [[已同意]])
	GUI:setChineseName(Label_agree, "加入队伍_名字_文本")
	GUI:setAnchorPoint(Label_agree, 0.50, 0.50)
	GUI:setTouchEnabled(Label_agree, false)
	GUI:setTag(Label_agree, 84)
	GUI:Text_enableOutline(Label_agree, "#111111", 1)

	-- Create Label_disagree
	local Label_disagree = GUI:Text_Create(member_cell, "Label_disagree", 458.00, 20.00, 16, "#ffffff", [[已拒绝]])
	GUI:setChineseName(Label_disagree, "加入队伍_处理结果_文本")
	GUI:setAnchorPoint(Label_disagree, 0.50, 0.50)
	GUI:setTouchEnabled(Label_disagree, false)
	GUI:setTag(Label_disagree, 60)
	GUI:Text_enableOutline(Label_disagree, "#111111", 1)

	-- Create Button_disagree
	local Button_disagree = GUI:Button_Create(member_cell, "Button_disagree", 458.00, 20.00, "res/public/1900000679.png")
	GUI:Button_loadTexturePressed(Button_disagree, "res/public/1900000679_1.png")
	GUI:Button_setScale9Slice(Button_disagree, 16, 14, 13, 9)
	GUI:setContentSize(Button_disagree, 76, 33)
	GUI:setIgnoreContentAdaptWithSize(Button_disagree, false)
	GUI:Button_setTitleText(Button_disagree, "拒绝")
	GUI:Button_setTitleColor(Button_disagree, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_disagree, 16)
	GUI:Button_titleEnableOutline(Button_disagree, "#111111", 2)
	GUI:setChineseName(Button_disagree, "加入队伍_拒绝_按钮")
	GUI:setAnchorPoint(Button_disagree, 0.50, 0.50)
	GUI:setTouchEnabled(Button_disagree, true)
	GUI:setTag(Button_disagree, 59)

	-- Create Button_agree
	local Button_agree = GUI:Button_Create(member_cell, "Button_agree", 553.00, 20.00, "res/public/1900000679.png")
	GUI:Button_loadTexturePressed(Button_agree, "res/public/1900000679_1.png")
	GUI:Button_setScale9Slice(Button_agree, 16, 14, 13, 9)
	GUI:setContentSize(Button_agree, 76, 33)
	GUI:setIgnoreContentAdaptWithSize(Button_agree, false)
	GUI:Button_setTitleText(Button_agree, "同意")
	GUI:Button_setTitleColor(Button_agree, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_agree, 16)
	GUI:Button_titleEnableOutline(Button_agree, "#111111", 2)
	GUI:setChineseName(Button_agree, "加入队伍_同意_按钮")
	GUI:setAnchorPoint(Button_agree, 0.50, 0.50)
	GUI:setTouchEnabled(Button_agree, true)
	GUI:setTag(Button_agree, 83)
end
return ui