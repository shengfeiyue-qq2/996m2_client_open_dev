local ui = {}
function ui.init(parent)
	-- Create Node
	local Node = GUI:Node_Create(parent, "Node", 0.00, 0.00)
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1)

	-- Create Panel_bg
	local Panel_bg = GUI:Layout_Create(Node, "Panel_bg", 0.00, 0.00, 240.00, 40.00, false)
	GUI:setAnchorPoint(Panel_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_bg, true)
	GUI:setTag(Panel_bg, 19)

	-- Create Node_tips
	local Node_tips = GUI:Node_Create(Panel_bg, "Node_tips", 80.00, 20.00)
	GUI:setAnchorPoint(Node_tips, 0.50, 0.50)
	GUI:setTag(Node_tips, 48)

	-- Create Node_icon
	local Node_icon = GUI:Node_Create(Panel_bg, "Node_icon", 120.00, 20.00)
	GUI:setAnchorPoint(Node_icon, 0.50, 0.50)
	GUI:setTag(Node_icon, 24)

	-- Create Node_count
	local Node_count = GUI:Node_Create(Panel_bg, "Node_count", 140.00, 20.00)
	GUI:setAnchorPoint(Node_count, 0.50, 0.50)
	GUI:setTag(Node_count, 24)
end
return ui