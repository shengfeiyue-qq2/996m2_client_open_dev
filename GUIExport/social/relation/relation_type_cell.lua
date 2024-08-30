local ui = {}
function ui.init(parent)
	-- Create Button_relation
	local Button_relation = GUI:Button_Create(parent, "Button_relation", 69.00, 27.00, "res/public/1900000663.png")
	GUI:Button_loadTextureDisabled(Button_relation, "res/public/1900000662.png")
	GUI:Button_setScale9Slice(Button_relation, 15, 15, 11, 11)
	GUI:setContentSize(Button_relation, 115, 37)
	GUI:setIgnoreContentAdaptWithSize(Button_relation, false)
	GUI:Button_setTitleText(Button_relation, "关系1")
	GUI:Button_setTitleColor(Button_relation, "#f8e6c6")
	GUI:Button_setTitleFontSize(Button_relation, 18)
	GUI:Button_titleEnableOutline(Button_relation, "#111111", 2)
	GUI:setChineseName(Button_relation, "关系类型_按钮")
	GUI:setAnchorPoint(Button_relation, 0.50, 0.50)
	GUI:setTouchEnabled(Button_relation, true)
	GUI:setTag(Button_relation, 39)
end
return ui