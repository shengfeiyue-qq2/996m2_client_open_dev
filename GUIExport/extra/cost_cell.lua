local ui = {}
function ui.init(parent)
	-- Create Node
	local Node = GUI:Node_Create(parent, "Node", 0.00, 0.00)
	GUI:setChineseName(Node, "通用描述节点")
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1)

	-- Create Panel_bg
	local Panel_bg = GUI:Layout_Create(Node, "Panel_bg", 0.00, 0.00, 240.00, 40.00, false)
	GUI:setChineseName(Panel_bg, "通用描述背景图")
	GUI:setAnchorPoint(Panel_bg, 0.50, 0.50)
	GUI:setTouchEnabled(Panel_bg, true)
	GUI:setTag(Panel_bg, 19)

	-- Create Node_title
	local Node_title = GUI:Node_Create(Panel_bg, "Node_title", 80.00, 20.00)
	GUI:setChineseName(Node_title, "通用描述_标题_节点")
	GUI:setAnchorPoint(Node_title, 0.50, 0.50)
	GUI:setTag(Node_title, 48)

	-- Create Node_icon
	local Node_icon = GUI:Node_Create(Panel_bg, "Node_icon", 120.00, 20.00)
	GUI:setChineseName(Node_icon, "通用描述_图标_节点")
	GUI:setAnchorPoint(Node_icon, 0.50, 0.50)
	GUI:setTag(Node_icon, 24)

	-- Create Node_count
	local Node_count = GUI:Node_Create(Panel_bg, "Node_count", 140.00, 20.00)
	GUI:setChineseName(Node_count, "通用描述_数量_节点")
	GUI:setAnchorPoint(Node_count, 0.50, 0.50)
	GUI:setTag(Node_count, 24)
end
return ui