local ui = {}
function ui.init(parent)
	-- Create Cell_title
	local Cell_title = GUI:Layout_Create(parent, "Cell_title", 0.00, 0.00, 348.00, 55.00, false)
	GUI:setChineseName(Cell_title, "玩家称号_组合")
	GUI:setTouchEnabled(Cell_title, true)
	GUI:setTag(Cell_title, 14.0)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Cell_title, "Image_bg", 30.00, 27.00, "res/private/title_layer_ui/title_6.png")
	GUI:setChineseName(Image_bg, "玩家称号_图标背景框")
	GUI:setAnchorPoint(Image_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 37.0)

	-- Create Button_icon
	local Button_icon = GUI:Button_Create(Image_bg, "Button_icon", 19.00, 19.00, "res/private/title_layer_ui/title_4.png")
	GUI:Button_setScale9Slice(Button_icon, 15, 15.0, 11, 11.0)
	GUI:setContentSize(Button_icon, 43.0, 43.0)
	GUI:setIgnoreContentAdaptWithSize(Button_icon, false)
	GUI:Button_setTitleText(Button_icon, "")
	GUI:Button_setTitleColor(Button_icon, "#414146")
	GUI:Button_setTitleFontSize(Button_icon, 14.0)
	GUI:Button_titleDisableOutLine(Button_icon)
	GUI:setChineseName(Button_icon, "玩家称号_图标")
	GUI:setAnchorPoint(Button_icon, 0.50, 0.50)
	GUI:setTouchEnabled(Button_icon, true)
	GUI:setTag(Button_icon, 19.0)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Image_bg, "Text_name", 60.00, 19.00, 16.0, "#00b300", [[Text Label]])
	GUI:setChineseName(Text_name, "玩家称号_称号_文本")
	GUI:setAnchorPoint(Text_name, 0.00, 0.50)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, 39.0)
	GUI:Text_enableOutline(Text_name, "#111111", 1.0)

	-- Create Image_3
	local Image_3 = GUI:Image_Create(Cell_title, "Image_3", 174.00, 3.00, "res/public/1900000667.png")
	GUI:setContentSize(Image_3, 348.0, 2.0)
	GUI:setIgnoreContentAdaptWithSize(Image_3, false)
	GUI:setChineseName(Image_3, "玩家称号_装饰条")
	GUI:setAnchorPoint(Image_3, 0.50, 0.50)
	GUI:setTouchEnabled(Image_3, false)
	GUI:setTag(Image_3, 40.0)
end
return ui