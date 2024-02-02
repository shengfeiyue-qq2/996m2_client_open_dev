local ui = {}
function ui.init(parent)
	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(parent, "Panel_1", 300.00, 300.00, 100.00, 30.00, false)
	GUI:setAnchorPoint(Panel_1, 0.00, 0.50)
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 258)

	-- Create Button_1
	local Button_1 = GUI:Button_Create(Panel_1, "Button_1", 50.00, 15.00, "res/public_win32/1900000663.png")
	GUI:Button_loadTexturePressed(Button_1, "res/public_win32/1900000662.png")
	GUI:Button_setScale9Slice(Button_1, 15, 15, 11, 11)
	GUI:setContentSize(Button_1, 86, 28)
	GUI:setIgnoreContentAdaptWithSize(Button_1, false)
	GUI:Button_setTitleText(Button_1, "武器")
	GUI:Button_setTitleColor(Button_1, "#6c6861")
	GUI:Button_setTitleFontSize(Button_1, 14)
	GUI:Button_titleEnableOutline(Button_1, "#111111", 2)
	GUI:setAnchorPoint(Button_1, 0.50, 0.50)
	GUI:setTouchEnabled(Button_1, true)
	GUI:setTag(Button_1, 259)
end
return ui