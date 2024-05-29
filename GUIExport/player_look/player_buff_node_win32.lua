local ui = {}
function ui.init(parent)
	-- Create Node
	local Node = GUI:Node_Create(parent, "Node", 0.00, 0.00)
	GUI:setChineseName(Node, "玩家buff节点")
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(Node, "Panel_1", 0.00, 0.00, 272.00, 349.00, false)
	GUI:setChineseName(Panel_1, "玩家buff组合")
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 41)

	-- Create ListView_buff
	local ListView_buff = GUI:ListView_Create(Panel_1, "ListView_buff", 0.00, 5.00, 272.00, 340.00, 1)
	GUI:ListView_setGravity(ListView_buff, 5)
	GUI:setChineseName(ListView_buff, "玩家buff_列表")
	GUI:setTouchEnabled(ListView_buff, true)
	GUI:setTag(ListView_buff, 24)
end
return ui