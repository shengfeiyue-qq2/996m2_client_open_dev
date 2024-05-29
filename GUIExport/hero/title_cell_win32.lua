local ui = {}
function ui.init(parent)
	local Panel_title_cell = GUI:Layout_Create(parent, "Panel_title_cell", 0.00, 0.00, 278.00, 42.00, false)
	GUI:setChineseName(Panel_title_cell, "英雄称号_组合")
	GUI:setTouchEnabled(Panel_title_cell, true)
	GUI:setTag(Panel_title_cell, 40)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_title_cell, "Image_bg", 25.00, 21.00, "res/private/title_layer_ui_win32/title_6.png")
	GUI:setChineseName(Image_bg, "英雄称号_图标背景框")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 41)

	-- Create Button_icon
	local Button_icon = GUI:Button_Create(Image_bg, "Button_icon", 14.00, 14.00, "res/private/title_layer_ui_win32/title_4.png")
	GUI:Button_setScale9Slice(Button_icon, 15, 15, 11, 11)
	GUI:setContentSize(Button_icon, 32, 32)
	GUI:setIgnoreContentAdaptWithSize(Button_icon, false)
	GUI:Button_setTitleText(Button_icon, "")
	GUI:Button_setTitleColor(Button_icon, "#414146")
	GUI:Button_setTitleFontSize(Button_icon, 14)
	GUI:Button_titleDisableOutLine(Button_icon)
	GUI:setChineseName(Button_icon, "英雄称号_图标")
	GUI:setAnchorPoint(Button_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Button_icon, true)
	GUI:setTag(Button_icon, 42)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Image_bg, "Text_name", 50.00, 14.00, 16, "#00b300", [[Text Label]])
	GUI:setChineseName(Text_name, "英雄称号_称号_文本")
	GUI:setAnchorPoint(Text_name, 0.00, 0.50)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, 43)
	GUI:Text_enableOutline(Text_name, "#111111", 1)

	-- Create Image_3
	local Image_3 = GUI:Image_Create(Panel_title_cell, "Image_3", 139.00, 3.00, "res/public/1900000667.png")
	GUI:setContentSize(Image_3, 278, 2)
	GUI:setIgnoreContentAdaptWithSize(Image_3, false)
	GUI:setChineseName(Image_3, "英雄称号_装饰条")
	GUI:setAnchorPoint(Image_3, 0.50, 0.50)
	GUI:setTouchEnabled(Image_3, false)
	GUI:setTag(Image_3, 44)
end
return ui