local ui = {}
function ui.init(parent)
	-- Create Button_cell
	local Button_cell = GUI:Button_Create(parent, "Button_cell", 65.00, 25.00, "res/public/1900000662.png")
	GUI:Button_loadTexturePressed(Button_cell, "res/public/1900000663.png")
	GUI:Button_setScale9Slice(Button_cell, 15, 15, 11, 11)
	GUI:setContentSize(Button_cell, 120, 40)
	GUI:setIgnoreContentAdaptWithSize(Button_cell, false)
	GUI:Button_setTitleText(Button_cell, "等级提升")
	GUI:Button_setTitleColor(Button_cell, "#ffffff")
	GUI:Button_setTitleFontSize(Button_cell, 14)
	GUI:Button_titleEnableOutline(Button_cell, "#000000", 1)
	GUI:setChineseName(Button_cell, "气泡_列表操作_按钮")
	GUI:setAnchorPoint(Button_cell, 0.50, 0.50)
	GUI:setTouchEnabled(Button_cell, true)
	GUI:setTag(Button_cell, 27)
end
return ui