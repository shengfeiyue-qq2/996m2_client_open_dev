local ui = {}
function ui.init(parent)
	-- Create Panel_cell
	local Panel_cell = GUI:Layout_Create(parent, "Panel_cell", 0.00, 0.00, 85.00, 30.00, false)
	GUI:setChineseName(Panel_cell, "右键弹出窗口组合")
	GUI:setTouchEnabled(Panel_cell, true)
	GUI:setTag(Panel_cell, 9)

	-- Create Text_name
	local Text_name = GUI:Text_Create(Panel_cell, "Text_name", 42.00, 15.00, 18, "#ffffff", [[功能描述]])
	GUI:setChineseName(Text_name, "右键弹出项目_名称_文本")
	GUI:setAnchorPoint(Text_name, 0.50, 0.50)
	GUI:setTouchEnabled(Text_name, false)
	GUI:setTag(Text_name, 10)
	GUI:Text_enableOutline(Text_name, "#000000", 1)
end
return ui