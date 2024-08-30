local ui = {}
function ui.init(parent)
	-- Create button_group
	local button_group = GUI:Button_Create(parent, "button_group", 0.00, 454.00, "res/private/rank_ui/rank_ui_win32/btn_1_0.png")
	GUI:Button_loadTexturePressed(button_group, "res/private/rank_ui/rank_ui_win32/btn_1_1.png")
	GUI:Button_loadTextureDisabled(button_group, "res/private/rank_ui/rank_ui_win32/btn_1_1.png")
	GUI:Button_setTitleText(button_group, "")
	GUI:Button_setTitleColor(button_group, "#ffffff")
	GUI:Button_setTitleFontSize(button_group, 14)
	GUI:Button_titleEnableOutline(button_group, "#000000", 1)
	GUI:setAnchorPoint(button_group, 0.00, 1.00)
	GUI:setTouchEnabled(button_group, true)
	GUI:setTag(button_group, -1)

	-- Create Text_name
	local Text_name = GUI:Text_Create(button_group, "Text_name", 56.00, 21.00, 14, "#807256", [[组别]])
	GUI:setAnchorPoint(Text_name, 0.50, 0.50)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, -1)
	GUI:Text_enableOutline(Text_name, "#111111", 2)
end
return ui