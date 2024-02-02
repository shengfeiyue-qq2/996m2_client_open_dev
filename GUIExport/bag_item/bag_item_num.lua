local ui = {}
function ui.init(parent)
	-- Create Node
	local Node = GUI:Node_Create(parent, "Node", 0.00, 0.00)
	GUI:setChineseName(Node, "背包物品数量节点")
	GUI:setAnchorPoint(Node, 0.50, 0.50)
	GUI:setTag(Node, -1)

	-- Create Layout
	local Layout = GUI:Layout_Create(Node, "Layout", 0.00, 0.00, 60.00, 60.00, false)
	GUI:setChineseName(Layout, "背包物品数量组合")
	GUI:setAnchorPoint(Layout, 0.50, 0.50)
	GUI:setTouchEnabled(Layout, false)
	GUI:setTag(Layout, -1)

	-- Create Text_count
	local Text_count = GUI:Text_Create(Layout, "Text_count", 58.00, 10.00, 15, "#ffffff", [[1000]])
	GUI:setChineseName(Text_count, "背包物品_数量_文本")
	GUI:setAnchorPoint(Text_count, 1.00, 0.50)
	GUI:setTouchEnabled(Text_count, false)
	GUI:setTag(Text_count, -1)
	GUI:Text_enableOutline(Text_count, "#000000", 2)

	-- Create Text_star_lv
	local Text_star_lv = GUI:Text_Create(Layout, "Text_star_lv", 4.00, 58.00, 18, "#efad21", [[0]])
	GUI:setChineseName(Text_star_lv, "背包物品_强化等级_文本")
	GUI:setAnchorPoint(Text_star_lv, 0.00, 1.00)
	GUI:setTouchEnabled(Text_star_lv, false)
	GUI:setTag(Text_star_lv, -1)
	GUI:Text_enableOutline(Text_star_lv, "#000000", 1)

	-- Create Node_needNum
	local Node_needNum = GUI:Node_Create(Layout, "Node_needNum", 58.00, 10.00)
	GUI:setChineseName(Node_needNum, "背包物品_需要数量_节点")
	GUI:setAnchorPoint(Node_needNum, 0.50, 0.50)
	GUI:setTag(Node_needNum, 10)
end
return ui