local ui = {}
function ui.init(parent)
	-- Create invite_cell
	local invite_cell = GUI:Layout_Create(parent, "invite_cell", 40.00, 285.00, 600.00, 40.00, false)
	GUI:setChineseName(invite_cell, "行会邀请列表条目")
	GUI:setTouchEnabled(invite_cell, true)
	GUI:setTag(invite_cell, 49)

	-- Create Image_4
	local Image_4 = GUI:Image_Create(invite_cell, "Image_4", 300.00, 20.00, "res/private/team/1900014004_1.png")
	GUI:setChineseName(Image_4, "行会邀请_装饰条图片")
	GUI:setAnchorPoint(Image_4, 0.50, 0.50)
	GUI:setTouchEnabled(Image_4, false)
	GUI:setTag(Image_4, 52)

	-- Create Label_guildName
	local Label_guildName = GUI:Text_Create(invite_cell, "Label_guildName", 68.00, 20.00, 16, "#ffffff", [[行会名字七个字]])
	GUI:setChineseName(Label_guildName, "行会邀请_行会名_文本")
	GUI:setAnchorPoint(Label_guildName, 0.50, 0.50)
	GUI:setTouchEnabled(Label_guildName, false)
	GUI:setTag(Label_guildName, 53)
	GUI:Text_enableOutline(Label_guildName, "#111111", 1)

	-- Create Label_masterName
	local Label_masterName = GUI:Text_Create(invite_cell, "Label_masterName", 200.00, 20.00, 16, "#ffffff", [[邀请者名字七个字]])
	GUI:setChineseName(Label_masterName, "行会邀请_邀请者_文本")
	GUI:setAnchorPoint(Label_masterName, 0.50, 0.50)
	GUI:setTouchEnabled(Label_masterName, false)
	GUI:setTag(Label_masterName, 56)
	GUI:Text_enableOutline(Label_masterName, "#111111", 1)

	-- Create Label_agree
	local Label_agree = GUI:Text_Create(invite_cell, "Label_agree", 553.00, 20.00, 16, "#ffffff", [[已同意]])
	GUI:setChineseName(Label_agree, "行会邀请_已同意_文本")
	GUI:setAnchorPoint(Label_agree, 0.50, 0.50)
	GUI:setTouchEnabled(Label_agree, false)
	GUI:setTag(Label_agree, 84)
	GUI:Text_enableOutline(Label_agree, "#111111", 1)

	-- Create Label_disagree
	local Label_disagree = GUI:Text_Create(invite_cell, "Label_disagree", 458.00, 20.00, 16, "#ffffff", [[已拒绝]])
	GUI:setChineseName(Label_disagree, "行会邀请_已拒绝_文本")
	GUI:setAnchorPoint(Label_disagree, 0.50, 0.50)
	GUI:setTouchEnabled(Label_disagree, false)
	GUI:setTag(Label_disagree, 60)
	GUI:Text_enableOutline(Label_disagree, "#111111", 1)

	-- Create Button_disagree
	local Button_disagree = GUI:Button_Create(invite_cell, "Button_disagree", 458.00, 20.00, "res/public/1900000679.png")
	GUI:Button_loadTexturePressed(Button_disagree, "res/public/1900000679_1.png")
	GUI:Button_setScale9Slice(Button_disagree, 16, 14, 13, 9)
	GUI:setContentSize(Button_disagree, 76, 33)
	GUI:setIgnoreContentAdaptWithSize(Button_disagree, false)
	GUI:Button_setTitleText(Button_disagree, "拒绝")
	GUI:Button_setTitleColor(Button_disagree, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_disagree, 16)
	GUI:Button_titleEnableOutline(Button_disagree, "#111111", 2)
	GUI:setChineseName(Button_disagree, "行会邀请_拒绝_按钮")
	GUI:setAnchorPoint(Button_disagree, 0.50, 0.50)
	GUI:setTouchEnabled(Button_disagree, true)
	GUI:setTag(Button_disagree, 59)

	-- Create Button_agree
	local Button_agree = GUI:Button_Create(invite_cell, "Button_agree", 553.00, 20.00, "res/public/1900000679.png")
	GUI:Button_loadTexturePressed(Button_agree, "res/public/1900000679_1.png")
	GUI:Button_setScale9Slice(Button_agree, 16, 14, 13, 9)
	GUI:setContentSize(Button_agree, 76, 33)
	GUI:setIgnoreContentAdaptWithSize(Button_agree, false)
	GUI:Button_setTitleText(Button_agree, "同意")
	GUI:Button_setTitleColor(Button_agree, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_agree, 16)
	GUI:Button_titleEnableOutline(Button_agree, "#111111", 2)
	GUI:setChineseName(Button_agree, "行会邀请_同意_按钮")
	GUI:setAnchorPoint(Button_agree, 0.50, 0.50)
	GUI:setTouchEnabled(Button_agree, true)
	GUI:setTag(Button_agree, 83)
end
return ui