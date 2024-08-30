local ui = {}
function ui.init(parent)
	-- Create Scene
	local Scene = GUI:Node_Create(parent, "Scene", 0.00, 0.00)
	GUI:setChineseName(Scene, "通用下拉场景")
	GUI:setAnchorPoint(Scene, 0.50, 0.50)
	GUI:setTag(Scene, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Scene, "Panel_1", 0.00, 0.00, 1136.00, 640.00, false)
	GUI:setChineseName(Panel_1, "通用下拉组合")
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 479)

	-- Create Panel_2
	local Panel_2 = GUI:Layout_Create(Panel_1, "Panel_2", 568.00, 320.00, 400.00, 300.00, false)
	GUI:Layout_setBackGroundImageScale9Slice(Panel_2, 21, -649, 33, -367)
	GUI:Layout_setBackGroundImage(Panel_2, "res/public/1900000677.png")
	GUI:setChineseName(Panel_2, "通用下拉组合")
	GUI:setAnchorPoint(Panel_2, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_2, true)
	GUI:setTag(Panel_2, 480)

	-- Create Node
	local Node = GUI:Node_Create(Panel_2, "Node", 32.00, 270.00)
	GUI:setChineseName(Node, "通用下拉_节点")
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, 485)
end
return ui