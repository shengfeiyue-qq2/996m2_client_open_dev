local ui = {}
function ui.init(parent)
	-- Create Cell_setting
	local Cell_setting = GUI:Layout_Create(parent, "Cell_setting", 0.00, 0.00, 35.00, 35.00, false)
	GUI:setChineseName(Cell_setting, "技能设置组合")
	GUI:setTouchEnabled(Cell_setting, true)
	GUI:setTag(Cell_setting, 41.0)

	-- Create Button_key
	local Button_key = GUI:Button_Create(Cell_setting, "Button_key", 17.00, 17.00, "res/private/player_skill-win32/btn_jnan_1.png")
	GUI:Button_loadTexturePressed(Button_key, "res/private/player_skill-win32/btn_jnan_1_2.png")
	GUI:Button_setScale9Slice(Button_key, 15, 15.0, 12, 10.0)
	GUI:setContentSize(Button_key, 33.0, 33.0)
	GUI:setIgnoreContentAdaptWithSize(Button_key, false)
	GUI:Button_setTitleText(Button_key, "")
	GUI:Button_setTitleColor(Button_key, "#414146")
	GUI:Button_setTitleFontSize(Button_key, 14.0)
	GUI:Button_titleDisableOutLine(Button_key)
	GUI:setChineseName(Button_key, "技能设置_快捷键按钮")
	GUI:setAnchorPoint(Button_key, 0.50, 0.50)
	GUI:setTouchEnabled(Button_key, true)
	GUI:setTag(Button_key, 42.0)

	-- Create Image_key
	local Image_key = GUI:Image_Create(Cell_setting, "Image_key", 17.00, 17.00, "Default/ImageFile.png")
	GUI:setChineseName(Image_key, "技能设置_快捷键图片")
	GUI:setAnchorPoint(Image_key, 0.50, 0.50)
	GUI:setTouchEnabled(Image_key, false)
	GUI:setTag(Image_key, 44.0)
end
return ui