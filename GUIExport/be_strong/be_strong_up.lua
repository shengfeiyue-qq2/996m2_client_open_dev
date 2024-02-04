local ui = {}
function ui.init(parent)
	-- Create Button_up
	local Button_up = GUI:Button_Create(parent, "Button_up", 555.00, 352.00, "res/private/be_strong/bg_jindutiao_11.png")
	GUI:Button_setScale9Slice(Button_up, 15, 15, 11, 11)
	GUI:setContentSize(Button_up, 59, 59)
	GUI:setIgnoreContentAdaptWithSize(Button_up, false)
	GUI:Button_setTitleText(Button_up, "")
	GUI:Button_setTitleColor(Button_up, "#414146")
	GUI:Button_setTitleFontSize(Button_up, 14)
	GUI:Button_titleDisableOutLine(Button_up)
	GUI:setAnchorPoint(Button_up, 0.50, 0.50)
	GUI:setTouchEnabled(Button_up, true)
	GUI:setTag(Button_up, 18)
end
return ui