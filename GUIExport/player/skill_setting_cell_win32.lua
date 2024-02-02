local ui = {}
function ui.init(parent)
	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(parent, "Panel_1", 0.00, 0.00, 35.00, 35.00, false)
	GUI:setChineseName(Panel_1, "技能设置组合")
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 41)

	-- Create Button_key
	local Button_key = GUI:Button_Create(Panel_1, "Button_key", 17.50, 17.50, "res/private/player_skill-win32/btn_jnan_1.png")
	GUI:Button_loadTexturePressed(Button_key, "res/private/player_skill-win32/btn_jnan_1_2.png")
	GUI:Button_setScale9Slice(Button_key, 15, 15, 12, 10)
	GUI:setContentSize(Button_key, 33, 33)
	GUI:setIgnoreContentAdaptWithSize(Button_key, false)
	GUI:Button_setTitleText(Button_key, "")
	GUI:Button_setTitleColor(Button_key, "#414146")
	GUI:Button_setTitleFontSize(Button_key, 14)
	GUI:Button_titleDisableOutLine(Button_key)
	GUI:setChineseName(Button_key, "技能设置_快捷键按钮")
	GUI:setAnchorPoint(Button_key, 0.50, 0.50)
	GUI:setTouchEnabled(Button_key, true)
	GUI:setTag(Button_key, 42)

	-- Create Image_key
	local Image_key = GUI:Image_Create(Panel_1, "Image_key", 17.50, 17.50, "Default/ImageFile.png")
	GUI:setChineseName(Image_key, "技能设置_快捷键图片")
	GUI:setAnchorPoint(Image_key, 0.50, 0.50)
	GUI:setTouchEnabled(Image_key, false)
	GUI:setTag(Image_key, 44)
end
return ui