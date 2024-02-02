local ui = {}
function ui.init(parent)
	-- Create item_money
	local item_money = GUI:Layout_Create(parent, "item_money", 0.00, 0.00, 150.00, 30.00, false)
	GUI:setTouchEnabled(item_money, false)
	GUI:setTag(item_money, -1)

	-- Create Node_cost
	local Node_cost = GUI:Node_Create(item_money, "Node_cost", 10.00, 15.00)
	GUI:setAnchorPoint(Node_cost, 0.50, 0.50)
	GUI:setTag(Node_cost, -1)

	-- Create Text_num
	local Text_num = GUI:Text_Create(item_money, "Text_num", 40.00, 16.00, 15, "#ffffff", [[999/999]])
	GUI:setAnchorPoint(Text_num, 0.00, 0.50)
	GUI:setTouchEnabled(Text_num, false)
	GUI:setTag(Text_num, -1)
	GUI:Text_enableOutline(Text_num, "#000000", 1)
end
return ui