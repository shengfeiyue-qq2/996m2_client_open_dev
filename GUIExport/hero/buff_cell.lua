local ui = {}
function ui.init(parent)
	-- Create Panel_cell
	local Panel_cell = GUI:Layout_Create(parent, "Panel_cell", 0.00, 0.00, 348.00, 70.00, false)
	GUI:setTouchEnabled(Panel_cell, false)
	GUI:setTag(Panel_cell, -1)

	-- Create Button_icon
	local Button_icon = GUI:Button_Create(Panel_cell, "Button_icon", 47.00, 6.00, "res/buff_icon/1.png")
	GUI:Button_setTitleText(Button_icon, "")
	GUI:Button_setTitleColor(Button_icon, "#ffffff")
	GUI:Button_setTitleFontSize(Button_icon, 14)
	GUI:Button_titleEnableOutline(Button_icon, "#000000", 1)
	GUI:setAnchorPoint(Button_icon, 0.50, 0.00)
	GUI:setTouchEnabled(Button_icon, true)
	GUI:setTag(Button_icon, -1)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_cell, "Image_bg", 86.00, 5.00, "res/private/player_skill/1900015004.png")
	GUI:Image_setScale9Slice(Image_bg, 24, 135, 10, 8)
	GUI:setContentSize(Image_bg, 250, 60)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, -1)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Image_bg, "Text_name", 16.00, 32.00, 16, "#ffffff", [[buff名称]])
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, -1)
	GUI:Text_enableOutline(Text_name, "#000000", 1)

	-- Create Text_time
	local Text_time = GUI:Text_Create(Image_bg, "Text_time", 18.00, 8.00, 16, "#ffff00", [[1s]])
	GUI:setTouchEnabled(Text_time, false)
	GUI:setTag(Text_time, -1)
	GUI:Text_enableOutline(Text_time, "#000000", 1)

	-- Create Text_ol
	local Text_ol = GUI:Text_Create(Image_bg, "Text_ol", 130.00, 8.00, 16, "#ffffff", [[]])
	GUI:setTouchEnabled(Text_ol, false)
	GUI:setTag(Text_ol, -1)
	GUI:Text_enableOutline(Text_ol, "#000000", 1)
end
return ui