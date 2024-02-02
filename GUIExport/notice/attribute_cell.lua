local ui = {}
function ui.init(parent)
	-- Create Node_cell
	local Node_cell = GUI:Node_Create(parent, "Node_cell", 0.00, 0.00)
	GUI:setChineseName(Node_cell, "属性节点")
	GUI:setAnchorPoint(Node_cell, 0.50, 0.50)
	GUI:setTag(Node_cell, -1)

	-- Create cell
	local cell = GUI:Node_Create(Node_cell, "cell", 0.00, 0.00)
	GUI:setChineseName(cell, "属性_组合")
	GUI:setAnchorPoint(cell, 0.50, 0.50)
	GUI:setTag(cell, 29)

	-- Create Panel_1
	local Panel_1 = GUI:Layout_Create(cell, "Panel_1", 0.00, 0.00, 120.00, 20.00, false)
	GUI:Layout_setBackGroundColorType(Panel_1, 1)
	GUI:Layout_setBackGroundColor(Panel_1, "#000000")
	GUI:Layout_setBackGroundColorOpacity(Panel_1, 102)
	GUI:setChineseName(Panel_1, "属性_背景框")
	GUI:setAnchorPoint(Panel_1, 0.00, 0.50)
	GUI:setTouchEnabled(Panel_1, true)
	GUI:setTag(Panel_1, 16)
	GUI:setVisible(Panel_1, false)

	-- Create Text_name
	local Text_name = GUI:Text_Create(cell, "Text_name", 0.00, 0.00, 16, "#ffffff", [[攻击]])
	GUI:setChineseName(Text_name, "属性_名称_文本")
	GUI:setAnchorPoint(Text_name, 0.00, 0.50)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, 14)
	GUI:Text_disableOutLine(Text_name)

	-- Create Text_attr
	local Text_attr = GUI:Text_Create(cell, "Text_attr", 50.00, 0.00, 16, "#ffffff", [[50-50]])
	GUI:setChineseName(Text_attr, "属性_值_文本")
	GUI:setAnchorPoint(Text_attr, 0.00, 0.50)
	GUI:setTouchEnabled(Text_attr, false)
	GUI:setTag(Text_attr, 15)
	GUI:Text_disableOutLine(Text_attr)
end
return ui