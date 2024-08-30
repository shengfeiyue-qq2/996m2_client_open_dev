
local ui = {}
function ui.init(parent)
	-- Create Panel_cell
	local Panel_cell = GUI:Layout_Create(parent, "Panel_cell", 0.00, 0.00, 272.00, 50.00, false)
	GUI:setChineseName(Panel_cell, "玩家buff_组合")
	GUI:setTouchEnabled(Panel_cell, true)
	GUI:setTag(Panel_cell, 14)

	-- Create Button_icon
	local Button_icon = GUI:Button_Create(Panel_cell, "Button_icon", 10.00, 3.00, "res/buff_icon/1.png")
	GUI:setContentSize(Button_icon, 44, 44)
	GUI:setIgnoreContentAdaptWithSize(Button_icon, false)
	GUI:Button_setTitleText(Button_icon, "")
	GUI:Button_setTitleColor(Button_icon, "#ffffff")
	GUI:Button_setTitleFontSize(Button_icon, 14)
	GUI:Button_titleEnableOutline(Button_icon, "#000000", 1)
	GUI:setTouchEnabled(Button_icon, true)
	GUI:setTag(Button_icon, -1)

	-- Create Image_bg
	local Image_bg = GUI:Image_Create(Panel_cell, "Image_bg", 60.00, 24.00, "res/private/player_skill-win32/1900015023.png")
	GUI:Image_setScale9Slice(Image_bg, 19, 19, 9, 9)
	GUI:setContentSize(Image_bg, 210, 44)
	GUI:setIgnoreContentAdaptWithSize(Image_bg, false)
	GUI:setChineseName(Image_bg, "玩家buff_背景图")
	GUI:setAnchorPoint(Image_bg, 0.00, 0.50)
	GUI:setTouchEnabled(Image_bg, false)
	GUI:setTag(Image_bg, 16)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Image_bg, "Text_name", 14.00, 22.00, 12, "#ffffff", [[buff名称]])
	GUI:setChineseName(Text_name, "玩家buff名称_文本")
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, 18)
	GUI:Text_enableOutline(Text_name, "#111111", 1)

	-- Create Text_time
	local Text_time = GUI:Text_Create(Image_bg, "Text_time", 14.00, 6.00, 12, "#ffff00", [[-]])
	GUI:setChineseName(Text_time, "玩家buff_剩余时间")
	GUI:setTouchEnabled(Text_time, false)
	GUI:setTag(Text_time, 19)
	GUI:Text_enableOutline(Text_time, "#111111", 1)

	-- Create Text_ol
	local Text_ol = GUI:Text_Create(Image_bg, "Text_ol", 110.00, 6.00, 12, "#ffffff", [[-]])
	GUI:setChineseName(Text_ol, "玩家buff_叠加层数_文本")
	GUI:setTouchEnabled(Text_ol, false)
	GUI:setTag(Text_ol, 20)
	GUI:Text_enableOutline(Text_ol, "#000000", 1)
end
return ui