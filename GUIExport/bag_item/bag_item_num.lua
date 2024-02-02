local ui = {}
function ui.init(parent)
	-- Create Node
	local Node = GUI:Node_Create(parent, "Node", 0.00, 0.00)
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1)

	-- Create Node_count
	local Node_count = GUI:Node_Create(Node, "Node_count", 0.00, 0.00)
	GUI:setAnchorPoint(Node_count, 0.50, 0.50)
	GUI:setTag(Node_count, 10)

	-- Create Node_star_lv
	local Node_star_lv = GUI:Node_Create(Node, "Node_star_lv", 0.00, 0.00)
	GUI:setAnchorPoint(Node_star_lv, 0.50, 0.50)
	GUI:setTag(Node_star_lv, 10)
	GUI:setVisible(Node_star_lv, false)

	-- Create Node_needNum
	local Node_needNum = GUI:Node_Create(Node, "Node_needNum", 0.00, 0.00)
	GUI:setAnchorPoint(Node_needNum, 0.50, 0.50)
	GUI:setTag(Node_needNum, 10)
	GUI:setVisible(Node_needNum, false)
end
return ui