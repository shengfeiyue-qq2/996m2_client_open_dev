local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create Panel_cancel
	local Panel_cancel = GUI:Layout_Create(Scene, "Panel_cancel", 0.00, 0.00, 1136.00, 640.00, false)
	GUI:Layout_setBackGroundColorType(Panel_cancel, 1)
	GUI:Layout_setBackGroundColor(Panel_cancel, "#000000")
	GUI:Layout_setBackGroundColorOpacity(Panel_cancel, 102)
	GUI:setTouchEnabled(Panel_cancel, true)
	GUI:setTag(Panel_cancel, 45)

	-- Create Node_1
	local Node_1 = GUI:Node_Create(Scene, "Node_1", 394.00, 320.00)
	GUI:setAnchorPoint(Node_1, 0.50, 0.50)
	GUI:setTag(Node_1, 46)

	-- Create Node_2
	local Node_2 = GUI:Node_Create(Scene, "Node_2", 818.00, 320.00)
	GUI:setAnchorPoint(Node_2, 0.50, 0.50)
	GUI:setTag(Node_2, 47)
end
return ui