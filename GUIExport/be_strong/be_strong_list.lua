local ui = {}
function ui.init(parent)
	-- Create Node
	local Node = GUI:Node_Create(parent, "Node", 593.00, 286.00)
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1)

	-- Create CloseLayout
	local CloseLayout = GUI:Layout_Create(Node, "CloseLayout", -100.00, -100.00, 200.00, 300.00, false)
	GUI:setTouchEnabled(CloseLayout, true)
	GUI:setTag(CloseLayout, -1)

	-- Create Panel_bg
	local Panel_bg = GUI:Layout_Create(Node, "Panel_bg", -65.00, 30.00, 130.00, 90.00, false)
	GUI:Layout_setBackGroundImage(Panel_bg, "res/public/1900000677.png")
	GUI:Layout_setBackGroundImageScale9Slice(Panel_bg, 21, 21, 33, 33)
	GUI:setTouchEnabled(Panel_bg, true)
	GUI:setTag(Panel_bg, 25)

	-- Create Layout
	local Layout = GUI:Layout_Create(Panel_bg, "Layout", 36.00, -62.00, 60.00, 60.00, false)
	GUI:setTouchEnabled(Layout, true)
	GUI:setTag(Layout, -1)

	-- Create ListView
	local ListView = GUI:ListView_Create(Panel_bg, "ListView", 5.00, 5.00, 120.00, 80.00, 1)
	GUI:ListView_setGravity(ListView, 5)
	GUI:ListView_setItemsMargin(ListView, 5)
	GUI:setTouchEnabled(ListView, true)
	GUI:setTag(ListView, 26)

	-- Create Button
	local Button = GUI:Button_Create(Panel_bg, "Button", 65.00, 132.00, "res/public/1900000662.png")
	GUI:Button_loadTexturePressed(Button, "res/public/1900000663.png")
	GUI:Button_setScale9Slice(Button, 15, 15, 11, 11)
	GUI:setContentSize(Button, 120, 40)
	GUI:setIgnoreContentAdaptWithSize(Button, false)
	GUI:Button_setTitleText(Button, "等级提升")
	GUI:Button_setTitleColor(Button, "#ffffff")
	GUI:Button_setTitleFontSize(Button, 14)
	GUI:Button_titleEnableOutline(Button, "#000000", 1)
	GUI:setAnchorPoint(Button, 0.50, 0.50)
	GUI:setTouchEnabled(Button, true)
	GUI:setTag(Button, 27)
end
return ui