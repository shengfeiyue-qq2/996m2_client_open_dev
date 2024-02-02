local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create Panel_cancel
	local Panel_cancel = GUI:Layout_Create(Scene, "Panel_cancel", 0.00, 0.00, 1136.00, 640.00, false)
	GUI:setTouchEnabled(Panel_cancel, true)
	GUI:setTag(Panel_cancel, 33)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Scene, "Panel_1", 337.00, 320.00, 455.00, 550.00, false)
	GUI:setAnchorPoint(Panel_1, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 21)

	-- Create Node_1
	local Node_1 = GUI:Node_Create(Panel_1, "Node_1", 227.00, 275.00)
	GUI:setAnchorPoint(Node_1, 0.50, 0.50)
	GUI:setTag(Node_1, 32)
end
return ui