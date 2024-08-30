local ui = {}
function ui.init(parent)
	-- Create Panel_icon
	local Panel_icon = GUI:Layout_Create(parent, "Panel_icon", 0.00, 0.00, 48.00, 30.00, false)
	GUI:setAnchorPoint(Panel_icon, 0.00, 0.50)
	GUI:setTouchEnabled(Panel_icon, false)
	GUI:setTag(Panel_icon, -1)

	-- Create Node_icon
	local Node_icon = GUI:Node_Create(Panel_icon, "Node_icon", 10.00, 16.00)
	GUI:setAnchorPoint(Node_icon, 0.50, 0.50)
	GUI:setScaleX(Node_icon, 0.60)
	GUI:setScaleY(Node_icon, 0.60)
	GUI:setTag(Node_icon, 71)

	-- Create Node_count
	local Node_count = GUI:Node_Create(Panel_icon, "Node_count", 20.00, 16.00)
	GUI:setAnchorPoint(Node_count, 0.50, 0.50)
	GUI:setTag(Node_count, 71)
end
return ui