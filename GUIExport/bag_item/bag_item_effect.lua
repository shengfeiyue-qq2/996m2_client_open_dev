local ui = {}
function ui.init(parent)
	-- Create Node
	local Node = GUI:Node_Create(parent, "Node", 0.00, 0.00)
	GUI:setChineseName(Node, "背包物品特效")
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1)

	-- Create Node_sfx_power
	local Node_sfx_power = GUI:Node_Create(Node, "Node_sfx_power", 24.00, 0.00)
	GUI:setChineseName(Node_sfx_power, "背包物品_特效开关_节点")
	GUI:setAnchorPoint(Node_sfx_power, 0.50, 0.50)
	GUI:setTag(Node_sfx_power, 24)

	-- Create Node_left_top
	local Node_left_top = GUI:Node_Create(Node, "Node_left_top", 24.00, 24.00)
	GUI:setChineseName(Node_left_top, "背包物品_左上角_节点")
	GUI:setAnchorPoint(Node_left_top, 0.50, 0.50)
	GUI:setTag(Node_left_top, 30)
end
return ui