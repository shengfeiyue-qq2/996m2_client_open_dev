local ui = {}
function ui.init(parent)
	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(parent, "Panel_1", 0.00, 0.00, 120.00, 40.00, false)
	GUI:setChineseName(Panel_1, "系统合成一级按钮_组合")
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 34)

	-- Create Button_type
	local Button_type = GUI:Button_Create(Panel_1, "Button_type", 60.00, 20.00, "res/private/compound_items_ui/1900000663.png")
	GUI:Button_loadTexturePressed(Button_type, "res/private/compound_items_ui/1900000662.png")
	GUI:Button_loadTextureDisabled(Button_type, "res/private/compound_items_ui/1900000662.png")
	GUI:Button_setScale9Slice(Button_type, 15, 15, 11, 11)
	GUI:setContentSize(Button_type, 115, 37)
	GUI:setIgnoreContentAdaptWithSize(Button_type, false)
	GUI:Button_setTitleText(Button_type, "")
	GUI:Button_setTitleColor(Button_type, "#6c6861")
	GUI:Button_setTitleFontSize(Button_type, 18)
	GUI:Button_titleEnableOutline(Button_type, "#111111", 2)
	GUI:setChineseName(Button_type, "系统合成一级按钮_按钮")
	GUI:setAnchorPoint(Button_type, 0.50, 0.50)
	GUI:setTouchEnabled(Button_type, true)
	GUI:setTag(Button_type, 35)

	-- Create Image_red
	local Image_red = GUI:Image_Create(Panel_1, "Image_red", 109.00, 31.00, "res/public/btn_npcfh_04.png")
	GUI:setChineseName(Image_red, "系统合成一级按钮_红点")
	GUI:setAnchorPoint(Image_red, 0.50, 0.50)
	GUI:setTouchEnabled(Image_red, false)
	GUI:setTag(Image_red, 43)
	GUI:setVisible(Image_red, false)
end
return ui