local ui = {}
function ui.init(parent)
	-- Create button_type
	local button_type = GUI:Button_Create(parent, "button_type", 0.00, 0.00, "res/private/rank_ui/rank_ui_mobile/btn_2_0.png")
	GUI:Button_loadTexturePressed(button_type, "res/private/rank_ui/rank_ui_mobile/btn_2_1.png")
	GUI:Button_loadTextureDisabled(button_type, "res/private/rank_ui/rank_ui_mobile/btn_2_1.png")
	GUI:Button_setTitleText(button_type, "")
	GUI:Button_setTitleColor(button_type, "#ffffff")
	GUI:Button_setTitleFontSize(button_type, 14)
	GUI:Button_titleEnableOutline(button_type, "#000000", 1)
	GUI:setTouchEnabled(button_type, true)
	GUI:setTag(button_type, -1)

	-- Create Text_name
	local Text_name = GUI:Text_Create(button_type, "Text_name", 58.00, 16.00, 16, "#807256", [[分类]])
	GUI:setAnchorPoint(Text_name, 0.50, 0.50)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, -1)
	GUI:Text_enableOutline(Text_name, "#111111", 2)
end
return ui