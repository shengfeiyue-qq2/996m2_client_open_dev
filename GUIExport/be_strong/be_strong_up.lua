local ui = {}
function ui.init(parent)
	-- Create Node
	local Node = GUI:Node_Create(parent, "Node", 0.00, 0.00)
	GUI:setChineseName(Node, "气泡节点")
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1)

	-- Create Button_up
	local Button_up = GUI:Button_Create(Node, "Button_up", 0.00, 0.00, "res/private/be_strong/bg_jindutiao_11.png")
	GUI:Button_setScale9Slice(Button_up, 15, 15, 11, 11)
	GUI:setContentSize(Button_up, 59, 59)
	GUI:setIgnoreContentAdaptWithSize(Button_up, false)
	GUI:Button_setTitleText(Button_up, "")
	GUI:Button_setTitleColor(Button_up, "#414146")
	GUI:Button_setTitleFontSize(Button_up, 14)
	GUI:Button_titleDisableOutLine(Button_up)
	GUI:setChineseName(Button_up, "气泡_提升_按钮")
	GUI:setAnchorPoint(Button_up, 0.50, 0.50)
	GUI:setTouchEnabled(Button_up, true)
	GUI:setTag(Button_up, 18)

	-- Create Panel_bg
	local Panel_bg = GUI:Layout_Create(Node, "Panel_bg", -65.00, 30.00, 130.00, 90.00, false)
	GUI:Layout_setBackGroundImage(Panel_bg, "res/public/1900000677.png")
	GUI:Layout_setBackGroundImageScale9Slice(Panel_bg, 21, 21, 33, 33)
	GUI:setChineseName(Panel_bg, "气泡_提升列表组合")
	GUI:setTouchEnabled(Panel_bg, true)
	GUI:setTag(Panel_bg, 25)

	-- Create ListView
	local ListView = GUI:ListView_Create(Panel_bg, "ListView", 5.00, 5.00, 120.00, 80.00, 1)
	GUI:ListView_setGravity(ListView, 5)
	GUI:ListView_setItemsMargin(ListView, 5)
	GUI:setChineseName(ListView, "气泡_列表(动态)")
	GUI:setTouchEnabled(ListView, true)
	GUI:setTag(ListView, 26)
end
return ui