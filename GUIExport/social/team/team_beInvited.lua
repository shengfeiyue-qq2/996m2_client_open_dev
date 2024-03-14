local ui = {}
function ui.init(parent)
	-- Create Panel_info
	local Panel_info = GUI:Layout_Create(parent, "Panel_info", 568.00, 320.00, 331.00, 145.00, false)
	GUI:Layout_setBackGroundImageScale9Slice(Panel_info, 109, 109, 47, 47)
	GUI:Layout_setBackGroundImage(Panel_info, "res/public/1900000650.png")
	GUI:setChineseName(Panel_info, "加入队伍组合")
	GUI:setAnchorPoint(Panel_info, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_info, true)
	GUI:setTag(Panel_info, 87)

	-- Create Image_title
	local Image_title = GUI:Image_Create(Panel_info, "Image_title", 165.00, 115.00, "res/private/team/1900014002.png")
	GUI:setChineseName(Image_title, "加入队伍_标题_图片")
	GUI:setAnchorPoint(Image_title, 0.50, 0.50)
	GUI:setTouchEnabled(Image_title, false)
	GUI:setTag(Image_title, 88)

	-- Create Button_agree
	local Button_agree = GUI:Button_Create(Panel_info, "Button_agree", 90.00, 35.00, "res/public/1900000653.png")
	GUI:Button_setScale9Slice(Button_agree, 15, 15, 12, 10)
	GUI:setContentSize(Button_agree, 82, 29)
	GUI:setIgnoreContentAdaptWithSize(Button_agree, false)
	GUI:Button_setTitleText(Button_agree, "同意")
	GUI:Button_setTitleColor(Button_agree, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_agree, 16)
	GUI:Button_titleEnableOutline(Button_agree, "#111111", 2)
	GUI:setChineseName(Button_agree, "加入队伍_同意_按钮")
	GUI:setAnchorPoint(Button_agree, 0.50, 0.50)
	GUI:setTouchEnabled(Button_agree, true)
	GUI:setTag(Button_agree, 90)

	-- Create Button_disagree
	local Button_disagree = GUI:Button_Create(Panel_info, "Button_disagree", 245.00, 35.00, "res/public/1900000653.png")
	GUI:Button_setScale9Slice(Button_disagree, 15, 15, 12, 10)
	GUI:setContentSize(Button_disagree, 82, 29)
	GUI:setIgnoreContentAdaptWithSize(Button_disagree, false)
	GUI:Button_setTitleText(Button_disagree, "拒绝")
	GUI:Button_setTitleColor(Button_disagree, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_disagree, 16)
	GUI:Button_titleEnableOutline(Button_disagree, "#111111", 2)
	GUI:setChineseName(Button_disagree, "加入队伍_拒绝_按钮")
	GUI:setAnchorPoint(Button_disagree, 0.50, 0.50)
	GUI:setTouchEnabled(Button_disagree, true)
	GUI:setTag(Button_disagree, 91)

	-- Create Text_info
	local Text_info = GUI:Text_Create(Panel_info, "Text_info", 165.00, 86.00, 16, "#ffffff", [[Text Label]])
	GUI:setChineseName(Text_info, "加入队伍_邀请信息_文本")
	GUI:setAnchorPoint(Text_info, 0.50, 0.50)
	GUI:setTouchEnabled(Text_info, false)
	GUI:setTag(Text_info, 93)
	GUI:Text_enableOutline(Text_info, "#111111", 1)

	-- Create Button_close
	local Button_close = GUI:Button_Create(Panel_info, "Button_close", 344.00, 124.00, "res/public/1900000510.png")
	GUI:Button_loadTexturePressed(Button_close, "res/public/1900000511.png")
	GUI:Button_setScale9Slice(Button_close, 8, 8, 12, 10)
	GUI:setContentSize(Button_close, 26, 42)
	GUI:setIgnoreContentAdaptWithSize(Button_close, false)
	GUI:Button_setTitleText(Button_close, "")
	GUI:Button_setTitleColor(Button_close, "#414146")
	GUI:Button_setTitleFontSize(Button_close, 14)
	GUI:Button_titleDisableOutLine(Button_close)
	GUI:setChineseName(Button_close, "加入队伍_关闭_按钮")
	GUI:setAnchorPoint(Button_close, 0.50, 0.50)
	GUI:setTouchEnabled(Button_close, true)
	GUI:setTag(Button_close, 94)
end
return ui