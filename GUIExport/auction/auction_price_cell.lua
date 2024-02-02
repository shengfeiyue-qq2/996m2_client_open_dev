local ui = {}
function ui.init(parent)
	-- Create Node
	local Node = GUI:Node_Create(parent, "Node", 0.00, 0.00)
	GUI:setChineseName(Node, "拍卖货币节点")
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1)

	-- Create Panel_bg
	local Panel_bg = GUI:Layout_Create(Node, "Panel_bg", 1.00, 0.00, 120.00, 50.00, false)
	GUI:setChineseName(Panel_bg, "拍卖货币组合")
	GUI:setAnchorPoint(Panel_bg, 1.00, 0.50)
	GUI:setTouchEnabled(Panel_bg, false)
	GUI:setTag(Panel_bg, 49)

	-- Create Node_item
	local Node_item = GUI:Layout_Create(Panel_bg, "Node_item", 55.00, 25.00, 0.00, 0.00, false)
	GUI:Layout_setBackGroundColorType(Node_item, 1)
	GUI:Layout_setBackGroundColor(Node_item, "#96c8ff")
	GUI:Layout_setBackGroundColorOpacity(Node_item, 102)
	GUI:setChineseName(Node_item, "拍卖货币_节点")
	GUI:setAnchorPoint(Node_item, 0.50, 0.50)
	GUI:setTouchEnabled(Node_item, true)
	GUI:setTag(Node_item, 236)

	-- Create Text_count
	local Text_count = GUI:Text_Create(Panel_bg, "Text_count", 91.50, 25.00, 16, "#ffffff", [[666666]])
	GUI:setChineseName(Text_count, "拍卖货币_数量_文本")
	GUI:setAnchorPoint(Text_count, 0.50, 0.50)
	GUI:setTouchEnabled(Text_count, false)
	GUI:setTag(Text_count, 53)
	GUI:Text_enableOutline(Text_count, "#111111", 1)
end
return ui