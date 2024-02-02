local ui = {}
function ui.init(parent)
	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(parent, "Panel_1", 568.00, 320.00, 105.00, 35.00, false)
	GUI:setChineseName(Panel_1, "拍卖行_我要寄售组合框")
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 58)

	-- Create Button_group
	local Button_group = GUI:Button_Create(Panel_1, "Button_group", 52.00, 17.00, "res/public/1900000680_1.png")
	GUI:Button_loadTexturePressed(Button_group, "res/public/1900000680.png")
	GUI:Button_loadTextureDisabled(Button_group, "res/public/1900000680.png")
	GUI:Button_setScale9Slice(Button_group, 36, 34, 14, 12)
	GUI:setContentSize(Button_group, 105, 32)
	GUI:setIgnoreContentAdaptWithSize(Button_group, false)
	GUI:Button_setTitleText(Button_group, "我要寄售")
	GUI:Button_setTitleColor(Button_group, "#6c6861")
	GUI:Button_setTitleFontSize(Button_group, 18)
	GUI:Button_titleEnableOutline(Button_group, "#111111", 2)
	GUI:setChineseName(Button_group, "拍卖行_我要寄售按钮")
	GUI:setAnchorPoint(Button_group, 0.50, 0.50)
	GUI:setTouchEnabled(Button_group, true)
	GUI:setTag(Button_group, 56)

	-- Create Node_redtips
	local Node_redtips = GUI:Node_Create(Panel_1, "Node_redtips", 95.00, 27.00)
	GUI:setChineseName(Node_redtips, "拍卖行_我要寄售节点")
	GUI:setAnchorPoint(Node_redtips, 0.50, 0.50)
	GUI:setTag(Node_redtips, 81)
end
return ui