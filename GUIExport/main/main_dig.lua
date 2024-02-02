local ui = {}
function ui.init(parent)
	-- Create Button_dig
	local Button_dig = GUI:Button_Create(parent, "Button_dig", 290.00, 270.00, "res/private/main/btn_xbzy_03.png")
	GUI:Button_setTitleText(Button_dig, "")
	GUI:Button_setTitleColor(Button_dig, "#ffffff")
	GUI:Button_setTitleFontSize(Button_dig, 10)
	GUI:Button_titleEnableOutline(Button_dig, "#000000", 1)
	GUI:setChineseName(Button_dig, "采集按钮")
	GUI:setAnchorPoint(Button_dig, 0.50, 0.50)
	GUI:setTouchEnabled(Button_dig, true)
	GUI:setTag(Button_dig, -1)
end
return ui